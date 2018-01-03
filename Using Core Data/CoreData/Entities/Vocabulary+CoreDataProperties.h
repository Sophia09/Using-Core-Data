//
//  Vocabulary+CoreDataProperties.h
//  Using Core Data
//
//  Created by Li Sai on 1/1/2018.
//
//

#import "Vocabulary+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Vocabulary (CoreDataProperties)

+ (NSFetchRequest<Vocabulary *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, retain) NSSet<Word *> *words;
@property (nullable, nonatomic, retain) NSSet<DictionaryMO *> *contained;

@end

@interface Vocabulary (CoreDataGeneratedAccessors)

- (void)addWordsObject:(Word *)value;
- (void)removeWordsObject:(Word *)value;
- (void)addWords:(NSSet<Word *> *)values;
- (void)removeWords:(NSSet<Word *> *)values;

- (void)addContainedObject:(DictionaryMO *)value;
- (void)removeContainedObject:(DictionaryMO *)value;
- (void)addContained:(NSSet<DictionaryMO *> *)values;
- (void)removeContained:(NSSet<DictionaryMO *> *)values;

@end

NS_ASSUME_NONNULL_END
