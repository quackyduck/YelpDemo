//
//  NMYelpListing.m
//  YelpDemo
//
//  Created by Nicolas Melo on 6/15/14.
//  Copyright (c) 2014 melo. All rights reserved.
//

#import "NMYelpListing.h"

@implementation NMYelpListing

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self) {
        self.name = dictionary[@"name"];
        self.address = [NSArray arrayWithArray:dictionary[@"address"]];
        self.imageURL = dictionary[@"image_url"];
        self.starsURL = dictionary[@"rating_img_url"];
        self.reviewCount = [dictionary[@"review_count"] intValue];
        self.price = @"$$";
        self.distance = @"0.07 mi";
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if (self) {
    
        self.name = [coder decodeObjectForKey:@"name"];
        self.address = [coder decodeObjectForKey:@"address"];
        self.imageURL = [coder decodeObjectForKey:@"image_url"];
        self.starsURL = [coder decodeObjectForKey:@"rating_img_url"];
        self.reviewCount = [coder decodeIntegerForKey:@"review_count"];
        self.price = [coder decodeObjectForKey:@"price"];
        self.distance = [coder decodeObjectForKey:@"distance"];
    
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    if (self.name != nil) [coder encodeObject:self.name forKey:@"name"];
    if (self.address != nil) [coder encodeObject:self.address forKey:@"address"];
    if (self.imageURL != nil) [coder encodeObject:self.imageURL forKey:@"image_url"];
    if (self.starsURL != nil) [coder encodeObject:self.starsURL forKey:@"rating_img_url"];
    if (self.price != nil) [coder encodeObject:self.price forKey:@"price"];
    if (self.distance != nil) [coder encodeObject:self.distance forKey:@"distance"];
    [coder encodeInteger:self.reviewCount forKey:@"review_count"];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"name: %@, address %@, imageURL: %@, starsURL: %@, price: %@, distance: %@, reviewCount: %ld", self.name, self.address, self.imageURL, self.starsURL, self.price, self.distance, (long)self.reviewCount];
}


@end
