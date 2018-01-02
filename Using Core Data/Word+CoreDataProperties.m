//
//  Word+CoreDataProperties.m
//  Using Core Data
//
//  Created by Li Sai on 1/1/2018.
//
//

#import "Word+CoreDataProperties.h"

@implementation Word (CoreDataProperties)

+ (NSFetchRequest<Word *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Word"];
}

@dynamic translation;
@dynamic word;
@dynamic vocabulary;

@end
