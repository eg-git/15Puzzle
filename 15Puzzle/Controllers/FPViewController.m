//
//  FPViewController.m
//  15Puzzle
//
//  Created by Erica Giordo on 5/8/14.
//  Copyright (c) 2014 Erica Giordo. All rights reserved.
//

#import "FPViewController.h"
#import "FPPuzzleIndex.h"
#import "FPTile.h"

CGFloat const animationDuration = 0.15;

@interface FPViewController () <FPTileDelegate>

@property (nonatomic, strong) NSMutableArray *puzzleTiles;
@property (nonatomic, weak) IBOutlet UIView *puzzleView;
@property (nonatomic, weak) IBOutlet UIView *winnerView;

@end

@implementation FPViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self createPuzzle];
    [self shakePuzzle];
    [self drawPuzzle];
}

- (void)createPuzzle
{
    self.puzzleTiles = [[NSMutableArray alloc] init];
    NSMutableDictionary *tmpDictionary = [[NSMutableDictionary alloc] init];
    NSInteger tilesSqrt = kTilesSqrt;
    
    //we reach tile + 1 to add also the last array
    for (int i = 0; i < kTiles + 1; i++){
        if (i % tilesSqrt == 0 && i != 0) {
            [self.puzzleTiles addObject:tmpDictionary];
            tmpDictionary = [[NSMutableDictionary alloc] init];
        }
        [tmpDictionary setObject:@(i) forKey:[@(i % 4) stringValue]];
    }
}

- (void)shakePuzzle
{
    NSInteger tilesSqrt = kTilesSqrt;
    for (int i = 0; i < tilesSqrt; i++){
        for (int j = 0; j < tilesSqrt; j++){
            //value to replace
            NSInteger row = rand() % tilesSqrt;
            NSInteger column = rand() % tilesSqrt;
            NSMutableDictionary *valueToReplaceDictionary = [self.puzzleTiles objectAtIndex:row];
            int valueToReplace = [[valueToReplaceDictionary objectForKey:[@(column) stringValue]] intValue];
            
            //current value
            NSMutableDictionary *currentDictionary = [self.puzzleTiles objectAtIndex:i];
            int currentValue = [[currentDictionary objectForKey:[@(j) stringValue]] intValue];
            
            //replacing
            [valueToReplaceDictionary setValue:@(currentValue) forKey:[@(column) stringValue]];
            [currentDictionary setValue:@(valueToReplace) forKey:[@(j) stringValue]];
        }
    }
}

- (void)drawPuzzle
{
    NSInteger tilesSqrt = kTilesSqrt;
    for (NSInteger i = 0; i < tilesSqrt; i++){
        for (NSInteger j = 0; j < tilesSqrt; j++) {
            
            FPPuzzleIndex *index = [[FPPuzzleIndex alloc] initWithRow:i andColumn:j];
            NSMutableDictionary *tmpDictionary = [self.puzzleTiles objectAtIndex:i];
            NSString *title = [[tmpDictionary objectForKey:[@(j) stringValue]] stringValue];
            FPTile *tile = [[FPTile alloc] initTileWithIndex:index andTitle:title];
            tile.delegate = self;
            
            [self.puzzleView addSubview:tile];
        }
        [self.view bringSubviewToFront:self.puzzleView];
    }
}

#pragma mark - tiles positions methods
- (BOOL)checkFreePositionForRow:(NSInteger)row andColumn:(NSInteger)column
{
    NSMutableDictionary *tmpDictionary = [self.puzzleTiles objectAtIndex:row];
    NSString *buttonText = [[tmpDictionary objectForKey:[@(column) stringValue]] stringValue];
    
    if ([buttonText isEqualToString:@"0"])
        return true;
    return false;
}

