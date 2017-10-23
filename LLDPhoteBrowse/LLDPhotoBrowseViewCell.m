//
//  LLDPhotoBrowseViewCell.m
//  TestBrowsePhotos
//
//  Created by Apple on 2017/10/17.
//  Copyright © 2017年 Livestar. All rights reserved.
//

#import "LLDPhotoBrowseViewCell.h"

#define kImageViewMaximumZoomScale 2

@interface LLDPhotoBrowseViewCell ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIImageView *imageView;
@property (assign, nonatomic) CGFloat superViewAlpha;
@end

@implementation LLDPhotoBrowseViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.scrollView = ({
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.minimumZoomScale = 1;
        _scrollView.maximumZoomScale = kImageViewMaximumZoomScale;
        _scrollView.delegate = self;
        _scrollView;
    });
    
    [self.contentView addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    self.imageView.userInteractionEnabled = YES;
    [self.scrollView addSubview:self.imageView];
    
    [self loadGestures];
}

- (void)setData:(LLDPhotoBrowseData *)data{
    _data = data;
    [self.imageView yy_setImageWithURL:[NSURL URLWithString:data.bigImageUrl] placeholder:data.originalImageView.image];
    self.imageView.size = data.bigImageViewSize;
    self.imageView.center = self.scrollView.center;
    data.currentBrowseBigImageView = self.imageView;
    
    [self.scrollView setZoomScale:1 animated:NO];
}

- (void)loadGestures{
    
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [self.imageView addGestureRecognizer:doubleTapGestureRecognizer];
    
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTap:)];
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    [self.imageView addGestureRecognizer:singleTapGestureRecognizer];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    panGestureRecognizer.delegate = self;
    [self.imageView addGestureRecognizer:panGestureRecognizer];
    
}

- (void)singleTap:(UITapGestureRecognizer *)gesture{
    if ([self.delegate respondsToSelector:@selector(didSingleTap:)]) {
        [self.delegate didSingleTap:self.data];
    }
}

- (void)doubleTap:(UITapGestureRecognizer *)gesture{
    if (self.scrollView.zoomScale <= 1) {
        // 1
        CGPoint pointInView = [gesture locationInView:self.imageView];
        
        // 2
        CGFloat newZoomScale = self.scrollView.zoomScale * kImageViewMaximumZoomScale;
        newZoomScale = MIN(newZoomScale, self.scrollView.maximumZoomScale);
        
        // 3
        CGSize scrollViewSize = self.scrollView.bounds.size;
        
        CGFloat w = scrollViewSize.width / newZoomScale;
        CGFloat h = scrollViewSize.height / newZoomScale;
        CGFloat x = pointInView.x - (w / 2.0f);
        CGFloat y = pointInView.y - (h / 2.0f);
        CGRect rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4
        [self.scrollView zoomToRect:rectToZoomTo animated:YES];
    }else{
        [self.scrollView setZoomScale:1 animated:YES];
    }
}

- (void)didPan:(UIPanGestureRecognizer *)gesture{
    CGPoint currentPoint = [gesture locationInView:self.scrollView];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGPoint anchorPoint = [gesture locationInView:self.imageView];
            self.imageView.layer.anchorPoint = CGPointMake(anchorPoint.x / self.imageView.width, anchorPoint.y / self.imageView.height);
            self.imageView.center = currentPoint;
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            self.imageView.center = currentPoint;
            
            CGPoint point = [gesture translationInView:self.scrollView];
            if (point.y > 0) {
                self.superViewAlpha = 1 - point.y / 800;
                self.superview.backgroundColor = [UIColor colorWithWhite:0 alpha:self.superViewAlpha];
            }else{
                self.superViewAlpha = 1;
                self.superview.backgroundColor = [UIColor colorWithWhite:0 alpha:self.superViewAlpha];
            }
            
            self.imageView.transform = CGAffineTransformMakeScale(self.superViewAlpha, self.superViewAlpha);
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
        {
            if (self.superViewAlpha < 0.7) {
                //dismiss
                [self singleTap:nil];
            }else{
                [UIView animateWithDuration:0.25 animations:^{
                    self.imageView.layer.anchorPoint = CGPointMake(0.5, 0.5);
                    self.imageView.center = self.scrollView.center;
                    self.superview.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
                    self.imageView.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                }];
                
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - scrollView zoom  代理方法
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    self.imageView.center = self.scrollView.center;
    //如果超出scrollView，则调整位置
    if (self.imageView.left < 0) self.imageView.left = 0;
    if (self.imageView.top < 0) self.imageView.top = 0;
}

#pragma mark - 解决pan手势 和collectionView的滚动手势冲突
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *panGestureRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint point = [panGestureRecognizer translationInView:self];
        if (point.y != 0) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return YES;
    }
}

@end
