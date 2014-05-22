//
//  Film.h
//  Films
//
//  Created by Admin on 16.05.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Actor, Contry, Director, Genre;

@interface Film : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * lenght;
@property (nonatomic, retain) Director *director;
@property (nonatomic, retain) NSSet *countrys;
@property (nonatomic, retain) NSSet *genres;
@property (nonatomic, retain) NSSet *actors;
@end

@interface Film (CoreDataGeneratedAccessors)

- (void)addCountrysObject:(Contry *)value;
- (void)removeCountrysObject:(Contry *)value;
- (void)addCountrys:(NSSet *)values;
- (void)removeCountrys:(NSSet *)values;

- (void)addGenresObject:(Genre *)value;
- (void)removeGenresObject:(Genre *)value;
- (void)addGenres:(NSSet *)values;
- (void)removeGenres:(NSSet *)values;

- (void)addActorsObject:(Actor *)value;
- (void)removeActorsObject:(Actor *)value;
- (void)addActors:(NSSet *)values;
- (void)removeActors:(NSSet *)values;

@end