- (void)moveTileAtRow:(NSInteger)row andColumn:(NSInteger)column forDirection:(UISwipeGestureRecognizerDirection)direction
{
    FPPuzzleIndex *emptyTileIndex = [self findIndexForValue:@"0"];

    NSMutableDictionary *valueToReplaceDictionary = [self.puzzleTiles objectAtIndex:row];
    int valueToReplace = [[valueToReplaceDictionary objectForKey:[@(column) stringValue]] intValue];
    FPPuzzleIndex *indexToReplace = [[FPPuzzleIndex alloc] initWithRow:row andColumn:column];
    
    //current value
    NSMutableDictionary *currentDictionary = [self.puzzleTiles objectAtIndex:emptyTileIndex.row];
    int currentValue = [[currentDictionary objectForKey:[@(emptyTileIndex.column) stringValue]] intValue];
    
    //replacing
    [valueToReplaceDictionary setValue:@(currentValue) forKey:[@(column) stringValue]];
    [currentDictionary setValue:@(valueToReplace) forKey:[@(emptyTileIndex.column) stringValue]];
    
    [self animateTileFromIndex:indexToReplace toIndex:emptyTileIndex];
    
    if ([self checkPuzzleFinished])
        [UIView animateWithDuration:animationDuration animations:^{
            [self.view bringSubviewToFront:self.winnerView];
            self.winnerView.hidden = NO;
            self.winnerView.alpha = 0.7;
        }];
}

- (void)animateTileFromIndex:(FPPuzzleIndex *)indexFrom toIndex:(FPPuzzleIndex*)indexTo
{
    UIButton *buttonFrom = [self findButtonFromIndex:indexFrom];
    UIButton *buttonTo = [self findButtonFromIndex:indexTo];
    [self.puzzleView bringSubviewToFront:buttonFrom];
    [UIView animateWithDuration:animationDuration
                     animations:^{
                         CGRect frame = buttonFrom.frame;
                         buttonFrom.frame = buttonTo.frame;
                         buttonTo.frame = frame;
                     }];
}

#pragma mark - FPTileDelegate method
- (void)fpTileDelegateWantsMoveTileForIndex:(FPPuzzleIndex *)index andDirection:(UISwipeGestureRecognizerDirection)direction
{
    BOOL moveAllowed = NO;
    
    switch (direction) {
        case UISwipeGestureRecognizerDirectionUp:
            moveAllowed = [self checkFreePositionForRow:index.row - 1 andColumn:index.column];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            moveAllowed = [self checkFreePositionForRow:index.row andColumn:index.column + 1];
            break;
        case UISwipeGestureRecognizerDirectionDown:
            moveAllowed = [self checkFreePositionForRow:index.row + 1 andColumn:index.column];
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            moveAllowed = [self checkFreePositionForRow:index.row andColumn:index.column - 1];
            break;
        default:
            break;
    }

    if(moveAllowed)
        [self moveTileAtRow:index.row andColumn:index.column forDirection:direction];
}

#pragma mark - helper methods
- (UIButton *)findButtonFromIndex:(FPPuzzleIndex * )index
{
    UIButton *buttonForIndex = nil;
    for (UIView *view in self.puzzleView.subviews)
        if ([view isKindOfClass:[UIButton class]]){
            UIButton *button = (UIButton *)view;
            if ((button.frame.origin.y == (index.row * kTilesSize)) &&  (button.frame.origin.x == (index.column * kTilesSize)))
                buttonForIndex = button;
        }
    return buttonForIndex;
}

- (FPPuzzleIndex *)findIndexForValue:(NSString *)value
{
    FPPuzzleIndex *puzzleIndex = [[FPPuzzleIndex alloc] init];
    for (int i = 0; i < kTilesSqrt; i++){
        NSDictionary *dictionary = [self.puzzleTiles objectAtIndex:i];
        for (int j = 0; j < kTilesSqrt; j++){
            if ([[[dictionary objectForKey:[@(j) stringValue]] stringValue] isEqualToString:value])
                return puzzleIndex = [[FPPuzzleIndex alloc] initWithRow:i andColumn:j];
        }
    }
    return puzzleIndex;
}

- (BOOL)checkPuzzleFinished
{
    BOOL found = YES;
    for (NSInteger i = 0; i < kTilesSqrt; i++){
        NSDictionary *dictionary = [self.puzzleTiles objectAtIndex:i];
        for (NSInteger j = 0; j < kTilesSqrt; j++) {
            NSString *dictionaryValue = [[dictionary objectForKey:[@(j) stringValue]] stringValue];
            if (i == (kTilesSqrt - 1) && j == (kTilesSqrt - 1)){
                if (![[[dictionary objectForKey:[@(j) stringValue]] stringValue] isEqualToString:@"0"])
                    found = NO;
            }
            else {
                NSString *tileValue = [NSString stringWithFormat:@"%i", (int)(i * kTilesSqrt) + j + 1];
                if (![dictionaryValue isEqualToString: tileValue])
                    found = NO;
            }
        }
    }
    return found;
}

@end
