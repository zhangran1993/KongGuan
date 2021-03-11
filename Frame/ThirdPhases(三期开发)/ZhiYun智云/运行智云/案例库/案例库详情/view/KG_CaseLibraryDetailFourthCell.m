//
//  KG_CaseLibraryDetailFirstCell.m
//  Frame
//
//  Created by zhangran on 2020/10/15.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CaseLibraryDetailFourthCell.h"
#import "KG_CaseLibraryResultMethodCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_CaseLibraryDetailFourthCell ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    
}

@property (nonatomic ,strong)     UIView           *centerView;

@property (nonatomic, strong)     NSArray          *dataArray;

@property (nonatomic ,strong)     UILabel          *titleLabel;

@property (nonatomic ,strong)     UILabel          *rightNumLabel;

@property (nonatomic ,strong)     UILabel          *rightTotalNumLabel;

@property (nonatomic ,strong)     UIImageView      *iconImage;

@property (nonatomic,strong)      UICollectionView *collectionView;

@end

@implementation KG_CaseLibraryDetailFourthCell

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
        self.contentView.backgroundColor = self.backgroundColor;
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
        make.height.equalTo(@314);
    }];
    self.centerView.layer.cornerRadius = 10.f;
    self.centerView.layer.masksToBounds = YES;
//    self.centerView.layer.shadowOffset = CGSizeMake(0,2);
//    self.centerView.layer.shadowOpacity = 1;
//    self.centerView.layer.shadowRadius = 2;
    
    self.iconImage = [[UIImageView alloc]init];
    [self.centerView addSubview:self.iconImage];
    self.iconImage.image = [UIImage imageNamed:@"kg_anliku_deal"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(15);
        make.top.equalTo(self.centerView.mas_top).offset(14);
        make.width.height.equalTo(@18);
    }];
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.titleLabel.font = [UIFont my_font:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"处理办法";
    self.titleLabel.numberOfLines = 1;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(7);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    self.rightTotalNumLabel = [[UILabel alloc]init];
    self.rightTotalNumLabel.textColor = [UIColor colorWithHexString:@"#AFB2BD"];
    self.rightTotalNumLabel.text = @"/4";
    self.rightTotalNumLabel.font = [UIFont systemFontOfSize:14];
    self.rightTotalNumLabel.font = [UIFont my_font:14];
    [self.centerView addSubview:self.rightTotalNumLabel];
    self.rightTotalNumLabel.textAlignment = NSTextAlignmentRight;
    [self.rightTotalNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView.mas_right).offset(-15);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    
    
    self.rightNumLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.rightNumLabel];
    self.rightNumLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.rightNumLabel.text = @"2";
    [self.rightNumLabel sizeToFit];
    self.rightNumLabel.font = [UIFont systemFontOfSize:14];
    self.rightNumLabel.font = [UIFont my_font:14];
    self.rightNumLabel.textAlignment = NSTextAlignmentRight;
    [self.rightNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.rightTotalNumLabel.mas_left);
        make.centerY.equalTo(self.rightTotalNumLabel.mas_centerY);
        make.height.equalTo(@20);
    }];
    
    [self initCollevtionView];
}


//初始化collectionview
- (void)initCollevtionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 28;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    [self.centerView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.left.equalTo(self.centerView.mas_left);
        make.right.equalTo(self.centerView.mas_right);
        make.bottom.equalTo(self.centerView.mas_bottom);
    }];
    self.collectionView.layer.cornerRadius = 10.f;
    self.collectionView.layer.masksToBounds = YES;
    [self.collectionView registerClass:[KG_CaseLibraryResultMethodCell class] forCellWithReuseIdentifier:@"KG_CaseLibraryResultMethodCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollEnabled = YES;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    
    
}
#pragma mark ---- collectionView 数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.collectionView) {
        KG_CaseLibraryResultMethodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KG_CaseLibraryResultMethodCell" forIndexPath:indexPath];
        cell.dataDic = self.dataArray[indexPath.row];
        
        return cell;
    }
    return nil;
    
    
}

#pragma mark  定义每个UICollectionViewCell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return  CGSizeMake(SCREEN_WIDTH -32,270);
    
}

#pragma mark - collectionView代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",(long)indexPath.row);
    
}

//设置数据源模式
- (void)setDataModel:(KG_CaseLibraryDetailModel *)dataModel {
    _dataModel = dataModel;
    self.dataArray = self.dataModel.handleMethodList;
    [self.collectionView reloadData];
    self.rightNumLabel.text = safeString(@"1");
    self.rightTotalNumLabel.text = [NSString stringWithFormat:@"/%lu",(unsigned long)self.dataArray.count];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat pageWidth = SCREEN_WIDTH -32;
    //计算总共页面数量
    int page = floor((self.collectionView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.rightNumLabel.text = [NSString stringWithFormat:@"%d",page+1];
}

@end
