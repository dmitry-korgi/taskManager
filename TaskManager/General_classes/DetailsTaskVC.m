//
//  DetailsTaskVC.m
//  TaskManager
//
//  Created by test on 20.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DetailsTaskVC.h"
#import <QuartzCore/QuartzCore.h>
#import "CoreDataManager.h"
#import "MOTask.h"

@implementation DetailsTaskVC

@synthesize currentTask = _currentTask;

#pragma mark -
- (id)init
{
    self = [super init];
    if (self) 
    {        

    }
    return self;
}
- (void)dealloc
{
    [arrayGroupName release];
    
    [super dealloc];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    arrayGroupName = [[NSArray alloc] initWithObjects: @"Family",@"Work", @"Hobby", @"Events", nil];
    
    table = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 420) style:UITableViewStyleGrouped] autorelease];
    [table setDelegate:self];
    [table setDataSource:self];
    [self.view addSubview:table];
    
    [self createTableHeader];
    [self createTableFooter];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self checkStatusShowTask];
}
#pragma mark
#pragma mark Table view dataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [arrayGroupName count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{  
    static NSString *cellId = @"cell_all_group_task";
    
    UITableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        [cell.textLabel setTextAlignment:UITextAlignmentCenter];
        [cell.textLabel setText:[arrayGroupName objectAtIndex:indexPath.row]];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    strNameGroup = [arrayGroupName objectAtIndex:indexPath.row];
    
    for (UITableViewCell *cell in [table visibleCells])
    {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    } 
    
    [self showCheckMark:indexPath];
}

