//
//  LLDCollectionViewFlowLayout.m
//  LLDPhoteBrowse
//
//  Created by Apple on 2017/10/27.
//  Copyright © 2017年 Livestar. All rights reserved.
//

#import "LLDCollectionViewFlowLayout.h"

@implementation LLDCollectionViewFlowLayout

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    // 计算出最终显示的矩形框
    CGRect rect;
    rect.origin.y = 0;
    rect.origin.x = self.collectionView.contentOffset.x;
    rect.size = self.collectionView.frame.size;

    // 获得rect中的layout属性集
    NSArray<UICollectionViewLayoutAttributes *> *attrsArray = [super layoutAttributesForElementsInRect:rect];
    
    CGFloat contentOffsetX = self.collectionView.contentOffset.x;
    CGFloat firstElementX = attrsArray.firstObject.frame.origin.x;
    CGFloat lastElementX = attrsArray.lastObject.frame.origin.x;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (velocity.x > 0) {//左滑
            [self.collectionView setContentOffset:attrsArray.lastObject.frame.origin animated:YES];
        }else if (velocity.x < 0){//右滑
            [self.collectionView setContentOffset:attrsArray.firstObject.frame.origin animated:YES];
        }else{
            if (contentOffsetX - firstElementX > lastElementX - contentOffsetX) {
                [self.collectionView setContentOffset:attrsArray.lastObject.frame.origin animated:YES];
            }else{
                [self.collectionView setContentOffset:attrsArray.firstObject.frame.origin animated:YES];
            }
        }
    });
    
    return proposedContentOffset;
}

@end
