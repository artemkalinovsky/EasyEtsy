//
//  EtsyWebServiceAPI.h
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 26/08/2015.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//
#import "EtsyWebServiceAPIConstants.h"

@import Foundation;

@class Listing;

typedef void (^EtsyWebServiceAPIResponse)(NSArray *, NSError *);

@interface EtsyWebServiceAPI : NSObject

+ (instancetype)sharedManager;

- (void)fetchDataForAPIModelName:(APIModelName)apiModelName
                      parameters:(NSDictionary *)parameters
                      completion:(EtsyWebServiceAPIResponse)completion;

- (void)fetchImageURLForListing:(Listing *)listing
                     completion:(void (^)(NSString *imageURLString, NSError *error))completionBlock;

@end
