//
//  DictionaryMO+CoreDataProperties.m
//  Using Core Data
//
//  Created by Li Sai on 1/1/2018.
//
//

#import "DictionaryMO+CoreDataProperties.h"

@implementation DictionaryMO (CoreDataProperties)

+ (NSFetchRequest<DictionaryMO *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Dictionary"];
}

@dynamic name;
@dynamic contains;

@end
