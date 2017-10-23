//
//  LLDPhotoBrowseViewController.h
//  TestBrowsePhotos
//
//  Created by Apple on 2017/10/17.
//  Copyright © 2017年 Livestar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLDPhotoBrowseData.h"

@interface LLDPhotoBrowseViewController : UICollectionViewController

@property (strong, nonatomic) LLDPhotoBrowseData *currentBrowseData;
@property (assign, nonatomic) NSInteger currentBrowseImageIndex;
@property (strong, nonatomic) NSArray <LLDPhotoBrowseData *> *items;

@end
