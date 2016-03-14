//
//  EtsyWebServiceAPIConstants.m
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 27/08/2015.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import "EtsyWebServiceAPIConstants.h"

const struct EtsyAPISecurity EtsyAPISecurity = {
        .APIKey = @"l6pdqjuf7hdf97h1yvzadfce"
};

const struct EtsyAPIURL EtsyAPIURL = {
        .base = @"https://openapi.etsy.com/v2",
        .categories = @"/taxonomy/categories",
        .activeListings =  @"/listings/active",
        .listingImages = @"/listings/:listing_id/images"
};
