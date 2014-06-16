//
//  NMYelpListingCell.m
//  YelpDemo
//
//  Created by Nicolas Melo on 6/15/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "NMYelpListingCell.h"

@implementation NMYelpListingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
