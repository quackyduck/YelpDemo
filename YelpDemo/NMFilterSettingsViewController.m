//
//  NMFilterSettingsViewController.m
//  YelpDemo
//
//  Created by Nicolas Melo on 6/13/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "NMFilterSettingsViewController.h"
#import "NMSearchListingsViewController.h"
#import "NMFilterSettings.h"
#import "NMSettingsRadioCell.h"
#import "NMSettingsToggleCell.h"
#import "NMSeeAllCell.h"

@interface NMFilterSettingsViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) UILabel *filtersTitleLabel;
@property (strong, nonatomic) NSArray *distanceOptions;
@property (strong, nonatomic) NSArray *sortOptions;
@property (strong, nonatomic) NSMutableDictionary *collapsed;
@property (strong, nonatomic) NMSeeAllCell *seeAllCell;
@end


@implementation NMFilterSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.filtersTitleLabel = [[UILabel alloc] init];
        self.settings = [[NMFilterSettings alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.collapsed = [NSMutableDictionary dictionary];
    for (int i=0; i < self.settings.layout.count; i++) {
        self.collapsed[@(i)] = @(YES);
    }
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Search" style:UIBarButtonItemStyleBordered target:self action:@selector(search:)];

    self.filtersTitleLabel.text = @"Filters";
    self.filtersTitleLabel.textColor = [UIColor whiteColor];
    [self.filtersTitleLabel sizeToFit];
    
    self.navigationItem.titleView = self.filtersTitleLabel;
    
    UINib *radioNib = [UINib nibWithNibName:@"NMSettingsRadioCell" bundle:nil];
    [self.tableView registerNib:radioNib forCellReuseIdentifier:@"radioCell"];
    
    UINib *toggleNib = [UINib nibWithNibName:@"NMSettingsToggleCell" bundle:nil];
    [self.tableView registerNib:toggleNib forCellReuseIdentifier:@"toggleCell"];
    
    UINib *seeAllNib = [UINib nibWithNibName:@"NMSeeAllCell" bundle:nil];
    [self.tableView registerNib:seeAllNib forCellReuseIdentifier:@"seeAllCell"];
    
    self.seeAllCell = [self.tableView dequeueReusableCellWithIdentifier:@"seeAllCell"];

}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadFilters];
}

- (void)cancel: (id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)search: (id)sender {
    [self saveFilters];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)saveFilters {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:self.settings.filters forKey:@"FILTER_SETTINGS"];
    [userDefaults synchronize];
}

- (void)loadFilters {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:@"FILTER_SETTINGS"]) {
        NSDictionary *savedDefaults = [userDefaults objectForKey:@"FILTER_SETTINGS"];
        self.settings.filters = [[NSMutableDictionary alloc] initWithDictionary:savedDefaults];
        [self.tableView reloadData];
    }
}

