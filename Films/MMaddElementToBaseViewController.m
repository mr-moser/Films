//
//  MMaddElementToBaseViewController.m
//  Films
//
//  Created by moser on 5/19/14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "MMaddElementToBaseViewController.h"
#import "Film.h"
#import "Actor.h"
#import "Contry.h"
#import "Director.h"
#import "Genre.h"

@interface MMaddElementToBaseViewController ()

@property (nonatomic, strong) NSArray * arrData;
@property (nonatomic, strong) MMSingleton *singleton;
@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property (weak, nonatomic) IBOutlet UITextField *nameElement;

- (void)addElements;

@end

@implementation MMaddElementToBaseViewController

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
            case 1:
                break;
            case 2: {
                Actor * actor = [NSEntityDescription insertNewObjectForEntityForName:@"Actor" inManagedObjectContext:self.singleton.managedObjectContext];
                actor.name = [self.nameElement text];
                break;
            }
            case 3: {
                Director * director = [NSEntityDescription insertNewObjectForEntityForName:@"Director" inManagedObjectContext:self.singleton.managedObjectContext];
                director.name = [self.nameElement text];
                break;
            }
            case 4: {
                Genre * genre = [NSEntityDescription insertNewObjectForEntityForName:@"Genre" inManagedObjectContext:self.singleton.managedObjectContext];
                genre.name = [self.nameElement text];
                break;
            }
            case 5: {
                Contry * country = [NSEntityDescription insertNewObjectForEntityForName:@"Contry" inManagedObjectContext:self.singleton.managedObjectContext];
                country.name = [self.nameElement text];
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
        case 1:
            break;
        case 2: {
            nameEntity = @"Actor";
            [self setTitle:@"Актёры"];
            break;
        }
        case 3: {
            nameEntity = @"Director";
            [self setTitle:@"Режиссёры"];
            break;
        }
        case 4: {
            nameEntity = @"Genre";
            [self setTitle:@"Жанры"];
            break;
        }
        case 5: {
            nameEntity = @"Contry";
            [self setTitle:@"Страна"];
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
    
    switch ([self.singleton buttonPopUpMenu]) {
        case 1:
            break;
        case 2:{
            Actor * actor = [self.arrData objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", actor.name];
            break;
        }
        case 3: {
            Director * director = [self.arrData objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", director.name];
            break;
        }
        case 4: {
            Genre * genre = [self.arrData objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", genre.name];
            break;
        }
        case 5: {
            Contry * contry = [self.arrData objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@", contry.name];
            break;
        }
        default: cell.textLabel.text = [NSString stringWithFormat:@"%@", @"error"];
            break;
    }
    
    return cell;
}

@end
