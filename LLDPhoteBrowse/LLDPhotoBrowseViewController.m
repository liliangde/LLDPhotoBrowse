//
//  LLDPhotoBrowseViewController.m
//  TestBrowsePhotos
//
//  Created by Apple on 2017/10/17.
//  Copyright © 2017年 Livestar. All rights reserved.
//

#import "LLDPhotoBrowseViewController.h"
#import "LLDCustomTransitionAnimation.h"
#import "LLDPhotoBrowseViewCell.h"
#import "LLDCustomPercentDrivenInteractiveTransition.h"

#define itemMinimumSpacing 10

@interface LLDPhotoBrowseViewController () <UIViewControllerTransitioningDelegate,LLDPhotoBrowseViewCellDelegate>

@property (strong, nonatomic) LLDCustomPercentDrivenInteractiveTransition *percentDrivenInteractiveTransition;

@end

@implementation LLDPhotoBrowseViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.transitioningDelegate = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *)self.collectionViewLayout;
    layout.itemSize = CGSizeMake(kScreenWidth, kScreenHeight);
    layout.minimumLineSpacing = itemMinimumSpacing;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    self.collectionView.pagingEnabled = YES;
    
    [self.collectionView registerClass:[LLDPhotoBrowseViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.currentBrowseImageIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    
    self.percentDrivenInteractiveTransition = [[LLDCustomPercentDrivenInteractiveTransition alloc] init];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithActionBlock:^(UIPanGestureRecognizer * _Nonnull sender) {
        if (sender.state == UIGestureRecognizerStateBegan) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        if (sender.state == UIGestureRecognizerStateChanged) {
            CGPoint location = [sender locationInView:self.view];
            [self.percentDrivenInteractiveTransition updateInteractiveTransition:(location.y / self.view.height)];
        }
        if (sender.state == UIGestureRecognizerStateEnded) {
            [self.percentDrivenInteractiveTransition finishInteractiveTransition];
        }
    }];
    [self.view addGestureRecognizer:panGestureRecognizer];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.collectionView.width = kScreenWidth + itemMinimumSpacing;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LLDPhotoBrowseViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    LLDPhotoBrowseData *item = self.items[indexPath.row];
    cell.delegate = self;
    cell.data = item;
    NSLog(@"%ld",indexPath.row);
    return cell;
}

- (void)didSingleTap:(LLDPhotoBrowseData *)currentData{
    self.currentBrowseData = currentData;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 非交互式转场动画的代理
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source;{
    return [[LLDCustomTransitionAnimation alloc] initWithType:TransitionAnimationTypePresent];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed;{
    return [[LLDCustomTransitionAnimation alloc] initWithType:TransitionAnimationTypeDismiss];
}

#pragma mark - 交互式转场动画的代理
- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator{
    return nil;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id <UIViewControllerAnimatedTransitioning>)animator{
//    return self.percentDrivenInteractiveTransition;
    return nil;
}

@end
