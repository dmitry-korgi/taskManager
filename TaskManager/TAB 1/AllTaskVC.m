//
//  AllTaskVC.m
//  TaskManager
//
//  Created by test on 17.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AllTaskVC.h"
#import "AllTaskCell.h"
#import "DetailsTaskVC.h"


@implementation AllTaskVC


- (id)init
{
    self = [super init];
    if (self) 
    {
        [self.view setBackgroundColor:[UIColor greenColor]];
        super.strPredicate = @"id_task > 0";
    }
    return self;
}
@end
