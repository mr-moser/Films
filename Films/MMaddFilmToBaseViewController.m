//
//  MMaddFilmToBaseViewController.m
//  Films
//
//  Created by Admin on 20.05.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "MMaddFilmToBaseViewController.h"
#import "Film.h"
#import "Actor.h"
#import "Contry.h"
#import "Director.h"
#import "Genre.h"
#import "MMdataForFilmViewController.h"

@interface MMaddFilmToBaseViewController ()

@property (nonatomic, strong) NSArray * arrData;
@property (nonatomic, strong) MMSingleton *singleton;
@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property (weak, nonatomic) IBOutlet UITextField *nameElement;

- (void)addElements;

@end

@implementation MMaddFilmToBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    self.singleton = [MMSingleton sharedInstance];
    [self updateRequest];
    [self.nameElement setReturnKeyType:UIReturnKeyDone];
    [self.nameElement addTarget:self
                         action:@selector(addElements)
               forControlEvents:UIControlEventEditingDidEndOnExit];
    UIBarButtonItem *edit =[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editing)];
    self.navigationItem.rightBarButtonItem = edit;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self addElements];
    return YES;
}

- (void)addElements {
    if (![[self.nameElement text] isEqualToString:@""]) {
        switch ([self.singleton buttonPopUpMenu]) {
            case 1:{
                Film * film = [NSEntityDescription insertNewObjectForEntityForName:@"Film" inManagedObjectContext:self.singleton.managedObjectContext];
                film.name = [self.nameElement text];
                break;
            }
        }
        NSError *error = nil;
        if([self.singleton.managedObjectContext hasChanges] && ![self.singleton.managedObjectContext save:&error])
            NSLog(@"Error");
        [self updateRequest];
        [self.nameElement setText:@""];
    }
}

- (void) updateRequest {
    NSString * nameEntity;
    switch ([self.singleton buttonPopUpMenu]) {
        case 1: {
            nameEntity = @"Film";
            [self setTitle:@"Фильмы"];
            break;
        }
    }
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:nameEntity inManagedObjectContext:self.singleton.managedObjectContext]];
    self.arrData = [self.singleton.managedObjectContext executeFetchRequest:request error:&error];
    [self.tabView reloadData];
}


- (void) editing {
    [self.tabView setEditing:!self.tabView.editing animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSError *error = nil;
        [self.singleton.managedObjectContext deleteObject:[self.arrData objectAtIndex:indexPath.row]];
        [self.singleton.managedObjectContext save:&error];
        [self updateRequest];
    }
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    static NSString *const cell_id = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    
    switch ([self.singleton buttonPopUpMenu]) {
        case 1:{
            Film * film = [self.arrData objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", film.name];
            break;
        }
        default: cell.textLabel.text = [NSString stringWithFormat:@"%@", @"error"];
            break;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"films"]) {
        MMdataForFilmViewController * controller = (MMdataForFilmViewController*) segue.destinationViewController;
        NSIndexPath *indexPath = [self.tabView indexPathForSelectedRow]; //получение индекса выбранной ячейки
        //[controller setFilm:[[self.arrData objectAtIndex:indexPath.row] name]];
        [controller setFilmObject:[self.arrData objectAtIndex:indexPath.row]];
    }
}

@end
