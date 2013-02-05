//
//  CoreDataManager.m
//  TaskManager
//
//  Created by test on 17.03.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CoreDataManager.h"

@implementation CoreDataManager

@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;

- (void)dealloc
{
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [super dealloc];
}
static CoreDataManager*	kSharedCore = nil;


+(void)initialize
{
	if(!kSharedCore)
	{
        kSharedCore = [[CoreDataManager alloc] init];
    }
}

+ (CoreDataManager *)shared
{
	return kSharedCore;
}
- (id)init
{
    self = [super init];
    if (self) 
    {
    }
    return self;
}
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"TaskManager" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"TaskManager.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}
#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma mark - Core Data 

- (id)newObject:(NSString *)entityName forContext:(NSManagedObjectContext*)managedObjectContext;
{
	Class EntityClass = NSClassFromString(entityName);
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	NSManagedObject *object = [[EntityClass alloc] initWithEntity:entity insertIntoManagedObjectContext:managedObjectContext];
    
	return [object autorelease];
}

- (id)object:(NSString *)entityName predicate:(NSPredicate *)predicate forContext:(NSManagedObjectContext*)managedObjectContext;
{
    NSArray *result = nil;
	
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
	NSFetchRequest *req = [[NSFetchRequest alloc] init];
	[req setEntity:entity];
	[req setPredicate:predicate];
	@try
	{
		result = [managedObjectContext executeFetchRequest:req error:nil];
	}
	@catch(NSException *exception)
	{
		NSLog(@"(!!!) Exception \"%@\", reason: \"%@\"", [exception name], [exception reason]);
	}
	[req release];
	
	return ([result count] == 0 ? nil : [result objectAtIndex:0]);
}

- (NSArray*)objects:(NSString *)entityName withPredicate:(NSPredicate *)predicate forContext:(NSManagedObjectContext*)managedObjectContext;
{
    NSArray *result = nil;
	
	NSManagedObjectContext *context = managedObjectContext;
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	NSFetchRequest *req = [[NSFetchRequest alloc] init];
	[req setEntity:entity];
	[req setPredicate:predicate];
	@try
	{
		result = [context executeFetchRequest:req error:nil];
	}
	@catch(NSException *exception)
	{
		NSLog (@"(!!!) Exception \"%@\", reason: \"%@\"", [exception name], [exception reason]);
	}
	[req release];
	
	return ([result count] == 0 ? nil : result);
}
- (id)object:(NSString *)entityName predicate:(NSPredicate *)predicate
{
	NSArray *result = [self objects:entityName withPredicate:predicate];
	if ([result count] > 0)
	{
		return [result objectAtIndex:0];
	}
	return nil;
}
- (NSArray *)objects:(NSString *)entityName withPredicate:(NSPredicate *)predicate
{
	NSArray *result = nil;
	
	NSManagedObjectContext *context = self.managedObjectContext;
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	NSFetchRequest *req = [[NSFetchRequest alloc] init];
	[req setEntity:entity];
	[req setPredicate:predicate];
	@try
	{
		result = [context executeFetchRequest:req error:nil];
	}
	@catch(NSException *exception)
	{
		NSLog(@"(!!!) Exception \"%@\", reason: \"%@\"", [exception name], [exception reason]);
	}
	[req release];
	
	return ([result count] == 0 ? nil : result);
}

- (NSArray *)objectsSort:(NSString *)entityName withPredicate:(NSPredicate *)predicate WithSortKey:(NSString*)sortKey WithAscending:(BOOL) ascending
{
	NSArray *result = nil;
	
	NSManagedObjectContext *context = self.managedObjectContext;
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:context];
	NSFetchRequest *req = [[NSFetchRequest alloc] init];
	[req setEntity:entity];
	[req setPredicate:predicate];
    [req setSortDescriptors:[NSArray arrayWithObjects:[[[NSSortDescriptor alloc] initWithKey:sortKey ascending:ascending] autorelease],nil]];
    
	@try
	{
		result = [context executeFetchRequest:req error:nil];
	}
	@catch(NSException *exception)
	{
		NSLog(@"(!!!) Exception \"%@\", reason: \"%@\"", [exception name], [exception reason]);
	}
	[req release];
	
	return ([result count] == 0 ? nil : result);
}


@end
