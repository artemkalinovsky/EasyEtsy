//
//  ListingCategory.m
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 26/08/2015.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import "ListingCategory.h"

@implementation ListingCategory

- (instancetype)initWithJSON:(NSDictionary *)jsonSerializedCategory {
    if (self = [super init]) {
        self.categoryId = jsonSerializedCategory[@"category_id"];
        self.categoryName = jsonSerializedCategory[@"category_name"];
        self.categoryShortName = jsonSerializedCategory[@"short_name"];
        self.categoryLongName = jsonSerializedCategory[@"long_name"];
    }
    return self;
}

@end
