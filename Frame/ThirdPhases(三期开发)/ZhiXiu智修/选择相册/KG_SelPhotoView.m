//
//  KG_SelPhotoView.m
//  Frame
//
//  Created by zhangran on 2020/5/25.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_SelPhotoView.h"
#import "KG_SelPhotoCollectionViewCell.h"
#import "KG_SelPhotoAddCell.h"
#import "KG_ImagePickerView.h"
@interface KG_SelPhotoView ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    
}
@property (nonatomic,strong) KG_ImagePickerView *myPicker;
//上传图片
@property (nonatomic,strong) UICollectionView * collectionView;


@end


@implementation KG_SelPhotoView

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
        [_collectionView registerClass:[KG_SelPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"KG_SelPhotoCollectionViewCell"];
        [_collectionView registerClass:[KG_SelPhotoAddCell class] forCellWithReuseIdentifier:@"KG_SelPhotoAddCell"];

        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.scrollEnabled = NO;
        _collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        
    }
    return _collectionView;
}
#pragma mark ---- collectionView 数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
   
    return self.dataArray.count +1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
   
    
    if (collectionView == self.collectionView) {
        if (indexPath.row == self.dataArray.count) {
            KG_SelPhotoAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KG_SelPhotoAddCell" forIndexPath:indexPath];
            WS(weakSelf)
            cell.addMethod = ^{
                if (self.addMethod) {
                    self.addMethod();
                }
            };
            return cell;
        }
        KG_SelPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KG_SelPhotoCollectionViewCell" forIndexPath:indexPath];
        cell.closeBtn.tag = indexPath.row;
        cell.closeMethod = ^(NSInteger index) {
            
            [self.dataArray removeObjectAtIndex:index];
            [self.collectionView reloadData];
            if (self.closeMethod) {
                self.closeMethod(index);
            }
        };
        NSString *str = safeString(self.dataArray[indexPath.row]);
        if ([str containsString:@"http"]) {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.dataArray[indexPath.row]]];
            [cell.iconImage sd_setImageWithURL:url];
        }else {
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",WebNewHost,self.dataArray[indexPath.row]]];
            [cell.iconImage sd_setImageWithURL:url];
        }
        
        return cell;
        
    }
    
    return nil;
  
}

#pragma mark  定义每个UICollectionViewCell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return  CGSizeMake(70 ,70);
    
}

#pragma mark - collectionView代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray =dataArray;
    [self.collectionView reloadData];
}
@end
