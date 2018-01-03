//
//  Word+CoreDataProperties.h
//  Using Core Data
//
//  Created by Li Sai on 1/1/2018.
//
//

#import "Word+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Word (CoreDataProperties)

+ (NSFetchRequest<Word *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *translation;
@property (nullable, nonatomic, copy) NSString *word;
@property (nullable, nonatomic, retain) Vocabulary *vocabulary;

@end

NS_ASSUME_NONNULL_END
