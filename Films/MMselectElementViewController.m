//
//  MMselectElementViewController.m
//  Films
//
//  Created by Admin on 20.05.14.
//  Copyright (c) 2014 Admin. All rights reserved.
//

#import "MMselectElementViewController.h"

@interface MMselectElementViewController ()

@property (nonatomic, strong) NSArray * arrData;
@property (nonatomic, strong) NSArray * arrFilms;
@property (nonatomic, strong) MMSingleton *singleton;
@property (weak, nonatomic) IBOutlet UITableView *tabView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;

@end

@implementation MMselectElementViewController

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
    if (![self.arrData count]) {
        NSString *type;
        switch (self.numberButton) {
            case 2: type = @"ни одного актёра"; break;
            case 3: type = @"ни одного режиссёра"; break;
            case 4: type = @"ни одного жанра"; break;
            case 5: type = @"ни одной страны"; break;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 300, 30)];
        label.text = [NSString stringWithFormat:@"В базе нет %@", type];
        label.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
        [self.view addSubview:label];
    }
}

- (IBAction) goBack {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.singleton = [MMSingleton sharedInstance];

    switch (self.numberButton) {
        case 2: [self.filmObject addActorsObject: [self.arrData objectAtIndex:indexPath.row]]; break;
        case 3: [self.filmObject setDirector: [self.arrData objectAtIndex:indexPath.row]]; break;
        case 4: [self.filmObject addGenresObject: [self.arrData objectAtIndex:indexPath.row]]; break;
        case 5: [self.filmObject addCountrysObject: [self.arrData objectAtIndex:indexPath.row]]; break;
    }
        
    [self.singleton.managedObjectContext save:nil];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) updateRequest {
    NSString * nameEntity;
    switch (self.numberButton) {
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
            [self setTitle:@"Страна производитель"];
            break;
        }
    }
    NSError *error = nil;
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:nameEntity inManagedObjectContext:self.singleton.managedObjectContext]];
    self.arrData = [self.singleton.managedObjectContext executeFetchRequest:request error:&error];
    [self.tabView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrData.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    static NSString *const cell_id = @"cell";
    cell = [tableView dequeueReusableCellWithIdentifier:cell_id];
    
    switch (self.numberButton) {
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
