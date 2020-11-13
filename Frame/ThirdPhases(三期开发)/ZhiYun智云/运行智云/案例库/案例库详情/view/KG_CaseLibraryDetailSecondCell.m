//
//  KG_CaseLibraryDetailFirstCell.m
//  Frame
//
//  Created by zhangran on 2020/10/15.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CaseLibraryDetailSecondCell.h"
#import "KG_CaseLibraryTypeSignCell.h"
#import "KG_CaseLibraryTypeHeaderView.h"
@interface KG_CaseLibraryDetailSecondCell       ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
}

@property (nonatomic ,strong)     NSArray         *typeArray;
 
@property (nonatomic ,strong)     NSArray         *signArray;
 
@property (nonatomic ,strong)     NSArray         *dataArray;


@property (nonatomic ,strong)     UIView          *centerView;

@property (nonatomic ,strong)     UILabel         *typeTitleLabel;

@property (nonatomic ,strong)     UIImageView     *typeIconImage;

@property (nonatomic ,strong)     UILabel         *typeTextLabel;

@property (nonatomic ,strong)     UIView          *lineView;

@property (nonatomic ,strong)     UIImageView     *signIconImage;

@property (nonatomic ,strong)     UILabel         *signTitleLabel;


@property (nonatomic,strong)      UICollectionView *collectionView;


@end

@implementation KG_CaseLibraryDetailSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviewsView];
    }
    return self;
}

- (void)createSubviewsView {
    
    
    self.centerView = [[UIView alloc]init];
    self.centerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(self.mas_height);
    }];
    self.centerView.layer.cornerRadius = 10.f;
    self.centerView.layer.masksToBounds = YES;
//    self.centerView.layer.shadowOffset = CGSizeMake(0,2);
//    self.centerView.layer.shadowOpacity = 1;
//    self.centerView.layer.shadowRadius = 2;

    [self initCollevtionView];
    
}
//
//"caseLabelList": ["DVOR"],                     //设备标签
//"caseModelList": ["DVOR"],                    //适用型号
- (void)setDataModel:(KG_CaseLibraryDetailModel *)dataModel {
    _dataModel = dataModel;
   
    self.typeArray = dataModel.caseLabelList;
    self.signArray = dataModel.caseModelList;
    [self.collectionView reloadData];
    
}

//初始化collectionview
- (void)initCollevtionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 28;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH-32, 50);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    [self.centerView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_top);
        make.left.equalTo(self.centerView.mas_left);
        make.right.equalTo(self.centerView.mas_right);
        make.bottom.equalTo(self.centerView.mas_bottom);
    }];
    self.collectionView.layer.cornerRadius = 10.f;
    self.collectionView.layer.masksToBounds = YES;
    [self.collectionView registerClass:[KG_CaseLibraryTypeSignCell class] forCellWithReuseIdentifier:@"KG_CaseLibraryTypeSignCell"];
    
    [self.collectionView registerClass:[KG_CaseLibraryTypeHeaderView class]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"KG_CaseLibraryTypeHeaderView"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
   
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 2;
}
#pragma mark ---- collectionView 数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0) {
        return self.typeArray.count;
    }else if (section == 1) {
        return self.signArray.count;
    }
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.collectionView) {
        KG_CaseLibraryTypeSignCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KG_CaseLibraryTypeSignCell" forIndexPath:indexPath];
        if (indexPath.section == 0) {
            cell.str = self.typeArray[indexPath.row];
        }else {
            cell.str = self.signArray[indexPath.row];
        }
        
        
        return cell;
    }
    return nil;
    
    
}

#pragma mark  定义每个UICollectionViewCell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return  CGSizeMake((SCREEN_WIDTH-32)/3,30);
    
}

#pragma mark - collectionView代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
   
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0 || indexPath.section == 1) {
            KG_CaseLibraryTypeHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"KG_CaseLibraryTypeHeaderView" forIndexPath:indexPath];
            if (indexPath.section == 0) {
                headerView.titleLabel.text = @"适用型号";
                
            }else {
                headerView.titleLabel.text = @"设备标签";
            }
            return headerView;
        }
    }
    return nil;
}

@end
