//
//  RootVC.h
//  TaskManager
//
//  Created by test on 21.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootVC : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *table;
    
    NSFetchedResultsController *fetchedTask;
    
    NSString *strPredicate;
    
    NSInteger flagEdit;
}
@property(nonatomic, readonly) NSFetchedResultsController *fetchedTask;
@property(nonatomic, retain) NSString *strPredicate;

typedef enum 
{
    addCellTask,
    deleteCellTask
} typeEdit;

@end
