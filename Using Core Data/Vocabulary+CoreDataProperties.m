//
//  Vocabulary+CoreDataProperties.m
//  Using Core Data
//
//  Created by Li Sai on 1/1/2018.
//
//

#import "Vocabulary+CoreDataProperties.h"

@implementation Vocabulary (CoreDataProperties)

+ (NSFetchRequest<Vocabulary *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Vocabulary"];
}

@dynamic name;
@dynamic words;
@dynamic contained;

@end
