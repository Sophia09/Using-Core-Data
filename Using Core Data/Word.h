//
//  Word.h
//  Using Core Data
//
//  Created by thinkit  on 7/25/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Vocabulary;

@interface Word : NSManagedObject

@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSString * translation;
@property (nonatomic, retain) Vocabulary *vocabulary;

@end
