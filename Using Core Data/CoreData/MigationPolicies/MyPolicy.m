//
//  MyPolicy.m
//  Using Core Data
//
//  Created by Li Sai on 2/1/2018.
//

#import "MyPolicy.h"

@implementation MyPolicy

-(BOOL)createRelationshipsForDestinationInstance:(NSManagedObject *)dInstance entityMapping:(NSEntityMapping *)mapping manager:(NSMigrationManager *)manager error:(NSError **)error{
    NSError *superError = nil;
    BOOL mappingSuccess = [super createRelationshipsForDestinationInstance:dInstance entityMapping:mapping manager:manager error:&superError];
 
    return YES;
}

@end
