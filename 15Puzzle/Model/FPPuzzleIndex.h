//
//  FPPuzzleIndex.h
//  15Puzzle
//
//  Created by Erica Giordo on 5/9/14.
//  Copyright (c) 2014 Erica Giordo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FPPuzzleIndex : NSObject

@property (nonatomic, assign, readonly) NSInteger row;
@property (nonatomic, assign, readonly) NSInteger column;

- (id)initWithRow:(NSInteger)row andColumn:(NSInteger)column;

@end
