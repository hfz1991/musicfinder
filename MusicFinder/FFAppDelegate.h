//
//  FFAppDelegate.h
//  MusicFinder
//
//  Created by Fangzhou He on 13-8-30.
//  Copyright (c) 2013年 Fangzhou He. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface FFAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property(strong,nonatomic) NSManagedObjectModel *managedObjectModel;
//@property(strong,nonatomic) NSManagedObjectContext *managedObjectContext;
//@property(strong,nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly, strong, nonatomic) NSManagedObjectContext *historymanagedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *historymanagedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *historypersistentStoreCoordinator;

//- (void)saveContext;
//- (NSURL *)applicationDocumentsDirectory;

////Initial the Database
//-(NSPersistentStoreCoordinator *)persistentStoreCoordinator;
////Initial
//-(NSManagedObjectModel *)managedObjectModel;
////Initial
//-(NSManagedObjectContext *)managedObjectContext;

@end
