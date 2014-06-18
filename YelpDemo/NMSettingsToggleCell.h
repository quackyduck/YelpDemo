//
//  NNSettingsToggleCell.h
//  YelpDemo
//
//  Created by Nicolas Melo on 6/17/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NMSettingsToggleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *toggleSwitch;

@end
