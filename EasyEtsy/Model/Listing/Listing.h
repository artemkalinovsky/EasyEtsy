//
//  Listing.h
//  
//
//  Created by  Artem Kalinovsky on 8/27/15.
//
//

@import Foundation;
@import CoreData;


@interface Listing : NSManagedObject

@property (nonatomic, retain) NSNumber * listingId;
@property (nonatomic, retain) NSString * imageURLString;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * detailedDescription;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) NSString * priceCurrency;

- (instancetype)init;
- (instancetype)initWithJSON:(NSDictionary *)jsonSerializedListing;

- (void)saveToBookmarks;
- (void)removeFromBookmarks;

@end
