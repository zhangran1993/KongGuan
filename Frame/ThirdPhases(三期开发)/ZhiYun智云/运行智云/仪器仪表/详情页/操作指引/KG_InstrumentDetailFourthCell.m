//
//  KG_InstrumentDetailFourthCell.m
//  Frame
//
//  Created by zhangran on 2020/9/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_InstrumentDetailFourthCell.h"
#import "KG_InstrumentDeatailContentFourCell.h"
#import "KG_InstrumentDetailContentFourthCell.h"
@interface KG_InstrumentDetailFourthCell ()<UITableViewDelegate,UITableViewDataSource>{
    
    
}
@property (nonatomic, strong)     UITableView        *tableView;

@property (nonatomic,strong)   UICollectionView      *collectionView;

@property (nonatomic, strong)     NSArray            *dataArray;

@property (nonatomic ,strong)     UIView             *centerView;

@property (nonatomic ,strong)     UIImageView        *iconImage;

@property (nonatomic ,strong)     UILabel            *titleLabel;

@property (nonatomic ,strong)     UIImageView        *shuImage;

@property (nonatomic ,strong)     UILabel            *leftLabel;

@property (nonatomic ,strong)     UILabel            *rightLabel;

@end
@implementation KG_InstrumentDetailFourthCell

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
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.centerView.layer.cornerRadius = 10.f;
    self.centerView.layer.masksToBounds = YES;
    self.centerView.layer.shadowOffset = CGSizeMake(0,2);
    self.centerView.layer.shadowOpacity = 1;
    self.centerView.layer.shadowRadius = 2;
    
    
    
    self.iconImage = [[UIImageView alloc]init];
    [self.centerView addSubview:self.iconImage];
    self.iconImage.image = [UIImage imageNamed:@"kg_device_jianjie"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(15);
        make.top.equalTo(self.centerView.mas_top).offset(14);
       
        make.width.height.equalTo(@18);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"操作指引";
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(7);
        make.width.equalTo(@120);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.height.equalTo(@45);
    }];
    
    
    
    
    
    
    UIImageView *changeImage = [[UIImageView alloc]init];
    [self.centerView addSubview:changeImage];
    changeImage.image = [UIImage imageNamed:@"kg_detailChange"];
    [changeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@12);
        make.right.equalTo(self.centerView.mas_right).offset(-16);
        make.centerY.equalTo(self.iconImage.mas_centerY);
    }];
    
    self.rightLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.rightLabel];
    self.rightLabel.textColor = [UIColor colorWithHexString:@"#004EC4"];
    self.rightLabel.font = [UIFont systemFontOfSize:14];
    self.rightLabel.textAlignment = NSTextAlignmentRight;
    [self.rightLabel sizeToFit];
    self.rightLabel.text = @"电台测试";
    self.rightLabel.numberOfLines = 1;
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(changeImage.mas_left).offset(-4);
        make.width.lessThanOrEqualTo(@80);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.height.equalTo(@45);
    }];
    
    UIButton *bgBtn = [[UIButton alloc]init];
    [self.centerView addSubview:bgBtn];
    [bgBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView.mas_right).offset(-16);
        make.width.equalTo(@150);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.height.equalTo(@45);
    }];
    
    [self.centerView addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_top).offset(48);
        make.left.equalTo(self.centerView.mas_left);
        make.right.equalTo(self.centerView.mas_right);
        make.bottom.equalTo(self.centerView.mas_bottom);
    }];
    //    [self initCollevtionView];
    
}

- (void)setDataModel:(KG_InstrumentationDetailModel *)dataModel {
    _dataModel = dataModel;
    
}


//将时间戳转换为时间字符串
- (NSString *)timestampToTimeStr:(NSString *)timestamp {
    if (isSafeObj(timestamp)==NO) {
        return @"-/-";
    }
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp.integerValue/1000];
    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd HH:mm:ss"] stringFromDate:date];
    //    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd"] stringFromDate:date];
    return timeStr;
    
}

- (NSDateFormatter *)dateFormatWith:(NSString *)formatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatStr];//@"YYYY-MM-dd HH:mm:ss"
    //设置时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    return formatter;
}

////初始化collectionview
//- (void)initCollevtionView{
//    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//    flowLayout.minimumLineSpacing = 0;
//    flowLayout.minimumInteritemSpacing = 0;
//
//    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
//    [self.centerView addSubview:self.collectionView];
//
//
//    [self.collectionView registerClass:[KG_InstrumentDetailContentFourthCell class] forCellWithReuseIdentifier:@"KG_InstrumentDetailContentFourthCell"];
//    self.collectionView.delegate = self;
//    self.collectionView.dataSource = self;
//    self.collectionView.showsVerticalScrollIndicator = NO;
//    self.collectionView.scrollEnabled = YES;
//    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
//    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.centerView.mas_top).offset(48);
//        make.left.equalTo(self.centerView.mas_left);
//        make.right.equalTo(self.centerView.mas_right);
//        make.bottom.equalTo(self.centerView.mas_bottom);
//    }];
//}
//#pragma mark ---- collectionView 数据源方法
//-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
//    return self.dataArray.count;
//}
//
//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    if (collectionView == self.collectionView) {
//        KG_InstrumentDetailContentFourthCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KG_InstrumentDetailContentFourthCell" forIndexPath:indexPath];
//        cell.dataDic = self.dataArray[indexPath.row];
//
//        return cell;
//    }
//    return nil;
//
//
//}
//
//#pragma mark  定义每个UICollectionViewCell的大小
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    return  CGSizeMake(SCREEN_WIDTH -32,343-48);
//
//}
//
//#pragma mark - collectionView代理方法
//-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//
//    NSLog(@"%ld",(long)indexPath.row);
//
//}

- (void)buttonClick:(UIButton *)btn {
    if (self.selGudieListBlock) {
        self.selGudieListBlock();
    }
    
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
    }
    return _tableView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-32, 0.001)];
    headView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-32, 10)];
    footView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    return footView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_InstrumentDeatailContentFourCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_InstrumentDeatailContentFourCell"];
    if (cell == nil) {
        cell = [[KG_InstrumentDeatailContentFourCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_InstrumentDeatailContentFourCell"];
    }
    NSDictionary *dataDic = self.dataArray[indexPath.section];
    cell.dataDic = dataDic;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dataDic = self.dataArray[indexPath.section];
    if (self.pushToDetailBlock) {
        self.pushToDetailBlock(dataDic);
    }
}

- (void)setListArray:(NSArray *)listArray {
    _listArray = listArray;
    
    self.dataArray = listArray;
    [self.tableView reloadData];
    
}
- (void)setGuideTypeStr:(NSString *)guideTypeStr {
    _guideTypeStr = guideTypeStr;
    
}

- (void)setGuideNameStr:(NSString *)guideNameStr {
    _guideNameStr = guideNameStr;
    self.rightLabel.text = safeString(guideNameStr);
    
}
@end
