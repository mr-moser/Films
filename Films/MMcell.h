//
//  MMcell.h
//  Films
//
//  Created by Admin on 16.05.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMcell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameFilm;
@property (weak, nonatomic) IBOutlet UILabel *nameDirector;
@property (weak, nonatomic) IBOutlet UILabel *nameActor;
@property (weak, nonatomic) IBOutlet UILabel *nameGenre;
@property (weak, nonatomic) IBOutlet UILabel *nameCountry;

@end
