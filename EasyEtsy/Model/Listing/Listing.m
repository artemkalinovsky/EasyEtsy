//
//  Listing.m
//  
//
//  Created by  Artem Kalinovsky on 8/27/15.
//
//

#import "Listing.h"
#import "NSString+Extensions.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSManagedObject+MagicalRecord.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "EtsyWebServiceAPI.h"

@implementation Listing

@dynamic listingId;
@dynamic imageURLString;
@dynamic name;
@dynamic detailedDescription;
@dynamic price;
@dynamic priceCurrency;

+ (NSString *)entityName {
    return @"Listing";
}

- (instancetype)init {
    NSEntityDescription *listingEntityDescription = [NSEntityDescription entityForName:[Listing entityName]
                                                                inManagedObjectContext:[NSManagedObjectContext MR_rootSavingContext]];

    self = (Listing *)[[NSManagedObject alloc] initWithEntity:listingEntityDescription
                               insertIntoManagedObjectContext:nil];
    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)jsonSerializedListing {
    if (self = [self init]) {
        self.listingId = jsonSerializedListing[@"listing_id"];
        self.name = [NSString decodedStringFromString:jsonSerializedListing[@"title"]];
        self.detailedDescription = [NSString decodedStringFromString:jsonSerializedListing[@"description"]];
        self.price = jsonSerializedListing[@"price"];
        self.priceCurrency = jsonSerializedListing[@"currency_code"];
    }
    return self;
}

- (void)saveToBookmarks {
    [[NSManagedObjectContext MR_rootSavingContext] insertObject:self];
    [[NSManagedObjectContext MR_rootSavingContext] save:nil];
}

- (void)removeFromBookmarks {
    [self MR_deleteEntityInContext:[NSManagedObjectContext MR_rootSavingContext]];
    [[NSManagedObjectContext MR_rootSavingContext] save:nil];
}

- (void)fetchListingImageWithCompletion:(void (^)(UIImage *image))completion {
    __weak typeof(self) weakSelf = self;
    if (!self.imageURLString) {
        [[EtsyWebServiceAPI sharedManager] fetchImageURLForListing:self
                                                        completion:^(NSString *imageURL, NSError *error) {
                                                            if (!error && imageURL) {
                                                                weakSelf.imageURLString = imageURL;
                                                                [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.imageURLString]
                                                                                                                options:0
                                                                                                               progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                                                                               }
                                                                                                              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                                                                                  if (image) {
                                                                                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                                                                                          completion(image);
                                                                                                                      });
                                                                                                                  }
                                                                                                              }];
                                                            };
                                                        }];
    } else {
        [[SDWebImageManager sharedManager] downloadImageWithURL:[NSURL URLWithString:self.imageURLString]
                                                        options:0
                                                       progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                       }
                                                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                          if (image) {
                                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                                  completion(image);
                                                              });
                                                          }
                                                      }];
    }
}

@end
