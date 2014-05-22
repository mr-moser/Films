//
//  MMdataForFilmViewController.h
//  Films
//
//  Created by Admin on 20.05.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Film.h"
#import "Actor.h"
#import "Contry.h"
#import "Director.h"
#import "Genre.h"
#import "MMselectElementViewController.h"

@interface MMdataForFilmViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSString * film;
@property (nonatomic, strong) Film * filmObject;

@end