#pragma mark -
#pragma mark Other methods
- (void)showCheckMark:(NSIndexPath*)indexPath
{
    if (editMode) 
    {
        UITableViewCell *cell = [table cellForRowAtIndexPath:indexPath];
        [cell setAccessoryType:UITableViewCellAccessoryCheckmark];
    }
}
- (void)checkStatusShowTask
{
    if (_currentTask)
    {
        editMode = NO;
        
        UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonEditPress)] autorelease];
        self.navigationItem.rightBarButtonItem = rightButton;

        [fldTitleTask setText:_currentTask.title_task];
        [fldTitleTask setEnabled:NO];
        
        [txtViewTaskMoreInfo setText:_currentTask.more_info_task];
        [txtViewTaskMoreInfo setTextColor:[UIColor blackColor]];
        [txtViewTaskMoreInfo setEditable:NO];
        
        [arrayGroupName release];
        arrayGroupName = nil;
        
        arrayGroupName = [[NSArray alloc] initWithObjects:_currentTask.title_group_task, nil];
        [table reloadData];
    }
    else
    {
        editMode = YES;
        
        UIBarButtonItem *rightButton = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonSavePress)] autorelease];
        self.navigationItem.rightBarButtonItem = rightButton;
    }
}
- (void)createTableHeader
{
    UIView *viewTableHeader = [[[UIView alloc] initWithFrame:CGRectMake(10, 10, 300, 170)] autorelease];
    [viewTableHeader setBackgroundColor:[UIColor clearColor]];
    
    UIBarButtonItem *itemDone = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(itemDonePress)] autorelease];

    UIToolbar *toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 35)] autorelease];
    [toolbar setItems:[NSArray arrayWithObject:itemDone]];
    
    fldTitleTask = [[[UITextField alloc] initWithFrame:CGRectMake(10, 10, 300, 30)] autorelease];
    [fldTitleTask setInputAccessoryView:toolbar];
    [fldTitleTask setFont:[UIFont boldSystemFontOfSize:16]];
    [fldTitleTask setTextAlignment:UITextAlignmentLeft];
    [fldTitleTask setReturnKeyType:UIReturnKeyDone];
    [fldTitleTask setBackgroundColor:[UIColor whiteColor]];
    [fldTitleTask setBorderStyle:UITextBorderStyleRoundedRect];
    [fldTitleTask setPlaceholder:@"Title task"];
    [viewTableHeader addSubview:fldTitleTask];

    txtViewTaskMoreInfo = [[[UITextView alloc] initWithFrame:CGRectMake(10, y_offset(fldTitleTask) + 10, 300, 110)] autorelease];
    [txtViewTaskMoreInfo setBackgroundColor:[UIColor whiteColor]];
    [txtViewTaskMoreInfo setText:@"More info"];
    [txtViewTaskMoreInfo setInputAccessoryView:toolbar];
    txtViewTaskMoreInfo.textColor = [UIColor lightGrayColor];
    [txtViewTaskMoreInfo setFont:[UIFont boldSystemFontOfSize:14]];
    [txtViewTaskMoreInfo.layer setBackgroundColor: [[UIColor whiteColor] CGColor]];
    [txtViewTaskMoreInfo.layer setBorderColor: [[UIColor grayColor] CGColor]];
    [txtViewTaskMoreInfo.layer setBorderWidth: 1.0];
    [txtViewTaskMoreInfo setDelegate:self];
    [txtViewTaskMoreInfo.layer setCornerRadius:8.0f];
    [txtViewTaskMoreInfo.layer setMasksToBounds:YES];   
    [viewTableHeader addSubview:txtViewTaskMoreInfo];
    
    [table setTableHeaderView:viewTableHeader];
}
- (void)createTableFooter
{ 
    if (_currentTask)
    {
        UIView *viewFooter = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 120)] autorelease];
        [viewFooter setBackgroundColor:[UIColor clearColor]];    
    
        btnTaskResultYes = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnTaskResultYes setFrame:CGRectMake(50, 0, 80, 30)];
        [btnTaskResultYes.layer setBorderWidth:2];
        [btnTaskResultYes addTarget:self action:@selector(btnCompleteYesPress) forControlEvents:UIControlEventTouchUpInside];
        [btnTaskResultYes.layer setCornerRadius:10];
        [btnTaskResultYes.layer setBackgroundColor:[[UIColor greenColor] CGColor]];
        [btnTaskResultYes.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [btnTaskResultYes.layer setShadowRadius:3];
        [btnTaskResultYes setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnTaskResultYes setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [btnTaskResultYes setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnTaskResultYes setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btnTaskResultYes.titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [btnTaskResultYes.titleLabel setHighlighted:YES];
        [btnTaskResultYes.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [btnTaskResultYes setTitle:@"Completed" forState:UIControlStateNormal];
        [btnTaskResultYes.layer setShadowOffset:CGSizeMake(0, 0)];
        [btnTaskResultYes.layer setShadowColor:[UIColor blackColor].CGColor];
        [btnTaskResultYes.layer setShadowOpacity:0.8];
        [viewFooter addSubview:btnTaskResultYes];
        
        btnTaskResultNo = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnTaskResultNo setFrame:CGRectMake(170, 0, 100, 30)];
        [btnTaskResultNo.layer setBorderWidth:2];
        [btnTaskResultNo addTarget:self action:@selector(btnCompleteNoPress) forControlEvents:UIControlEventTouchUpInside];
        [btnTaskResultNo.layer setCornerRadius:10];
        [btnTaskResultNo.layer setBackgroundColor:[[UIColor redColor] CGColor]];
        [btnTaskResultNo.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [btnTaskResultNo.layer setShadowRadius:3];
        [btnTaskResultNo setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnTaskResultNo setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [btnTaskResultNo setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnTaskResultNo setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btnTaskResultNo.titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [btnTaskResultNo.titleLabel setHighlighted:YES];
        [btnTaskResultNo.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [btnTaskResultNo setTitle:@"Not completed" forState:UIControlStateNormal];
        [btnTaskResultNo.layer setShadowOffset:CGSizeMake(0, 0)];
        [btnTaskResultNo.layer setShadowColor:[UIColor blackColor].CGColor];
        [btnTaskResultNo.layer setShadowOpacity:0.8];
        [viewFooter addSubview:btnTaskResultNo];
        
        btnTaskDelete = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnTaskDelete setFrame:CGRectMake(100, 40, 120, 30)];
        [btnTaskDelete.layer setBorderWidth:2];
        [btnTaskDelete addTarget:self action:@selector(btnDeletePress) forControlEvents:UIControlEventTouchUpInside];
        [btnTaskDelete.layer setCornerRadius:10];
        [btnTaskDelete.layer setBackgroundColor:[[UIColor blueColor] CGColor]];
        [btnTaskDelete.layer setBorderColor:[[UIColor blackColor] CGColor]];
        [btnTaskDelete.layer setShadowRadius:3];
        [btnTaskDelete setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnTaskDelete setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
        [btnTaskDelete setTitleShadowColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btnTaskDelete setTitleShadowColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btnTaskDelete.titleLabel setShadowOffset:CGSizeMake(0, 1)];
        [btnTaskDelete.titleLabel setHighlighted:YES];
        [btnTaskDelete.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
        [btnTaskDelete setTitle:@"Delete" forState:UIControlStateNormal];
        [btnTaskDelete.layer setShadowOffset:CGSizeMake(0, 0)];
        [btnTaskDelete.layer setShadowColor:[UIColor blackColor].CGColor];
        [btnTaskDelete.layer setShadowOpacity:0.8];
        [viewFooter addSubview:btnTaskDelete];
        
        [table setTableFooterView:viewFooter];
    }
}
#pragma mark UITextView delegate
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    txtViewTaskMoreInfo.text = @"";
    txtViewTaskMoreInfo.textColor = [UIColor blackColor];
    return YES;
}

-(void) textViewDidChange:(UITextView *)textView
{
    
    if(txtViewTaskMoreInfo.text.length == 0)
    {
        txtViewTaskMoreInfo.textColor = [UIColor lightGrayColor];
        txtViewTaskMoreInfo.text = @"More info";
        [txtViewTaskMoreInfo resignFirstResponder];
    }
}
#pragma mark -
#pragma mark Actions
- (void)itemDonePress
{
    [txtViewTaskMoreInfo resignFirstResponder];
    [fldTitleTask resignFirstResponder];
}
- (void)rightButtonSavePress
{
    [txtViewTaskMoreInfo resignFirstResponder];
    [fldTitleTask resignFirstResponder];

    BOOL error = NO;
    
    if ([txtViewTaskMoreInfo.text length] == 0)
        error = YES;
    if ([fldTitleTask.text length] == 0)
        error = YES;
    if ([strNameGroup length] == 0)
        error = YES;
    
    if (error)
    {
        UIAlertView *alertError = [[UIAlertView alloc] initWithTitle:@"Attention" message:@"You do not fill in all fields" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alertError show];
    }
    else 
    {
        MOTask *saveTask;
        
        if(!_currentTask)
        {
            saveTask = [[CoreDataManager shared] newObject:@"MOTask" forContext:[CoreDataManager shared].managedObjectContext];
            saveTask.result_task = [NSNumber numberWithBool:NO];
        }
        else
            saveTask = [[CoreDataManager shared] object:@"MOTask" predicate:[NSPredicate predicateWithFormat:@"id_task == %d", [_currentTask.id_task intValue]] forContext:[CoreDataManager shared].managedObjectContext];
        
        saveTask.title_task = fldTitleTask.text;
        saveTask.more_info_task = txtViewTaskMoreInfo.text;
        saveTask.id_task = [NSNumber numberWithInt:rand()];
        saveTask.title_group_task = strNameGroup;
        saveTask.id_group_task = [NSNumber numberWithInt:[arrayGroupName indexOfObject:strNameGroup]];
        [[CoreDataManager shared] saveContext];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)rightButtonEditPress
{
    editMode = YES;
    
    UIBarButtonItem *rightSaveButton = [[[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(rightButtonSavePress)] autorelease];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = rightSaveButton;
    
    [arrayGroupName release];
    arrayGroupName = nil;
    
    arrayGroupName = [[NSArray alloc] initWithObjects: @"Family",@"Work", @"Hobby", @"Events", nil];

    [table reloadData];
    
    [fldTitleTask setEnabled:YES];
    [txtViewTaskMoreInfo setEditable:YES];
    [txtViewTaskMoreInfo setEnablesReturnKeyAutomatically:YES];
}
- (void)btnCompleteYesPress
{
    MOTask *saveTask = [[CoreDataManager shared] object:@"MOTask" predicate:[NSPredicate predicateWithFormat:@"id_task == %d", [_currentTask.id_task intValue]] forContext:[CoreDataManager shared].managedObjectContext];
    
    saveTask.result_task = [NSNumber numberWithBool:YES];   
    
    [[CoreDataManager shared] saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnCompleteNoPress
{
    MOTask *saveTask = [[CoreDataManager shared] object:@"MOTask" predicate:[NSPredicate predicateWithFormat:@"id_task == %d", [_currentTask.id_task intValue]] forContext:[CoreDataManager shared].managedObjectContext];
    
    saveTask.result_task = [NSNumber numberWithBool:NO];   
    
    [[CoreDataManager shared] saveContext];
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)btnDeletePress
{
    MOTask *saveTask = [[CoreDataManager shared] object:@"MOTask" predicate:[NSPredicate predicateWithFormat:@"id_task == %d", [_currentTask.id_task intValue]] forContext:[CoreDataManager shared].managedObjectContext];
    [[saveTask managedObjectContext] deleteObject:saveTask];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -

@end
