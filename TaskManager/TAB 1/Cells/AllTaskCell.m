//
//  AllTaskCell.m
//  TaskManager
//
//  Created by test on 17.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AllTaskCell.h"
#import "MOTask.h"

@implementation AllTaskCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
    }
    return self;
}
- (void)createAllElements
{
    lblTitle = [[[UILabel alloc] init] autorelease];
    [lblTitle setNumberOfLines:0];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setFont:[UIFont boldSystemFontOfSize:14]];
    [self.contentView addSubview:lblTitle];
    
    lblMoreInfo = [[[UILabel alloc] init] autorelease];
    [lblMoreInfo setNumberOfLines:0];
    [lblMoreInfo setBackgroundColor:[UIColor clearColor]];
    [lblMoreInfo setFont:[UIFont systemFontOfSize:12]];
    [self.contentView addSubview:lblMoreInfo];
    
    lblGroupName = [[[UILabel alloc] init] autorelease];
    [lblGroupName setBackgroundColor:[UIColor clearColor]];
    [lblGroupName setFont:[UIFont boldSystemFontOfSize:14]];
    [lblGroupName setNumberOfLines:0];
    [self.contentView addSubview:lblGroupName];
    
    viewResultTask = [[[UIView alloc] initWithFrame:CGRectMake(270, 10, 20, 20)] autorelease];
    [viewResultTask.layer setCornerRadius:10];
    [viewResultTask.layer setShadowColor:[UIColor blackColor].CGColor];
    [viewResultTask.layer setBorderWidth:2];
    [viewResultTask.layer setShadowOffset:CGSizeMake(0, 0)];
    [viewResultTask.layer setShadowRadius:3];
    [viewResultTask.layer setShadowOpacity:1];
    [viewResultTask.layer setBorderColor:[UIColor blackColor].CGColor];
    [self addSubview:viewResultTask];
}
- (void)setAllElements:(MOTask*)CurrentTask
{
    
    lblTitle.text = CurrentTask.title_task;
    lblMoreInfo.text = CurrentTask.more_info_task;
    lblGroupName.text = CurrentTask.title_group_task;

    CGSize constraindeSize = CGSizeMake(260, MAXFLOAT);
    
    CGSize sizeTitle = [lblTitle.text sizeWithFont:lblTitle.font constrainedToSize:constraindeSize];
    lblTitle.frame = CGRectMake(10, 10, sizeTitle.width, sizeTitle.height);
    
    CGSize sizeMoreInfo = [lblMoreInfo.text sizeWithFont:lblMoreInfo.font constrainedToSize:constraindeSize];
    lblMoreInfo.frame = CGRectMake(10, y_offset(lblTitle), sizeMoreInfo.width, sizeMoreInfo.height); 
    
    CGSize sizeGroupName = [lblGroupName.text sizeWithFont:lblGroupName.font constrainedToSize:constraindeSize];
    lblGroupName.frame = CGRectMake(10, y_offset(lblMoreInfo), sizeGroupName.width, sizeGroupName.height); 
    
    if ([CurrentTask.result_task boolValue])
        [viewResultTask.layer setBackgroundColor:[UIColor greenColor].CGColor];
    else
        [viewResultTask.layer setBackgroundColor:[UIColor redColor].CGColor];
        
}
@end
