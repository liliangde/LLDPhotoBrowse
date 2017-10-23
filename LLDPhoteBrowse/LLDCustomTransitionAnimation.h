//
//  LLDCustomTransitionAnimation.h
//  TestBrowsePhotos
//
//  Created by Apple on 2017/10/17.
//  Copyright © 2017年 Livestar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    TransitionAnimationTypePresent,
    TransitionAnimationTypeDismiss
} TransitionAnimationType;

@interface LLDCustomTransitionAnimation : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithType:(TransitionAnimationType)animationType;

@end
