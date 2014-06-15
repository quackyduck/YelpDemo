//
//  NMSearchListingsViewController.h
//  YelpDemo
//
//  Created by Nicolas Melo on 6/13/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMSearchListingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

- (void)searchListings:(NSDictionary *)parameters;

@end
