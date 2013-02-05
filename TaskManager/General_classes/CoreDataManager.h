//
//  CoreDataManager.h
//  TaskManager
//
//  Created by test on 17.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;

- (NSURL *)applicationDocumentsDirectory;
- (id) newObject:(NSString *)entityName forContext:(NSManagedObjectContext*)managedObjectContext;
- (id) object:(NSString *)entityName predicate:(NSPredicate *)predicate forContext:(NSManagedObjectContext*)managedObjectContext;
- (NSArray*) objects:(NSString *)entityName withPredicate:(NSPredicate *)predicate forContext:(NSManagedObjectContext*)managedObjectContext;

- (id)object:(NSString *)entityName predicate:(NSPredicate *)predicate;
- (NSArray*)objects:(NSString *)entityName withPredicate:(NSPredicate *)predicate;
- (NSArray*)objectsSort:(NSString *)entityName 
          withPredicate:(NSPredicate *)predicate 
            WithSortKey:(NSString*)sortKey 
          WithAscending:(BOOL) ascending;

+ (CoreDataManager *)shared;

@end
