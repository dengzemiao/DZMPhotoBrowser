//
//  ViewController.m
//  DZMPhotoBrowser
//
//  Created by 邓泽淼 on 2017/6/6.
//  Copyright © 2017年 DZM. All rights reserved.
//

#import "ViewController.h"
#import "TempCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "DZMPhotoBrowser.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,DZMPhotoBrowserDelegate>

/// 布局视图 (这里拿 UICollectionView 做示例)
@property(nonatomic, weak) UICollectionView *collectionView;

/// 数据源
@property(nonatomic, strong) NSArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    /*
     
     DZMPhotoBrowser 基于SDWebImage使用 方便清理缓存 支持屏幕旋转 横竖屏
     
     更具导入SDWebImage的方式选择头文件的导入 -> 进入DZMPhotoView.m进行修改
     
     /// 本地文件导入使用头文件（默认）
     #import "UIImageView+WebCache.h"
     
     /// Pods FrameWork 导入
     //#import <SDWebImage/UIImageView+WebCache.h>
     
     */
    
    // 数据源 为了效果 里面放了几张会加载失败的图
    self.dataArray = @[@"http://d.hiphotos.baidu.com/image/pic/item/5fdf8db1cb1349540a4949a65f4e9258d0094a98.jpg",
                       @"http://f.hiphotos.baidu.com/image/pic/item/64380cd7912397dd4417d0c45082b2b7d1a28780.jpg",
                       @"http://f.hiphotos.baidu.com/image/pic/item/962bd40735fae6cde68fa24605b30f2442a70fd9.jpg",
                       @"http://attach.bbs.miui.com/forum/201402/21/120044k1dgtgc4dg2dm5tw.jpg",
                       @"http://img4.duitang.com/uploads/item/201210/24/20121024113044_vkmru.jpeg",
                       @"http://img1.pconline.com.cn/piclib/200812/22/batch/1/19891/1229912689801ax8ecag2i4.jpg",
                       @"http://img1.pconline.com.cn/piclib/200812/22/batch/1/19891/1229912689801exkclwbfwp.jpg",
                       @"http://pic.jj20.com/up/allimg/811/0QG4150121/140QG50121-3.jpg",
                       @"http://pic19.nipic.com/20120304/8289149_124317697104_2.jpg",
                       @"http://img6.3lian.com/c23/desk4/04/57/d/10.jpg",
                       @"http://img1.imgtn.bdimg.com/it/u=2257815950,312335915&fm=11&gp=0.jpg",
                       @"http://www.pp3.cn/uploads/allimg/111111/1PFS107-6.jpg",
                       @"http://pic64.nipic.com/file/20150409/20075253_150454101000_2.jpg",
                       @"http://img1.pconline.com.cn/piclib/200906/01/batch/1/34327/1243861021007uuc3wttw5y.jpg",
                       @"http://img1.pconline.com.cn/piclib/200906/23/batch/1/35837/1245721961246u6ccwwpof7.jpg",
                       @"http://pic41.nipic.com/20140501/18539861_154547256112_2.jpg",
                       @"http://img6.3lian.com/c23/desk4/03/25/d/14.jpg",
                       @"http://img1.pconline.com.cn/piclib/200812/22/batch/1/19891/1229912689794oi70rrwayf.jpg",
                       @"http://img2.imgtn.bdimg.com/it/u=635311535,1396226307&fm=27&gp=0.jpg",
                       @"http://pic71.nipic.com/file/20150629/19439905_120053529000_2.jpg",
                       @"http://img0.imgtn.bdimg.com/it/u=1239773878,3509765158&fm=214&gp=0.jpg",
                       @"http://f1.bj.anqu.com/down/OTI5OQ==/allimg/1208/48-120P61A042.jpg",
                       @"http://img1.pconline.com.cn/piclib/200809/07/batch/1/11200/1220802017248cwfaw5w6nk.jpg",
                       @"http://pic66.nipic.com/file/20150513/20186525_100135381000_2.jpg",
                       @"http://img1.pconline.com.cn/piclib/200812/22/batch/1/19891/1229912689801ax8ecag2i4.jpg",
                       @"http://img1.pconline.com.cn/piclib/200812/03/batch/1/18429/1228271570399kzpzogs1dt.jpg",
                       @"http://img1.pconline.com.cn/piclib/200812/29/batch/1/20352/1230565636011szj81ayoo9.jpg"];
    
    // collectionView
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height / 2;
    CGFloat y = ([UIScreen mainScreen].bounds.size.height - h) / 2;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(100, 100);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, y, w, h) collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.alwaysBounceHorizontal = YES;
    [collectionView registerClass:[TempCollectionViewCell class] forCellWithReuseIdentifier:@"ID"];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TempCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ID" forIndexPath:indexPath];
    
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.dataArray[indexPath.item]] placeholderImage:[UIImage imageNamed:@"Temp"]];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TempCollectionViewCell *cell = (TempCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    NSMutableArray<DZMPhoto *> *photos = [NSMutableArray array];
    
    for (NSString *url in self.dataArray) {
        
        DZMPhoto *photo = [[DZMPhoto alloc] init];
        
        photo.url = [NSURL URLWithString:url];
        
        [photos addObject:photo];
    }
    
    photos[indexPath.item].imageView = cell.imageView;
    
    DZMPhotoBrowser *browser = [[DZMPhotoBrowser alloc] init];
    browser.delegate = self;
    browser.photos = photos;
    browser.initSelectIndex = indexPath.item;
    [browser show];
}

#pragma mark - DZMPhotoBrowserDelegate

- (void)photoBrowser:(DZMPhotoBrowser *)photoBrowser didShowPhoto:(DZMPhoto *)photo
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:photo.index inSection:0];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:0 animated:NO];
    
    NSLog(@"%ld",(long)photo.index);
}

- (void)photoBrowser:(DZMPhotoBrowser *)photoBrowser willHiddenPhoto:(DZMPhoto *)photo
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:photo.index inSection:0];
    
    TempCollectionViewCell *cell = (TempCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    
    if (cell) {
        
        photo.imageView = cell.imageView;
    }
    
    NSLog(@"%ld",(long)photo.index);
}

- (void)photoBrowser:(DZMPhotoBrowser *)photoBrowser savePhoto:(DZMPhoto *)photo error:(NSError *)error
{
    if (error) {
        
        NSLog(@"保存失败");
        
    }else{
        
        NSLog(@"保存成功");
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
