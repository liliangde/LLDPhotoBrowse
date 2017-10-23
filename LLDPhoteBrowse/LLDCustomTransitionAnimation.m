//
//  LLDCustomTransitionAnimation.m
//  TestBrowsePhotos
//
//  Created by Apple on 2017/10/17.
//  Copyright © 2017年 Livestar. All rights reserved.
//

#import "LLDCustomTransitionAnimation.h"
#import "LLDPhotoBrowseViewController.h"
#import "TableViewController.h"

@interface LLDCustomTransitionAnimation ()

@property (assign, nonatomic) TransitionAnimationType animationType;

@property (weak, nonatomic) UIImageView *originalImageView;

@end

@implementation LLDCustomTransitionAnimation

- (instancetype)initWithType:(TransitionAnimationType)animationType{
    if (self = [super init]) {
        _animationType = animationType;
    }
    return self;
}

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext;{
    return 0.25;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext;{
    UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
    UIView *containerView = transitionContext.containerView;
    
    LLDPhotoBrowseViewController *toViewContoller = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    LLDPhotoBrowseViewController *fromViewContoller = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIImageView *snapShotOriginalImageView = nil;
    UIView *backGroundView = nil;
    
    switch (self.animationType) {
        case TransitionAnimationTypePresent:
        {
            [containerView addSubview:toView];
            toView.alpha = 0;
            
            snapShotOriginalImageView = [[UIImageView alloc] initWithImage:toViewContoller.currentBrowseData.originalImageView.image];
            snapShotOriginalImageView.frame = toViewContoller.currentBrowseData.originalImageConvertedViewFrame;
            [containerView addSubview:snapShotOriginalImageView];
            
            backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
            backGroundView.backgroundColor = [UIColor blackColor];
            backGroundView.alpha = 0;
            
            [containerView insertSubview:backGroundView belowSubview:snapShotOriginalImageView];
            
        }
            break;
        case TransitionAnimationTypeDismiss:
        {
            [containerView insertSubview:toView belowSubview:fromView];
            
            fromViewContoller.currentBrowseData.currentBrowseBigImageView.hidden = YES;
            
            snapShotOriginalImageView = [[UIImageView alloc] initWithImage:fromViewContoller.currentBrowseData.currentBrowseBigImageView.image];
            snapShotOriginalImageView.frame = fromViewContoller.currentBrowseData.currentBrowseBigImageView.frame;
            [containerView addSubview:snapShotOriginalImageView];
        }
            break;
    }
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration animations:^{
        switch (self.animationType) {
            case TransitionAnimationTypePresent:
            {
                backGroundView.alpha = 1;
                snapShotOriginalImageView.size = toViewContoller.currentBrowseData.bigImageViewSize;
                snapShotOriginalImageView.center = CGPointMake(kScreenWidth * 0.5, kScreenHeight * 0.5);
            }
                break;
            case TransitionAnimationTypeDismiss:
            {
                snapShotOriginalImageView.frame = fromViewContoller.currentBrowseData.originalImageConvertedViewFrame;
                fromView.alpha = 0;
            }
                break;
        }
    } completion:^(BOOL finished) {
        toView.alpha = 1;
        [snapShotOriginalImageView removeFromSuperview];
        [backGroundView removeFromSuperview];
        
        switch (self.animationType) {
            case TransitionAnimationTypePresent:
            {
                //添加fromView的截图 到toview
                UIView *snapShotOfFromView = [fromView snapshotViewAfterScreenUpdates:NO];
                [toView insertSubview:snapShotOfFromView atIndex:0];
            }
                break;
            case TransitionAnimationTypeDismiss:
            {
                
            }
                break;
        }
        
        BOOL cancel = transitionContext.transitionWasCancelled;
        [transitionContext completeTransition:!cancel];
    }];
}

@end
