//
//  KG_ChooseSystemView.m
//  Frame
//
//  Created by zhangran on 2020/6/17.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ChooseSystemView.h"
#import "KG_ChooseSystemCell.h"
#import "KG_ChooseSystemHeaderView.h"
@interface KG_ChooseSystemView ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIButton *bgBtn ;
@property (nonatomic, strong) UIView *centerView;
@property (nonatomic, strong) UICollectionView *collectionView;
@end
@implementation KG_ChooseSystemView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupDataSubviews];
        [self createUI];
    }
    return self;
}

- (void)createUI {
    
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
       
        make.top.equalTo(self.mas_top).offset((SCREEN_HEIGHT -326)/2);
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@224);
    }];
}

- (void)buttonClickMethod:(UIButton *)btn {
     self.hidden = YES;
}
//初始化collectionview
- (void)initCollevtionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 28;
    flowLayout.minimumInteritemSpacing = 0;
    
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_top);
        make.left.equalTo(self.centerView.mas_left);
        make.right.equalTo(self.centerView.mas_right);
        make.bottom.equalTo(self.centerView.mas_bottom);
    }];
    self.collectionView.layer.cornerRadius = 10.f;
    self.collectionView.layer.masksToBounds = YES;
    [self.collectionView registerClass:[KG_ChooseSystemCell class] forCellWithReuseIdentifier:@"KG_ChooseSystemCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.collectionView registerClass:[KG_ChooseSystemHeaderView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KG_ChooseSystemHeaderView"];
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return self.dataArray.count;
}
#pragma mark ---- collectionView 数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.collectionView) {
        KG_ChooseSystemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KG_ChooseSystemCell" forIndexPath:indexPath];
        cell.dataDic = self.dataArray[indexPath.row];
        
        return cell;
    }
    return nil;
    
    
}

#pragma mark  定义每个UICollectionViewCell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return  CGSizeMake(SCREEN_WIDTH/2,50);
    
}

#pragma mark - collectionView代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
}
/**  数组  */
-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
    return CGSizeMake(SCREEN_WIDTH, 50);
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    if (kind == UICollectionElementKindSectionHeader) {
        
        KG_ChooseSystemHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"KG_ChooseSystemHeaderView" forIndexPath:indexPath];
      
        return headerView;
    }
    return nil;
}

@end
