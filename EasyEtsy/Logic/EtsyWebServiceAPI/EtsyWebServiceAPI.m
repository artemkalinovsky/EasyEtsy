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
#import "EtsyWebServiceAPIConstants.h"
#import "ListingCategory.h"
#import "Listing.h"
#import "TFHppleElement.h"
#import "TFHpple.h"
#import "DBGHTMLEntityDecoder.h"
#import "NSManagedObject+MagicalRecord.h"
#import "NSManagedObjectContext+MagicalRecord.h"

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

- (void)fetchListingCategoriesWithCompletion:(EtsyWebServiceAPIResponse)completionBlock {
    NSDictionary *params = @{@"api_key" : kEtsyAPIKey};
    NSString *urlString = [kEtsyAPIBaseURL stringByAppendingString:kEtsyAPICategories];

    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                                          URLString:urlString
                                                                         parameters:params
                                                                              error:nil];

    self.afhttpRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    self.afhttpRequestOperation.responseSerializer = [AFJSONResponseSerializer serializer];

    __weak typeof(self) weakSelf = self;
    [self.afhttpRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *categoriesResponse = responseObject[@"results"];
                NSArray *categories = [weakSelf fetchListingCategoriesFromServerResponse:categoriesResponse];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(categories, nil);
                    [SVProgressHUD dismiss];
                });
            }
                                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [SVProgressHUD dismiss];
                                                               completionBlock(nil, error);
                                                           });
                                                       }];

    [[NSOperationQueue mainQueue] addOperation:self.afhttpRequestOperation];
    [SVProgressHUD show];
    [self.afhttpRequestOperation resume];
}

- (void)fetchActiveListingsWithParameters:(NSDictionary *)parameters
                               completion:(EtsyWebServiceAPIResponse)completionBlock {

    NSMutableDictionary *params = [@{@"api_key" : kEtsyAPIKey} mutableCopy];
    [params addEntriesFromDictionary:parameters];

    NSString *urlString = [kEtsyAPIBaseURL stringByAppendingString:kEtsyAPIActiveListings];

    NSURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"GET"
                                                                          URLString:urlString
                                                                         parameters:params
                                                                              error:nil];

    self.afhttpRequestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    self.afhttpRequestOperation.responseSerializer = [AFJSONResponseSerializer serializer];

    __weak typeof(self) weakSelf = self;
    [self.afhttpRequestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSArray *listingsResponse = responseObject[@"results"];
                NSArray *activeListings = [weakSelf fetchActiveListingsFromServerResponse:listingsResponse];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completionBlock(activeListings, nil);
                    [SVProgressHUD dismiss];
                });

            }
                                                       failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                           dispatch_async(dispatch_get_main_queue(), ^{
                                                               [SVProgressHUD dismiss];
                                                               completionBlock(nil, error);
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

- (void)cancelRequest {
    [SVProgressHUD dismiss];
    if (self.afhttpRequestOperation.isExecuting) {
        [self.afhttpRequestOperation cancel];
        self.afhttpRequestOperation = nil;
    }
}

#pragma mark - Private Methods

- (NSArray *)fetchListingCategoriesFromServerResponse:(NSArray *)categoriesResponse {
    NSMutableArray *fetchedCategories = [[NSMutableArray alloc] init];

    for (NSDictionary *categoryDict in categoriesResponse) {
        @autoreleasepool {
            @try {
                ListingCategory *listingCategory = [[ListingCategory alloc] init];
                listingCategory.categoryId = categoryDict[@"category_id"];
                listingCategory.categoryName = categoryDict[@"category_name"];
                listingCategory.categoryShortName = categoryDict[@"short_name"];
                listingCategory.categoryLongName = categoryDict[@"long_name"];
                [fetchedCategories addObject:listingCategory];
            }
            @catch (NSException *e) {

            }
        }
    }
    return fetchedCategories;
}

- (NSArray *)fetchActiveListingsFromServerResponse:(NSArray *)activeListingsResponse {
    NSMutableArray *fetchedListings = [[NSMutableArray alloc] init];
    DBGHTMLEntityDecoder *decoder = [[DBGHTMLEntityDecoder alloc] init];

    for (NSDictionary *activeListingDict in activeListingsResponse) {
        @try {
            Listing *listing = [[Listing alloc] init];
            listing.listingId = activeListingDict[@"listing_id"];
            listing.name = [decoder decodeString:activeListingDict[@"title"]];
            listing.detailedDescription = [decoder decodeString:activeListingDict[@"description"]];
            listing.price = activeListingDict[@"price"];
            listing.priceCurrency = activeListingDict[@"currency_code"];
//            listing.imageURLString = [self fetchImagePathFromURLString:activeListingDict[@"url"]];
            [fetchedListings addObject:listing];
        }
        @catch (NSException *e) {

        }

    }
    return fetchedListings;
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

- (NSString *)fetchImagePathFromURLString:(NSString *)urlString {
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *htmlData = [NSData dataWithContentsOfURL:url];
    TFHpple *htmlParser = [TFHpple hppleWithHTMLData:htmlData];
    NSString *listingImageXPathQueryString = @"//meta[@property='og:image']";
    NSArray *matchedNodes = [htmlParser searchWithXPathQuery:listingImageXPathQueryString];
    TFHppleElement *element = [matchedNodes firstObject];
    NSString *photoURLString = element.attributes[@"content"];
    return photoURLString;
}

@end
