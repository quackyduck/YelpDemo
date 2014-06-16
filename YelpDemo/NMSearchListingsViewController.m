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
#import "NMYelpListingCell.h"

#import <AFNetworking/AFNetworking.h>
#import "UIImageView+AFNetworking.h"

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
@property (strong, nonatomic) NMYelpListingCell *offscreenCell;

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
    
    UINib *cellNib = [UINib nibWithNibName:@"NMYelpListingCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"yelpCell"];
    NSArray *nibs = [cellNib instantiateWithOwner:nil options:nil];
    self.offscreenCell = nibs[0];
    
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
    return self.listingsArray.count;// == 0 ? self.listingsArray.count : self.listingsArray.count + 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88.f;
}

- (void)configureCell:(NMYelpListingCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NMYelpListing *business = self.listingsArray[indexPath.row];
    cell.nameLabel.text = business.name;
    cell.addressLabel.text = @"406 Folsom St, SoMa";
    cell.priceLabel.text = business.price;
    cell.distanceLabel.text = business.distance;
    
    NSURL *imageURL = [NSURL URLWithString:business.imageURL];
    NSURLRequest *imageRequest = [NSURLRequest requestWithURL:imageURL];
    
    [cell.listingImageView setImageWithURLRequest:imageRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.listingImageView.alpha = 0.0;
        cell.listingImageView.image = image;
        [UIView animateWithDuration:0.25
                         animations:^{
                             cell.listingImageView.alpha = 1.0;
                         }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to load Yelp item's pic.");
    }];
    
    NSURL *ratingsURL = [NSURL URLWithString:business.starsURL];
    NSURLRequest *ratingsRequest = [NSURLRequest requestWithURL:ratingsURL];
    
    [cell.ratingsImageView setImageWithURLRequest:ratingsRequest placeholderImage:nil success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        cell.ratingsImageView.alpha = 0.0;
        cell.ratingsImageView.image = image;
        [UIView animateWithDuration:0.25
                         animations:^{
                             cell.ratingsImageView.alpha = 1.0;
                         }];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Failed to load Yelp item's pic.");
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    [self configureCell:self.offscreenCell atIndexPath:indexPath];
//    [self.offscreenCell layoutSubviews];
//    CGFloat height = self.offscreenCell.contentView.frame.size.height;
//    
//    NSLog(@"Dynamic height: %f", height);
//    
    return 89;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (self.listingsArray.count > 0 && indexPath.row == self.listingsArray.count) {
//        UITableViewCell *cell = [[UITableViewCell alloc] init];
//        [self searchListings:@{@"offset": @(self.listingsArray.count)}];
//        return cell;
//    }
//    else {
        NMYelpListingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"yelpCell"];
    [self configureCell:cell atIndexPath:indexPath];
    
        
        return cell;
//    }
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
