//
//  NMFilterSettings.m
//  YelpDemo
//
//  Created by Nicolas Melo on 6/16/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "NMFilterSettings.h"

@implementation NMFilterSettings

- (id)init {
    self = [super init];
    self.layout = @[@{@"Most Popular": @{@"Offering a Deal": @(NO)}},
                    @{@"Distance": @[@"Auto", @"2 blocks", @"6 blocks", @"1 mile", @"5 miles"]},
                    @{@"Sort by": @[@"Best Match", @"Distance", @"Rating", @"Most Reviewed"]},
                    @{@"General Features": @[
                        @[@"mexican", @"Mexican"],
                        @[@"french", @"French"],
                        @[@"spanish", @"Spanish"],
                        @[@"icecream", @"Ice Cream"],
                        @[@"pizza", @"Pizza"],
                        @[@"persian", @"Persian/Iranian"],
                        @[@"mongolian", @"Mongolian"],
                        @[@"pakistani", @"Pakistani"],
                        @[@"indpak", @"Indian"],
                        @[@"german", @"German"]
                    ]}];

    // @[@(200), @(600), @(1609), @(8046)]
    
    self.filters = [[NSMutableDictionary alloc] init];
    [self.filters setObject:@(NO) forKey:@"deals_filter"];
    [self.filters setObject:@(0) forKey:@"radius_filter"];
    [self.filters setObject:@(0) forKey:@"sort"];
    [self.filters setObject:@[] forKey:@"category_filter"];
    
    return self;
}

@end
