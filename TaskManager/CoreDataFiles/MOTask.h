//
//  MOTask.h
//  TaskManager
//
//  Created by test on 21.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MOTask : NSManagedObject

@property (nonatomic, retain) NSNumber * id_group_task;
@property (nonatomic, retain) NSNumber * id_task;
@property (nonatomic, retain) NSString * more_info_task;
@property (nonatomic, retain) NSString * title_group_task;
@property (nonatomic, retain) NSString * title_task;
@property (nonatomic, retain) NSNumber * result_task;

@end
