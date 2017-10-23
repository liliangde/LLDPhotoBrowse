//
//  LLDPhotoBrowseViewCell.h
//  TestBrowsePhotos
//
//  Created by Apple on 2017/10/17.
//  Copyright © 2017年 Livestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLDPhotoBrowseData.h"

@protocol LLDPhotoBrowseViewCellDelegate <NSObject>

- (void)didSingleTap:(LLDPhotoBrowseData *)currentData;

@end

@interface LLDPhotoBrowseViewCell : UICollectionViewCell

@property (strong, nonatomic) LLDPhotoBrowseData *data;

@property (weak, nonatomic) id <LLDPhotoBrowseViewCellDelegate> delegate;

@end
