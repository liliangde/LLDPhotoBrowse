//
//  LLDPhotoBrowseData.m
//  TestBrowsePhotos
//
//  Created by Apple on 2017/10/17.
//  Copyright © 2017年 Livestar. All rights reserved.
//

#import "LLDPhotoBrowseData.h"

@implementation LLDPhotoBrowseData

- (instancetype)initWithOriginalImageView:(UIImageView *)imageView bigImageUrl:(NSString *)bigImageUrl{
    if (self = [super init]) {
        self.originalImageView = imageView;
        CGRect frame = [imageView convertRect:imageView.frame toViewOrWindow:[UIApplication sharedApplication].keyWindow];
        frame.origin = CGPointMake(frame.origin.x - 16, frame.origin.y);
        self.originalImageConvertedViewFrame = frame;
        self.bigImageUrl = bigImageUrl;
        CGFloat height = self.originalImageView.image.size.height * kScreenWidth / self.originalImageView.image.size.width;
        self.bigImageViewSize = CGSizeMake(kScreenWidth, height);
    }
    return self;
}

- (BOOL)isEqual:(id)object{
    if ([[object bigImageUrl] isEqual:self.bigImageUrl]) {
        return YES;
    }else{
        return NO;
    }
}

@end
