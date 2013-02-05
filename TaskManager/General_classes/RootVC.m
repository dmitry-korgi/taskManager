//
//  RootVC.m
//  TaskManager
//
//  Created by test on 21.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RootVC.h"
#import "DetailsTaskVC.h"
#import "AllTaskCell.h"

@implementation RootVC

@synthesize fetchedTask;
@synthesize strPredicate = _strPredicate;
- (id)init
{
    self = [super init];
    if (self)
    {
        UIBarButtonItem *leftButton = [[[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(leftButtonPress)] autorelease];
        self.navigationItem.leftBarButtonItem = leftButton;
        
        UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonPress)] autorelease];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    table = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 411) style:UITableViewStyleGrouped] autorelease];
    [table setDelegate:self];
    [table setDataSource:self];
    [self.view addSubview:table];    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [table reloadData];
}
- (void)dealloc
{
    [super dealloc];
}
#pragma mark - Action
- (void)leftButtonPress
{
    DetailsTaskVC *vc = [[[DetailsTaskVC alloc] init] autorelease];
    [vc setCurrentTask:nil];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)rightButtonPress
{
    flagEdit = deleteCellTask;
    [table setEditing:!table.editing animated:YES];
}
#pragma mark - Table view dataSource/Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{    
    return [self.fetchedTask.fetchedObjects count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 92;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{  
    static NSString *cellId = @"cell_all_task";
    
    AllTaskCell *cell =  (AllTaskCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[[AllTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        [cell createAllElements];
    }
    [cell setAllElements:[self.fetchedTask.fetchedObjects objectAtIndex:indexPath.row]];
    return cell;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (flagEdit == deleteCellTask)         
        return UITableViewCellEditingStyleDelete;
    
    return UITableViewCellEditingStyleInsert;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[CoreDataManager shared].managedObjectContext deleteObject:[self.fetchedTask.fetchedObjects objectAtIndex:indexPath.row]];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [table deselectRowAtIndexPath:indexPath animated:YES];
    
    DetailsTaskVC *vc = [[[DetailsTaskVC alloc] init] autorelease];
    [vc setCurrentTask:[self.fetchedTask.fetchedObjects objectAtIndex:indexPath.row]];
    [vc setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -
#pragma mark Fetched delegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [table reloadData];    
}

#pragma mark -
#pragma mark Fetched controllers
- (NSFetchedResultsController*) fetchedTask
{
    if (fetchedTask != nil)
    {
        fetchedTask.delegate = (id <NSFetchedResultsControllerDelegate>) self;
        return fetchedTask;
    }
    
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MOTask" inManagedObjectContext:[CoreDataManager shared].managedObjectContext];
    [request setEntity:entity];
    [request setPredicate:[NSPredicate predicateWithFormat:_strPredicate]];
    
    [request setSortDescriptors:[NSArray arrayWithObjects:[[NSSortDescriptor alloc] initWithKey:@"id_task" ascending:YES], nil]];
    
    
    fetchedTask = [[NSFetchedResultsController alloc] initWithFetchRequest:request managedObjectContext:[CoreDataManager shared].managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    fetchedTask.delegate = (id <NSFetchedResultsControllerDelegate>) self;
    
    
    NSError *error = nil;
    
    if (![fetchedTask performFetch:&error])
    {
    }
    return fetchedTask;
}

@end
