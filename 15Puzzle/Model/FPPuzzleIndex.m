//
//  FPPuzzleIndex.m
//  15Puzzle
//
//  Created by Erica Giordo on 5/9/14.
//  Copyright (c) 2014 Erica Giordo. All rights reserved.
//

#import "FPPuzzleIndex.h"

@interface FPPuzzleIndex ()

@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;

@end

@implementation FPPuzzleIndex

- (id)initWithRow:(NSInteger)row andColumn:(NSInteger)column{
    if ((self = [super init])){
        self.row = row;
        self.column = column;
    }
    
    return self;

}

@end
