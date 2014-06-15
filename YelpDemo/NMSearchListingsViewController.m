//
//  NMSearchListingsViewController.m
//  YelpDemo
//
//  Created by Nicolas Melo on 6/13/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "NMSearchListingsViewController.h"
#import "NMFilterSettingsViewController.h"
#import "NMFiltersNavigationController.h"
#import "YelpClient.h"
#import "NMYelpListing.h"

NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface NMSearchListingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UISearchBar *listingsSearchBar;
@property (strong, nonatomic) YelpClient *client;
@property (strong, nonatomic) NSMutableArray *listingsArray;
@property (strong, nonatomic) NSMutableDictionary *searchParameters;

@end

@implementation NMSearchListingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        self.listingsArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.listingsSearchBar = [[UISearchBar alloc] init];
        self.searchParameters = [[NSMutableDictionary alloc] initWithDictionary:@{@"location": @"San Francisco", @"limit": @(20), @"offset": @(0)}];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.listingsSearchBar.delegate = self;
    
    self.navigationItem.titleView = self.listingsSearchBar;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filter" style:UIBarButtonItemStylePlain target:self action:@selector(filterSettings:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchListings:(NSDictionary *)parameters {
    
    [self.searchParameters addEntriesFromDictionary:parameters];
    
    [self.client searchWithTerm:self.searchParameters success:^(AFHTTPRequestOperation *operation, id response) {
        
        if ([self.searchParameters valueForKey:@"offset"] == 0) {
            [self.listingsArray removeAllObjects];
        }
        
        NSArray *businesses = response[@"businesses"];
        for (NSDictionary *business in businesses) {
            NMYelpListing *listing = [[NMYelpListing alloc] initWithDictionary:business];
            [self.listingsArray addObject:listing];
            NSLog(@"Business: %@", listing);
        }
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

#pragma mark - TableViewController Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listingsArray.count == 0 ? self.listingsArray.count : self.listingsArray.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    
    if (self.listingsArray.count > 0 && indexPath.row == self.listingsArray.count) {
        [self searchListings:@{@"offset": @(self.listingsArray.count)}];
    }
    else {
        NMYelpListing *business = self.listingsArray[indexPath.row];
        cell.textLabel.text = business.name;
    }
    
    return cell;
}

- (void)filterSettings:(id)sender {
    NMFilterSettingsViewController *filterSettings = [[NMFilterSettingsViewController alloc] init];
    filterSettings.searchListingsViewController = self;
    NMFiltersNavigationController *filtersNav = [[NMFiltersNavigationController alloc] initWithRootViewController:filterSettings];
    [self.navigationController presentViewController:filtersNav animated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
    NSLog(@"Search item: %@", theSearchBar.text);
    [self searchListings:@{@"term": theSearchBar.text}];
    [theSearchBar endEditing:YES];
}


@end
