//
//  FPTile.m
//  15Puzzle
//
//  Created by erica giordo on 09/05/2014.
//  Copyright (c) 2014 Erica Giordo. All rights reserved.
//

#import "FPTile.h"
#import "FPPuzzleIndex.h"
#import "FPViewController.h"

@interface FPTile () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) FPPuzzleIndex *tileIndex;
@property (nonatomic, strong) NSString *tileTitle;

@end

@implementation FPTile

- (id)initTileWithIndex:(FPPuzzleIndex *)index andTitle:(NSString *)title
{
    if ((self = [super init])){
        self.tileIndex = index;
        self.tileTitle = title;
        
        //the definition of swipe accept only 1 direction at a time
        //(http://stackoverflow.com/questions/3319209/setting-direction-for-uiswipegesturerecognizer)
        
        UISwipeGestureRecognizer *swipeRecognizerUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tileSwipedUp:)];
        swipeRecognizerUp.direction = UISwipeGestureRecognizerDirectionUp;
        swipeRecognizerUp.cancelsTouchesInView = YES;
        
        UISwipeGestureRecognizer *swipeRecognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tileSwipedRight:)];
        swipeRecognizerRight.direction = UISwipeGestureRecognizerDirectionRight;
        swipeRecognizerRight.cancelsTouchesInView = YES;
        
        UISwipeGestureRecognizer *swipeRecognizerDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tileSwipedDown:)];
        swipeRecognizerDown.direction = UISwipeGestureRecognizerDirectionDown;
        swipeRecognizerDown.cancelsTouchesInView = YES;
        
        UISwipeGestureRecognizer *swipeRecognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(tileSwipedLeft:)];
        swipeRecognizerLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        swipeRecognizerLeft.cancelsTouchesInView = YES;
        
        //tile value
        self.frame = CGRectMake((index.column % (int)kTilesSqrt) * 80, (index.row % (int)kTilesSqrt) * 80, kTilesSize, kTilesSize);
        self.backgroundColor = ([self.tileTitle isEqualToString:@"0"]) ? [UIColor whiteColor] : [UIColor redColor];
        [self setTitle:self.tileTitle forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addGestureRecognizer:swipeRecognizerUp];
        [self addGestureRecognizer:swipeRecognizerRight];
        [self addGestureRecognizer:swipeRecognizerDown];
        [self addGestureRecognizer:swipeRecognizerLeft];
    }
    
    return self;
}

#pragma mark - UIGesturerecognizer methods
- (void)tileSwipedUp:(UISwipeGestureRecognizer *)swipeRecognizer
{
    UIButton *tileButton = (UIButton *)swipeRecognizer.view;
    CGPoint tileOrigin = tileButton.frame.origin;
    [self swipeTileWithPoint:tileOrigin andDirection:UISwipeGestureRecognizerDirectionUp];
}

- (void)tileSwipedRight:(UISwipeGestureRecognizer *)swipeRecognizer
{
    UIButton *tileButton = (UIButton *)swipeRecognizer.view;
    CGPoint tileOrigin = tileButton.frame.origin;
    [self swipeTileWithPoint:tileOrigin andDirection:UISwipeGestureRecognizerDirectionRight];
}

- (void)tileSwipedDown:(UISwipeGestureRecognizer *)swipeRecognizer
{
    UIButton *tileButton = (UIButton *)swipeRecognizer.view;
    CGPoint tileOrigin = tileButton.frame.origin;
    [self swipeTileWithPoint:tileOrigin andDirection:UISwipeGestureRecognizerDirectionDown];
}

- (void)tileSwipedLeft:(UISwipeGestureRecognizer *)swipeRecognizer
{
    UIButton *tileButton = (UIButton *)swipeRecognizer.view;
    CGPoint tileOrigin = tileButton.frame.origin;
    [self swipeTileWithPoint:tileOrigin andDirection:UISwipeGestureRecognizerDirectionLeft];
}

#pragma mark - helper methods
- (void)swipeTileWithPoint:(CGPoint)point andDirection:(UISwipeGestureRecognizerDirection)direction
{
    //tile swiped position
    NSInteger row = point.y / kTilesSize;
    NSInteger column = point.x / kTilesSize;
    FPPuzzleIndex *index = [[FPPuzzleIndex alloc] initWithRow:row andColumn:column];
    
    BOOL allowMove = YES;
    switch (direction) {
        case UISwipeGestureRecognizerDirectionUp:
            if (index.row == 0)
                allowMove = NO;
            break;
        case UISwipeGestureRecognizerDirectionRight:
            if (index.column == kTilesSqrt - 1)
                allowMove = NO;
            break;
        case UISwipeGestureRecognizerDirectionDown:
            if (index.row == kTilesSqrt - 1)
                allowMove = NO;
            break;
        case UISwipeGestureRecognizerDirectionLeft:
            if (index.column == 0)
                allowMove = NO;
            break;
        default:
            break;
    }
    if (allowMove)
        [self.delegate fpTileDelegateWantsMoveTileForIndex:index andDirection:direction];
}

@end
