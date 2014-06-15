//
//  NMFilterSettingsViewController.m
//  YelpDemo
//
//  Created by Nicolas Melo on 6/13/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "NMFilterSettingsViewController.h"
#import "NMSearchListingsViewController.h"

@interface NMFilterSettingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UILabel *filtersTitleLabel;

@end

@implementation NMFilterSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.filtersTitleLabel = [[UILabel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(search:)];

    self.filtersTitleLabel.text = @"Filters";
    [self.filtersTitleLabel sizeToFit];
    
    self.navigationItem.titleView = self.filtersTitleLabel;
    
}

- (void)cancel: (id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)search: (id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self.searchListingsViewController searchListings:@{}];
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingsCell"];
    return cell;
}

@end
