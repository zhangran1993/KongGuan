//
//  KG_WeiHuCardAlertView.m
//  Frame
//
//  Created by zhangran on 2020/7/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_WeiHuCardAlertView.h"
#import "KG_WeiHuCardAlertCell.h"
#import "KG_WeiHuCardAlertHeaderView.h"
@interface KG_WeiHuCardAlertView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
}

@property (nonatomic ,strong) UICollectionView *collectionView;
@property (nonatomic ,strong) NSArray *listArray;
@property (nonatomic ,strong) UIButton *bgBtn;
@property (nonatomic ,strong) UIView *centerView;
@property (nonatomic ,strong) NSDictionary *dataDic;

@end

@implementation KG_WeiHuCardAlertView


- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupDataSubviews];
        [self initCollevtionView];
    }
    return self;
}


//初始化collectionview
- (void)initCollevtionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(120, 24);
    layout.minimumLineSpacing = 10.0;
    layout.minimumInteritemSpacing = 0.0;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    layout.headerReferenceSize = CGSizeMake(self.frame.size.width, 50);
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    [self.centerView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_top);
        make.left.equalTo(self.centerView.mas_left);
        make.width.equalTo(self.centerView.mas_width);
        make.right.equalTo(self.centerView.mas_right);
        make.bottom.equalTo(self.centerView.mas_bottom);
    }];
    self.collectionView.layer.cornerRadius = 10.f;
    self.collectionView.layer.masksToBounds = YES;
    [self.collectionView registerClass:[KG_WeiHuCardAlertHeaderView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KG_WeiHuCardAlertHeaderView"];
    [self.collectionView registerClass:[KG_WeiHuCardAlertCell class] forCellWithReuseIdentifier:@"KG_WeiHuCardAlertCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
   
}
#pragma mark ---- collectionView 数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataArray.count;
    }else {
        if(self.dataArray.count){
            
            if (self.curSelDic.count) {
                NSArray *arr = self.curSelDic[@"equipmentList"];
                
                return arr.count;
            }else {
                return 0;
            }
            
        }else {
            return 0;
        }
    }
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.collectionView) {
        KG_WeiHuCardAlertCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KG_WeiHuCardAlertCell" forIndexPath:indexPath];
        
        cell.button.tag = indexPath.section;
        //添加按钮点击事件
        [cell.button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        if (self.curSelDic.count >0) {
            cell.selDic = self.curSelDic;
        }
        if (self.curSelDetailDic.count >0) {
            cell.selDetailDic = self.curSelDetailDic;
        }
       
        if(indexPath.section == 0) {
            NSDictionary *dic = self.dataArray[indexPath.row];
            
            cell.dataDic = dic;
        }else {

            if (self.dataArray.count ) {
                 
                if (self.curSelDic.count) {
                    NSArray *arr = self.curSelDic[@"equipmentList"];
                    cell.detailDic = arr[indexPath.row];
                }
                
            }
            
        }
       
        
//        cell.buttonBlockMethod = ^(NSDictionary * _Nonnull dataDic, NSDictionary * _Nonnull detailDic, NSInteger tag) {
//
//
//
//            NSLog(@"%@",dataDic);
//        };
//
        return cell;
    }
    return nil;
    
    
}

//按钮点击事件
-(void)click:(UIButton *)btn{
    
    UIView *contentView = [btn superview];
    KG_WeiHuCardAlertCell *cell = (KG_WeiHuCardAlertCell *)contentView;
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    NSLog(@"%ld----%ld",(long)indexPath.row,(long)indexPath.section);
    if (indexPath.section == 0) {
        NSDictionary *dic = self.listArray[indexPath.row];
        self.curSelDic = dic;
    }else {
        if (self.curSelDic.count >0) {
            NSArray *arr = self.curSelDic[@"equipmentList"];
            NSDictionary *dic = arr[indexPath.row];
            self.curSelDetailDic = dic;
            if (self.buttonBlockMethod) {
                self.buttonBlockMethod(self.curSelDic, self.curSelDetailDic);
            }
        }
    }
  
   
   
    
    if (indexPath.section == 1) {
        self.hidden = YES;
    }
    [self.collectionView reloadData];
    
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        KG_WeiHuCardAlertHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"KG_WeiHuCardAlertHeaderView" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headerView.titleLabel.text = @"选择系统";
        }else {
            headerView.titleLabel.text = @"选择设备";
        }
        
        return headerView;
    }
    return nil;
}
#pragma mark  定义每个UICollectionViewCell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return  CGSizeMake(120,32);
    
}

#pragma mark - collectionView代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
    
    
}


//创建视图
-(void)setupDataSubviews
{
    //按钮背景 点击消失
    self.bgBtn = [[UIButton alloc]init];
    [self addSubview:self.bgBtn];
    [self.bgBtn setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    self.bgBtn.alpha = 0.46;
    [self.bgBtn addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.centerView = [[UIView alloc] init];
    self.centerView.frame = CGRectMake(52.5,209,270,242);
    self.centerView.backgroundColor = [UIColor whiteColor];
    self.centerView.layer.cornerRadius = 12;
    self.centerView.layer.masksToBounds = YES;
    [self addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@270);
        make.height.equalTo(@300);
    }];

    
   
}
//取消
- (void)cancelMethod:(UIButton *)button {
    self.hidden = YES;
  
}
//确定
- (void)confirmMethod:(UIButton *)button {
    if (self.confirmBlockMethod) {
        self.confirmBlockMethod(self.dataDic);
    }
}
- (void)buttonClickMethod:(UIButton *)button {
//    self.hidden = YES;
   
}
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    if (self.curSelDic.count == 0) {
        self.curSelDic = [dataArray firstObject];
        if (self.curSelDic.count >0) {
            NSArray *arr = self.curSelDic[@"equipmentList"];
            if (arr.count) {
                self.curSelDetailDic = [arr firstObject];
            }
            
        }
        
    }else {
        
    }
    
    self.listArray = dataArray;
    [self.collectionView reloadData];
}

- (void)setCurSelDic:(NSDictionary *)curSelDic {
    _curSelDic = curSelDic;
}

- (void)setCurSelDetailDic:(NSDictionary *)curSelDetailDic {
    _curSelDetailDic = curSelDetailDic;
}
@end
