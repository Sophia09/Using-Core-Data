//
//  DictionaryMO+CoreDataProperties.h
//  Using Core Data
//
//  Created by Li Sai on 1/1/2018.
//
//

#import "DictionaryMO+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface DictionaryMO (CoreDataProperties)

+ (NSFetchRequest<DictionaryMO *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Vocabulary *> *contains;

@end

@interface DictionaryMO (CoreDataGeneratedAccessors)

- (void)addContainsObject:(Vocabulary *)value;
- (void)removeContainsObject:(Vocabulary *)value;
- (void)addContains:(NSSet<Vocabulary *> *)values;
- (void)removeContains:(NSSet<Vocabulary *> *)values;

@end

NS_ASSUME_NONNULL_END
