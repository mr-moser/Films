//
//  MMViewController.m
//  Films
//
//  Created by Admin on 16.05.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "MMViewController.h"
#import "Film.h"
#import "Actor.h"
#import "Contry.h"
#import "Director.h"
#import "Genre.h"
#import "MMcell.h"
#import "KxMenu.h"
#import "MMaddElementToBaseViewController.h"

@interface MMViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableData;
@property (nonatomic, strong) NSArray *arrData;
@property (nonatomic, strong) MMSingleton *singleton;
@property (nonatomic, strong) Film *selectedElem;




- (IBAction)addFilmToBase:(id)sender;
- (IBAction)delFilmToBase:(id)sender;

@end

@implementation MMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.singleton = [MMSingleton sharedInstance];
    [self allFilmsObjects];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"TEST FOR GIT HUB");
}

- (void) viewWillAppear:(BOOL)animated {
   [self allFilmsObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonMenuPress:(id)sender {
    NSArray *menuItems = [NSArray arrayWithObjects:
                          [KxMenuItem menuItem:@"Меню" image:nil target:self action:nil idNumMenu:0],
                          [KxMenuItem menuItem:@"Редактировать фильмы" image:nil target:self action:@selector(pushMenuItem:) idNumMenu:1],
                          [KxMenuItem menuItem:@" " image:nil target:self action:nil idNumMenu:0],
                          [KxMenuItem menuItem:@"Редактировать актёров" image:nil target:self action:@selector(pushMenuItem:) idNumMenu:2],
                          [KxMenuItem menuItem:@"Редактировать режиссёров" image:nil target:self action:@selector(pushMenuItem:) idNumMenu:3],
                          [KxMenuItem menuItem:@"Редактировать жанры" image:nil target:self action:@selector(pushMenuItem:) idNumMenu:4],
                          [KxMenuItem menuItem:@"Редактировать страны" image:nil target:self action:@selector(pushMenuItem:) idNumMenu:5],
                          nil];
    KxMenuItem *first = [menuItems objectAtIndex:0];
    //first.foreColor = [UIColor colorWithWhite:1.0 alpha:0.5];
    first.foreColor = [UIColor colorWithRed:0.5 green:1.0 blue:1.0 alpha:1.0];
    first.alignment = NSTextAlignmentCenter;
    
    UIView *view = [sender view];
    CGRect frame = [view convertRect:view.bounds toView:self.view];
    [KxMenu showMenuInView:self.view fromRect:CGRectMake(frame.origin.x, frame.origin.y + 10, frame.size.width, frame.size.height) menuItems:menuItems];
}
- (void) pushMenuItem:(id)sender {
    NSString * viewControllerString;
    switch ([sender idNumMenu]) {
        case 1: [self.singleton setButtonPopUpMenu:1]; viewControllerString = @"addFilmToBase"; break;
        case 2: [self.singleton setButtonPopUpMenu:2]; viewControllerString = @"addElementToBase"; break;
        case 3: [self.singleton setButtonPopUpMenu:3]; viewControllerString = @"addElementToBase"; break;
        case 4: [self.singleton setButtonPopUpMenu:4]; viewControllerString = @"addElementToBase"; break;
        case 5: [self.singleton setButtonPopUpMenu:5]; viewControllerString = @"addElementToBase"; break;
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil]; // Имя вашей storyboard
    MMaddElementToBaseViewController *viewController = (MMaddElementToBaseViewController *)[storyboard  instantiateViewControllerWithIdentifier:viewControllerString]; // identifier вам нужно, чтобы был проставлен в Storyboard.
    [self.navigationController pushViewController:viewController animated:YES];
}






- (void) editing {
    [self.tableData setEditing:!self.tableData.editing animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSError *error = nil;
        [self.singleton.managedObjectContext deleteObject:[self.arrData objectAtIndex:indexPath.row]];
        [self.singleton.managedObjectContext save:&error];
        [self allFilmsObjects];
    }
}






-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MMcell *cell;
    static NSString *const cell_id = @"Cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    
    cell.nameFilm.text = @"";
    cell.nameDirector.text = @"";
    cell.nameActor.text = @"";
    cell.nameGenre.text = @"";
    cell.nameCountry.text = @"";
    
    Film * film = [self.arrData objectAtIndex:indexPath.row];
    
    cell.nameFilm.text = [NSString stringWithFormat:@"%@", film.name];
    cell.nameDirector.text = film.director.name ;
    
    if ([[film.actors allObjects] count]) {
        for (int i = 0; i < [[film.actors allObjects] count]; i++) {
            cell.nameActor.text = [cell.nameActor.text stringByAppendingString:[[[film.actors allObjects] objectAtIndex:i] name]];
            if (i < [[film.actors allObjects] count] - 1) {
                cell.nameActor.text = [cell.nameActor.text stringByAppendingString:@", "];
            }
        }
    }
    if ([[film.genres allObjects] count]) {
        for (int i = 0; i < [[film.genres allObjects] count]; i++) {
            cell.nameGenre.text = [cell.nameGenre.text stringByAppendingString:[[[film.genres allObjects] objectAtIndex:i] name]];
            if (i < [[film.genres allObjects] count] - 1) {
                cell.nameGenre.text = [cell.nameGenre.text stringByAppendingString:@", "];
            }
        }
    }
    if ([[film.countrys allObjects] count]) {
        for (int i = 0; i < [[film.countrys allObjects] count]; i++) {
            cell.nameCountry.text = [cell.nameCountry.text stringByAppendingString:[[[film.countrys allObjects] objectAtIndex:i] name]];
            if (i < [[film.countrys allObjects] count] - 1) {
                cell.nameCountry.text = [cell.nameCountry.text stringByAppendingString:@", "];
            }
        }
    }

    return cell;
}

- (IBAction)addFilmToBase:(id)sender {
    [self buttonMenuPress:sender];
}

- (IBAction)delFilmToBase:(id)sender {
    [self editing];
//    if (self.selectedElem != nil) {
//        NSError *error = nil;
//        [self.singleton.managedObjectContext deleteObject:self.selectedElem];
//        [self.singleton.managedObjectContext save:&error];
//        [self allFilmsObjects];
//    }
}

- (void) allFilmsObjects {
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSSortDescriptor *authorDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSArray *sortDescriptors = @[authorDescriptor];
    
    [request setEntity:[NSEntityDescription entityForName:@"Film" inManagedObjectContext:self.singleton.managedObjectContext]];
    [request setSortDescriptors:sortDescriptors];
    
    NSError *error = nil;
    self.arrData = [self.singleton.managedObjectContext executeFetchRequest:request error:&error];
  [self.tableData reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedElem = self.arrData[indexPath.row];
}

@end
