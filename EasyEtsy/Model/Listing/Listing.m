//
//  Listing.m
//  
//
//  Created by  Artem Kalinovsky on 8/27/15.
//
//

#import "Listing.h"
#import "NSManagedObjectContext+MagicalRecord.h"


@implementation Listing

@dynamic imageURLString;
@dynamic name;
@dynamic detailedDescription;
@dynamic price;
@dynamic priceCurrency;

- (instancetype)init {
    Listing *listing = [NSEntityDescription insertNewObjectForEntityForName:@"Listing"
                                                     inManagedObjectContext:[NSManagedObjectContext MR_defaultContext]];
    return listing;
}

@end
