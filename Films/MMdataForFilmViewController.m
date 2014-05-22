//
//  MMdataForFilmViewController.m
//  Films
//
//  Created by Admin on 20.05.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "MMdataForFilmViewController.h"

@interface MMdataForFilmViewController ()

@property (nonatomic, strong) NSArray * arrData;
@property (nonatomic, strong) MMSingleton *singleton;
@property (weak, nonatomic) IBOutlet UITableView *tabView;

@property (nonatomic, strong) NSArray * arrActors;
@property (nonatomic, strong) NSArray * arrGenres;
@property (nonatomic, strong) NSArray * arrCountrys;

@property (nonatomic, strong) NSMutableArray * tempArray;

@end

@implementation MMdataForFilmViewController

@synthesize film;

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
    [self setTitle: [self.filmObject name]];
    
    [self updateAllArray];
    
    UIBarButtonItem *edit =[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(editing)];
    self.navigationItem.rightBarButtonItem = edit;
    
    [self.tabView reloadData];
}

- (void) updateAllArray {
    self.arrActors = [[self.filmObject actors] allObjects];
    self.arrGenres = [[self.filmObject genres] allObjects];
    self.arrCountrys = [[self.filmObject countrys] allObjects];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void) editing {
    [self.tabView setEditing:!self.tabView.editing animated:YES];
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSError *error = nil;
        switch (indexPath.section) {
            case 0: {
                [self.filmObject setDirector:nil];
                break;
            }
            case 1: {
                self.tempArray = [NSMutableArray arrayWithArray:self.arrActors];
                [self.tempArray removeObjectAtIndex:indexPath.row];
                [self.filmObject setActors:[NSSet setWithArray:self.tempArray]];
                break;
            }
            case 2: {
                self.tempArray = [NSMutableArray arrayWithArray:self.arrGenres];
                [self.tempArray removeObjectAtIndex:indexPath.row];
                [self.filmObject setGenres:[NSSet setWithArray:self.tempArray]];
                break;
            }
            case 3: {
                self.tempArray = [NSMutableArray arrayWithArray:self.arrCountrys];
                [self.tempArray removeObjectAtIndex:indexPath.row];
                [self.filmObject setCountrys:[NSSet setWithArray:self.tempArray]];
                break;
            }
        }
        [self.singleton.managedObjectContext save:&error];
        [self updateAllArray];
        [self.tabView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString* titleSection;
    switch (section) {
        case 0: titleSection = @"Режиссёр (не больше одного)"; break;
        case 1: titleSection = @"Актёры"; break;
        case 2: titleSection = @"Жанр"; break;
        case 3: titleSection = @"Страна"; break;
    }
    return titleSection;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0: return [[self.filmObject director] name] == nil ? 0 : 1; break;
        case 1: return [self.arrActors count]; break;
        case 2: return [self.arrGenres count]; break;
        case 3: return [self.arrCountrys count]; break;
    }
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    switch (indexPath.section) {
        case 0: {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.filmObject director] name]];
            break;
        }
        case 1: {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrActors objectAtIndex:indexPath.row] name]];
            break;
        }
        case 2: {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrGenres objectAtIndex:indexPath.row] name]];
            break;
        }
        case 3: {
            cell.textLabel.text = [NSString stringWithFormat:@"%@", [[self.arrCountrys objectAtIndex:indexPath.row] name]];
            break;
        }
    }
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    MMselectElementViewController * controller = (MMselectElementViewController*) segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"actors"]) {
        [controller setNumberButton:2];
    }
    if ([segue.identifier isEqualToString:@"directors"]) {
        [controller setNumberButton:3];
    }
    if ([segue.identifier isEqualToString:@"genre"]) {
        [controller setNumberButton:4];
    }
    if ([segue.identifier isEqualToString:@"country"]) {
        [controller setNumberButton:5];
    }
    [controller setFilmObject:self.filmObject];
}

@end
