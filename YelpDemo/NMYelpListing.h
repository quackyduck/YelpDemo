//
//  NMYelpListing.h
//  YelpDemo
//
//  Created by Nicolas Melo on 6/15/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMYelpListing : NSObject

@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *address;
@property (copy, nonatomic) NSString *imageURL;
@property (copy, nonatomic) NSString *starsURL;
@property NSInteger reviewCount;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *distance;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
