//
//  NMFilterSettingsViewController.h
//  YelpDemo
//
//  Created by Nicolas Melo on 6/13/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NMSearchListingsViewController;
@class NMFilterSettings;

@interface NMFilterSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) NMSearchListingsViewController *searchListingsViewController;
@property (strong, nonatomic) NMFilterSettings *settings;

@end
