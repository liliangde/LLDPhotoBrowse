//
//  TableViewController.m
//  TestBrowsePhotos
//
//  Created by Apple on 2017/10/17.
//  Copyright © 2017年 Livestar. All rights reserved.
//

#import "TableViewController.h"
#import "LLDPhotoBrowseViewController.h"
#import "LLDPhotoBrowseData.h"

@interface TableViewController ()
@property (strong, nonatomic) NSArray *images;

@property (strong, nonatomic) NSMutableArray <LLDPhotoBrowseData *> *imageItems;
@end

@implementation TableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.rowHeight = 60;
    
    self.images = @[
                    @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1508216918687&di=6d5d55372c0c6f6ed11f9609ca33eb4a&imgtype=0&src=http%3A%2F%2Fimg.2222.moe%2Fimages%2F2015%2F11%2F04%2F13460.png",
                    @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1508216918686&di=f308e0e8b7ea0a8d8a7483ec1b45abbb&imgtype=0&src=http%3A%2F%2Fsc.china.com.cn%2Fuploadfile%2F2014%2F0626%2F20140626103239494.jpg",
                    @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1508216918686&di=e64a6998bb94574e42d641e057c5c413&imgtype=0&src=http%3A%2F%2Fimg.china-ef.com%2Fnews%2F201602%2F22%2F2016022204191785.jpg",
                    @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1508216918686&di=347a808df8612beacc6be61c560a7e0d&imgtype=0&src=http%3A%2F%2Fwww.ikuku.cn%2Fwp-content%2Fuploads%2Fuser%2Fu1497%2FPOST%2Fp227137%2F1421724911566907-818x460.jpg",
                    @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1508217002642&di=819dae588a569eef5de1d44b578a636b&imgtype=jpg&src=http%3A%2F%2Fimg0.imgtn.bdimg.com%2Fit%2Fu%3D3032870824%2C1530799279%26fm%3D214%26gp%3D0.jpg"
                    ];
    
    self.imageItems = [NSMutableArray array];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.images.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReusableCellWithIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReusableCellWithIdentifier"];
    }
    cell.textLabel.text = @"test";
    NSURL *imageUrl = [NSURL URLWithString:self.images[indexPath.row]];
    [[YYWebImageManager sharedManager] requestImageWithURL:imageUrl options:0 progress:nil transform:nil completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = image;
            [cell setNeedsLayout];
        });
    }];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    LLDPhotoBrowseViewController *photoBrowseViewController = [[LLDPhotoBrowseViewController alloc] initWithCollectionViewLayout:layout];
    
    for (int i = 0; i < self.images.count; i++) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        LLDPhotoBrowseData *data = [[LLDPhotoBrowseData alloc] initWithOriginalImageView:cell.imageView bigImageUrl:self.images[i]];
        
        if (![self.imageItems containsObject:data]) {
            [self.imageItems addObject:data];
        }
    }
    
    [self.imageItems enumerateObjectsUsingBlock:^(LLDPhotoBrowseData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.bigImageUrl isEqualToString:self.images[indexPath.row]]) {
            photoBrowseViewController.currentBrowseData = obj;
            photoBrowseViewController.currentBrowseImageIndex = idx;
            return ;
        }
    }];
    
    photoBrowseViewController.items = self.imageItems.copy;
    
    [self presentViewController:photoBrowseViewController animated:YES completion:nil];
}

@end
