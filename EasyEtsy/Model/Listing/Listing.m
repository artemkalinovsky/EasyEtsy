//
//  Listing.m
//  
//
//  Created by  Artem Kalinovsky on 8/27/15.
//
//

#import "Listing.h"
#import "NSManagedObjectContext+MagicalRecord.h"
#import "NSManagedObject+MagicalRecord.h"


@implementation Listing

@dynamic listingId;
@dynamic imageURLString;
@dynamic name;
@dynamic detailedDescription;
@dynamic price;
@dynamic priceCurrency;

+ (NSManagedObjectContext *)privateManagedObjectContext {
    static NSManagedObjectContext *moc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        moc = [NSManagedObjectContext MR_context];
    });
    return moc;
}

- (instancetype)init {
    Listing *listing = [Listing MR_createEntityInContext:[Listing privateManagedObjectContext]];
    return listing;
}


@end
