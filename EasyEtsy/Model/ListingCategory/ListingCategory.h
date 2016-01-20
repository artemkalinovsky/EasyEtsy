//
//  ListingCategory.h
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 26/08/2015.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

@import Foundation;

@interface ListingCategory : NSObject

@property (strong, nonatomic) NSNumber *categoryId;
@property (strong, nonatomic) NSString *categoryName;
@property (strong, nonatomic) NSString *categoryShortName;
@property (strong, nonatomic) NSString *categoryLongName;

- (instancetype)initWithJSON:(NSDictionary *)jsonSerializedCategory;

@end
