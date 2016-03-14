//
//  EtsyWebServiceAPIConstants.h
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 27/08/2015.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

@import Foundation;

extern const struct EtsyAPISecurity {
    __unsafe_unretained NSString *APIKey;
} EtsyAPISecurity;


extern const struct EtsyAPIURL {
    __unsafe_unretained NSString *base;
    __unsafe_unretained NSString *categories;
    __unsafe_unretained NSString *activeListings;
    __unsafe_unretained NSString *listingImages;
} EtsyAPIURL;

typedef NS_ENUM(NSInteger, APIModelName) {
    APIModelNameCategory,
    APIModelNameListing
};