- (void)switchChanged:(id)sender {
    UISwitch *switchInCell = (UISwitch *)sender;
    CGPoint hitPoint = [sender convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexpath = [self.tableView indexPathForRowAtPoint:hitPoint];
    
    NMSettingsToggleCell *cell = (NMSettingsToggleCell *) [self.tableView cellForRowAtIndexPath:indexpath];
    
    
    
    if (indexpath.section == 0) {
        self.settings.filters[@"deals_filter"] = @(switchInCell.on);
    }
    else if (indexpath.section == 3) {
        NSString *category = cell.titleLabel.text;
        NSDictionary *general = self.settings.layout[indexpath.section];
        NSArray *categories = general.allValues[0];
        
        NSArray *existingCategories = self.settings.filters[@"category_filter"];
        NSMutableArray *newCategories = [NSMutableArray arrayWithArray:existingCategories];

        for (NSArray *tuple in categories) {
            if ([tuple[1] isEqualToString:category]) {
                // we have the appropriate cell and setting
                
                if (switchInCell.on) {
                    if (![newCategories containsObject:tuple[0]]) {
                        [newCategories addObject:tuple[0]];
                    }
                }
                else {
                    if ([newCategories containsObject:tuple[0]]) {
                        [newCategories removeObject:tuple[0]];
                    }
                }
            }
        }
        self.settings.filters[@"category_filter"] = [NSMutableArray arrayWithArray:newCategories];
    }
         
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.settings.layout.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSDictionary *layout = self.settings.layout[section];
    NSArray *rows = layout.allValues[0];
    
    if (section == 1 || section == 2) {
        return [self.collapsed[@(section)] boolValue] ? 1 : rows.count;
    }
    else if (section == 3) {
        return [self.collapsed[@(section)] boolValue] ? 4 : rows.count;
    }
    
    return rows.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger rowInSection = indexPath.row;
    NSDictionary *layout = self.settings.layout[indexPath.section];
    if (indexPath.section == 0) {
        // Most Popular
        NMSettingsToggleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toggleCell"];
        NSArray *popular = layout.allValues;
        NSDictionary *deals = popular[0];
        cell.titleLabel.text = deals.allKeys[rowInSection];
        cell.toggleSwitch.on = [self.settings.filters[@"deals_filter"] isEqual:@(0)] ? NO : YES;
        [cell.toggleSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else if (indexPath.section == 1) {
        // Distance
        NMSettingsRadioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"radioCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *distanceOptions = layout.allValues[0];
        NSNumber *distance = self.settings.filters[@"radius_filter"];
        
        if ([self.collapsed[@(indexPath.section)] boolValue] == YES) {
            // We are collapsed, show the selected item
            cell.titleLabel.text = distanceOptions[[distance intValue]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            // We are expanded, show all the items in place
            if ([distance integerValue] == indexPath.row) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.titleLabel.text = distanceOptions[indexPath.row];
        }
        
        return cell;
    }
    else if (indexPath.section == 2) {
        // sort by
        NMSettingsRadioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"radioCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *sortOptions = layout.allValues[0];
        NSNumber *sort = self.settings.filters[@"sort"];
        
        if ([self.collapsed[@(indexPath.section)] boolValue]) {
            // collapsed
            cell.titleLabel.text = sortOptions[[sort intValue]];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            // expanded
            if ([sort integerValue] == indexPath.row) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }
            else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
            cell.titleLabel.text = sortOptions[rowInSection];
        }

        return cell;
    }
    else {
        // Categories
        NMSettingsToggleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"toggleCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        NSArray *categories = layout.allValues[0];
        NSString *internalCategoryName = categories[rowInSection][0];
        NSArray *existingCategories = self.settings.filters[@"category_filter"];
        
        if ([self.collapsed[@(indexPath.section)] boolValue]) {
            // collapsed shows 4 cells - 3 plus the See All
            if (rowInSection < 3) {
                cell.titleLabel.text = categories[rowInSection][1];
                cell.toggleSwitch.on = [existingCategories containsObject:internalCategoryName];
                [cell.toggleSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            }
            else {
                // See All cell
                return self.seeAllCell;
            }
        }
        else {
            // expanded
            cell.titleLabel.text = categories[rowInSection][1];
            cell.toggleSwitch.on = [existingCategories containsObject:internalCategoryName];
            [cell.toggleSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        }

        return cell;
    }
    
    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSDictionary *layout = self.settings.layout[section];
    return layout.allKeys[0];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        
        if (![self.collapsed[@(indexPath.section)] boolValue]) {
            // Currently expanded
            NMSettingsRadioCell* cell = (NMSettingsRadioCell *)[tableView cellForRowAtIndexPath:indexPath];
            if (cell.accessoryType == UITableViewCellAccessoryNone) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.settings.filters[@"radius_filter"] = @(indexPath.row);
            }
        }
        self.collapsed[@(indexPath.section)] = @(![self.collapsed[@(indexPath.section)] boolValue]);
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        return;
    }
    else if (indexPath.section == 2) {
        if (![self.collapsed[@(indexPath.section)] boolValue]) {
            // Currently expanded
            NMSettingsRadioCell* cell = (NMSettingsRadioCell *)[tableView cellForRowAtIndexPath:indexPath];
            if (cell.accessoryType == UITableViewCellAccessoryNone) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                self.settings.filters[@"sort"] = @(indexPath.row);
            }
        }
        
        self.collapsed[@(indexPath.section)] = @(![self.collapsed[@(indexPath.section)] boolValue]);
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        return;
    }
    else if (indexPath.section == 3) {
        if ([self.collapsed[@(indexPath.section)] boolValue]) {
            self.collapsed[@(indexPath.section)] = @(![self.collapsed[@(indexPath.section)] boolValue]);
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }
}

@end
