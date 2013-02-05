//
//  ActualTaskVC.m
//  TaskManager
//
//  Created by test on 17.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ActualTaskVC.h"

@implementation ActualTaskVC


- (id)init
{
    self = [super init];
    if (self) 
    {
        super.strPredicate = @"result_task == NO";
    }
    return self;
}
@end
