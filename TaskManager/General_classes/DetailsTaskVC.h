//
//  DetailsTaskVC.h
//  TaskManager
//
//  Created by test on 20.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MOTask;

@interface DetailsTaskVC : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextViewDelegate>
{
    UITextField *fldTitleTask;
    UITextView  *txtViewTaskMoreInfo;
    
    UIButton *btnTaskResultYes;
    UIButton *btnTaskResultNo;
    UIButton *btnTaskDelete;
    
    UITableView *table;
    
    NSArray *arrayGroupName;
    NSString *strNameGroup;
    
    MOTask *currentTask;
    
    BOOL editMode;
}
@property(nonatomic, retain) MOTask *currentTask;
- (void)showCheckMark:(NSIndexPath*)indexPath;
- (void)createTableHeader;
- (void)createTableFooter;
- (void)checkStatusShowTask;
@end
