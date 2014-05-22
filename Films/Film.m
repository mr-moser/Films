//
//  Film.m
//  Films
//
//  Created by Admin on 16.05.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "Film.h"
#import "Actor.h"
#import "Contry.h"
#import "Director.h"
#import "Genre.h"


@implementation Film

@dynamic name;
@dynamic lenght;
@dynamic director;
@dynamic countrys;
@dynamic genres;
@dynamic actors;

//- (BOOL) validateValue:(__autoreleasing id *)value forKey:(NSString *)key error:(NSError *__autoreleasing *)error {
//    if ([key isEqualToString:@"actors"]) {
//        *error = [NSError errorWithDomain:key code:111 userInfo:nil];
//        return NO;
//    }
//    return YES;
//}

- (BOOL) validateActors:(__autoreleasing id *)value error:(NSError *__autoreleasing *)error {
    NSLog(@"%d", [self.actors count]);
    if ([self.actors count] >= 5) {
        *error = [NSError errorWithDomain:@"Max count actors for film" code:111 userInfo:nil];
        return NO;
    }
    return YES;
}

@end
