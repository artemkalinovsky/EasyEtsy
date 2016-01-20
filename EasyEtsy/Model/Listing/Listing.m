//
//  Listing.m
//  
//
//  Created by  Artem Kalinovsky on 8/27/15.
//
//

#import "Listing.h"
#import "MagicalRecordShorthandMethodAliases.h"
#import "NSString+Extensions.h"
#import "NSManagedObjectContext+MagicalRecord.h"

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

@end
