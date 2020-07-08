//
//  KG_SelVideoView.m
//  Frame
//
//  Created by zhangran on 2020/5/25.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_SelVideoView.h"
#import "KG_SelVideoCollectionViewCell.h"
#import "KG_SelVideoAddCell.h"
#import "KG_ImagePickerView.h"
@interface KG_SelVideoView ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    
}
@property (nonatomic,strong) KG_ImagePickerView *myPicker;
//上传图片
@property (nonatomic,strong) UICollectionView * collectionView;


@end


@implementation KG_SelVideoView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self setupDataSubviews];
        
    }
    return self;
}
//初始化数据
- (void)initData {
   
}

//创建视图
-(void)setupDataSubviews
{
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
}
//
///**  懒加载  */
//-(NSMutableArray *)dataArray{
//    if (_dataArray == nil) {
//        _dataArray= [NSMutableArray array];
//    }
//    return _dataArray;
//}


-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.minimumLineSpacing = 10;
        flowLayout.minimumInteritemSpacing = 0;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 31, SCREEN_WIDTH, 80) collectionViewLayout:flowLayout];
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.contentInset = UIEdgeInsetsMake(0,0,0,0);
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        [_collectionView registerClass:[KG_SelVideoCollectionViewCell class] forCellWithReuseIdentifier:@"KG_SelVideoCollectionViewCell"];
        [_collectionView registerClass:[KG_SelVideoAddCell class] forCellWithReuseIdentifier:@"KG_SelVideoAddCell"];

        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
    }
    return _collectionView;
}
#pragma mark ---- collectionView 数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return self.videoArray.count +1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    
    if (collectionView == self.collectionView) {
        if (indexPath.row == self.videoArray.count) {
            KG_SelVideoAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KG_SelVideoAddCell" forIndexPath:indexPath];
            WS(weakSelf)
            cell.addVideoMethod = ^{
                if (self.addVideoMethod) {
                    self.addVideoMethod();
                }
            };
            return cell;
        }
        KG_SelVideoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KG_SelVideoCollectionViewCell" forIndexPath:indexPath];
        cell.closeBtn.tag = indexPath.row;
        cell.closeVideoMethod = ^(NSInteger index) {
            
            [self.videoArray removeObjectAtIndex:index];
            [self.collectionView reloadData];
            if (self.closeVideoMethod) {
                self.closeVideoMethod(index);
            }
        };
       
        NSString *str = safeString(self.videoArray[indexPath.row]);
        if ([str containsString:@"http"]) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.videoArray[indexPath.row]]];
            // 获取第一帧图片
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
            AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            generate.appliesPreferredTrackTransform = YES;
            NSError *err = NULL;
            CMTime time = CMTimeMake(1, 2);
            CGImageRef oneRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
            UIImage *oneImg = [[UIImage alloc] initWithCGImage:oneRef];
            [cell.iconImage setImage:oneImg forState:UIControlStateNormal];
        }else {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WebNewHost,self.videoArray[indexPath.row]]];
            // 获取第一帧图片
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
            AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            generate.appliesPreferredTrackTransform = YES;
            NSError *err = NULL;
            CMTime time = CMTimeMake(1, 2);
            CGImageRef oneRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
            UIImage *oneImg = [[UIImage alloc] initWithCGImage:oneRef];
             [cell.iconImage setImage:oneImg forState:UIControlStateNormal];
        }
        [cell.iconImage addTarget:self action:@selector(zhankaiBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
        cell.iconImage.tag = indexPath.row;
        return cell;
        
    }
    
    return nil;
    
}

- (void)zhankaiBtnMethod :(UIButton *)button {
    NSString *str = safeString(self.videoArray[button.tag]);
    if (self.playVideoMethod) {
        self.playVideoMethod(str);
    }
    
}

#pragma mark  定义每个UICollectionViewCell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return  CGSizeMake(100 ,60);
    
}

#pragma mark - collectionView代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
}

- (void)setVideoArray:(NSMutableArray *)videoArray{
    _videoArray =videoArray;
    [self.collectionView reloadData];
}
@end
