//
//  CompleteTaskVC.m
//  TaskManager
//
//  Created by test on 17.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CompleteTaskVC.h"

@implementation CompleteTaskVC

- (id)init
{
    self = [super init];
    if (self)
    {
        super.strPredicate = @"result_task == YES";
    }
    return self;
}
@end
