//
//  FPTile.h
//  15Puzzle
//
//  Created by erica giordo on 09/05/2014.
//  Copyright (c) 2014 Erica Giordo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPViewController.h"

@class FPPuzzleIndex;

@protocol FPTileDelegate <NSObject>

- (void)fpTileDelegateWantsMoveTileForIndex:(FPPuzzleIndex *)index andDirection:(UISwipeGestureRecognizerDirection)direction;

@end

@interface FPTile : UIButton

@property (nonatomic, strong, readonly) FPPuzzleIndex *index;
@property (nonatomic, weak) id <FPTileDelegate> delegate;

- (id)initTileWithIndex:(FPPuzzleIndex *)index andTitle:(NSString *)title;

@end
