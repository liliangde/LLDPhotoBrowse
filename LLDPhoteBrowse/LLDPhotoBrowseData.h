//
//  LLDPhotoBrowseData.h
//  TestBrowsePhotos
//
//  Created by Apple on 2017/10/17.
//  Copyright © 2017年 Livestar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLDPhotoBrowseData : NSObject

- (instancetype)initWithOriginalImageView:(UIImageView *)imageView bigImageUrl:(NSString *)bigImageUrl;

@property (weak, nonatomic) UIImageView *originalImageView;
@property (assign, nonatomic) CGRect originalImageConvertedViewFrame;
@property (copy, nonatomic) NSString *bigImageUrl;
@property (weak, nonatomic) UIImageView *currentBrowseBigImageView;
@property (assign, nonatomic) CGSize bigImageViewSize;

@end
