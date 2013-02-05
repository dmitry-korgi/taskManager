//
//  AllTaskCell.h
//  TaskManager
//
//  Created by test on 17.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MOTask.h"

@interface AllTaskCell : UITableViewCell
{
    UILabel *lblTitle;
    UILabel *lblMoreInfo;
    UILabel *lblGroupName;
    
    UIView *viewResultTask;
}
- (void)createAllElements;
- (void)setAllElements:(MOTask*)CurrentTask;

@end
