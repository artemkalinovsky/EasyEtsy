//
//  EtsyWebServiceAPI.m
//  EasyEtsy
//
//  Created by Artem Kalinovsky on 26/08/2015.
//  Copyright (c) 2015 Artem Kalinovsky. All rights reserved.
//

#import "EtsyWebServiceAPI.h"
#import "AFHTTPRequestOperation.h"
#import "SVProgressHUD.h"
#import "ListingCategory.h"
#import "Listing.h"

@interface EtsyWebServiceAPI ()
@property(strong, nonatomic) AFHTTPRequestOperation *afhttpRequestOperation;
@end

@implementation EtsyWebServiceAPI

#pragma mark - Singleton Methods

+ (instancetype)sharedManager {
    static EtsyWebServiceAPI *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}

#pragma mark - Public API Methods

- (void)fetchDataForAPIModelName:(APIModelName)apiModelName
                         parameters:(NSDictionary *)parameters
                         completion:(EtsyWebServiceAPIResponse)completion {

    NSMutableDictionary *params = [@{@"api_key" : kEtsyAPIKey} mutableCopy];
    NSString *urlString;

    if (apiModelName == APIModelNameListing && parameters) {
        urlString = [kEtsyAPIBaseURL stringByAppendingString:kEtsyAPIActiveListings];
        [params addEntriesFromDictionary:parameters];
    } else if (apiModelName == APIModelNameCategory) {
        urlString = [kEtsyAPIBaseURL stringByAppendingString:kEtsyAPICategories];
    }

    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                                          URLString:urlString
                                                                         parameters:params
                                                                              error:nil];

    self.afhttpRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    self.afhttpRequestOperation.responseSerializer = [AFJSONResponseSerializer serializer];

    __weak typeof(self) weakSelf = self;
    [self.afhttpRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *fetchedResults = responseObject[@"results"];
                NSArray *parsedModels = [weakSelf parseFetchedJSONModels:fetchedResults
                                                       forAPIModelName:apiModelName];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(parsedModels, nil);
                    [SVProgressHUD dismiss];
                });
            }
                                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [SVProgressHUD dismiss];
                                                               completion(nil, error);
                                                           });
                                                       }];

    [[NSOperationQueue mainQueue] addOperation:self.afhttpRequestOperation];
    [SVProgressHUD show];
    [self.afhttpRequestOperation resume];

}

- (void)fetchImageURLForListing:(Listing *)listing
                     completion:(void (^)(NSString *imageURLString, NSError *error))completionBlock {

    NSDictionary *params = @{@"api_key" : kEtsyAPIKey};

    NSString *urlString = [[kEtsyAPIBaseURL stringByAppendingString:kEtsyAPIListingImages] stringByReplacingOccurrencesOfString:@":listing_id"
                                                                                                                     withString:listing.listingId.stringValue];

    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                                          URLString:urlString
                                                                         parameters:params
                                                                              error:nil];

    self.afhttpRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    self.afhttpRequestOperation.responseSerializer = [AFJSONResponseSerializer serializer];

    __weak typeof(self) weakSelf = self;
    [self.afhttpRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *listingImagesResponse = responseObject[@"results"];
                NSString *fullImageURLString = [weakSelf fetchFullSizedImageURLFromImagesResponse:listingImagesResponse];
                completionBlock(fullImageURLString, nil);
            }
                                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                           completionBlock(nil, error);
                                                       }];

    [[NSOperationQueue mainQueue] addOperation:self.afhttpRequestOperation];
    [self.afhttpRequestOperation resume];
}

#pragma mark - Private Methods

- (NSArray *)parseFetchedJSONModels:(NSArray *)jsonSerializedModels
                    forAPIModelName:(APIModelName)fetchedModelName {

    NSMutableArray *parsedModels = [[NSMutableArray alloc] init];

    for (NSDictionary *jsonSerializedModel in jsonSerializedModels) {
        @try {
            switch (fetchedModelName) {
                case APIModelNameCategory: {
                    ListingCategory *listingCategory = [[ListingCategory alloc] initWithJSON:jsonSerializedModel];
                    [parsedModels addObject:listingCategory];
                    break;
                }
                case APIModelNameListing: {
                    Listing *listing = [[Listing alloc] initWithJSON:jsonSerializedModel];
                    [parsedModels addObject:listing];
                    break;
                }
                default:
                    NSLog(@"Trying to parse unknown model.");
                    break;
            }
        }
        @catch (NSException *e) {

        }
    }
    return parsedModels;
}

- (NSString *)fetchFullSizedImageURLFromImagesResponse:(NSArray *)imagesResponse {
    NSString *url = nil;
    for (NSDictionary *listingImageDict in imagesResponse) {
        if ([listingImageDict[@"rank"] isEqual:@1]) {
            url = listingImageDict[@"url_fullxfull"];
            return url;
        }
    }
    return url;
}

@end
