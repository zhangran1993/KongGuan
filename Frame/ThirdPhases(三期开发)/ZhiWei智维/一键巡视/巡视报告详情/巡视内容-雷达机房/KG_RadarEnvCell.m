//
//  KG_RadarEnvCell.m
//  Frame
//
//  Created by zhangran on 2020/4/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RadarEnvCell.h"
#import "KG_XunShiLastDetailCell.h"
@interface KG_RadarEnvCell ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSArray *dataArray;
@property (nonatomic ,assign) NSInteger  currIndex;
@property (nonatomic ,assign) NSInteger  currSection;
@end

@implementation KG_RadarEnvCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        
        [self createUI];
    }
    
    return self;
}



- (void)createUI{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
//    
//    
//    self.leftIcon = [[UIImageView alloc]init];
//    [self addSubview:self.leftIcon];
//    self.leftIcon.layer.cornerRadius = 2.5f;
//    self.leftIcon.hidden = YES;
//    self.leftIcon.layer.masksToBounds = YES;
//    self.leftIcon.backgroundColor = [UIColor colorWithHexString:@"#BABCC4"];
//    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.mas_centerY);
//        make.left.equalTo(self.mas_left).offset(36);
//        make.width.height.equalTo(@5);
//    }];
//
//    
//    self.titleLabel = [[UILabel alloc]init];
//    [self addSubview:self.titleLabel];
//    [self.titleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.mas_centerY);
//        make.left.equalTo(self.leftIcon.mas_right).offset(8);
//        make.height.equalTo(self.mas_height);
//        make.width.equalTo(@150);
//    }];
//
//    self.tempLabel = [[UILabel alloc]init];
//    [self addSubview:self.tempLabel];
//    self.tempLabel.text = @"18℃";
//    self.tempLabel.textColor = [UIColor colorWithHexString:@"#626470"];
//    self.tempLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
//    self.tempLabel.numberOfLines = 1;
//    self.tempLabel.textAlignment = NSTextAlignmentRight;
//  
//    self.zhexianIcon = [[UIImageView alloc]init];
//    [self addSubview:self.zhexianIcon];
//    self.zhexianIcon.image = [UIImage imageNamed:@"zhexian_image"];
//    
//    
//    self.starIcon = [[UIImageView alloc]init];
//    [self addSubview:self.starIcon];
//    self.starIcon.image = [UIImage imageNamed:@"gray_starImage"];
//    [self.starIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.mas_centerY);
//        make.right.equalTo(self.mas_right).offset(-33.5);
//        make.height.equalTo(@12);
//        make.width.equalTo(@12);
//    }];
//    
//    [self.zhexianIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.mas_centerY);
//        make.right.equalTo(self.starIcon.mas_right).offset(-14);
//        make.height.equalTo(@14);
//        make.width.equalTo(@14);
//    }];
//    [self.tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.zhexianIcon.mas_left).offset(-14);
//        make.height.equalTo(@15);
//        make.centerY.equalTo(self.mas_centerY);
//        make.width.lessThanOrEqualTo(@100);
//      }];
//      
//
////    @property (nonatomic, strong) UIView *detailView;
////    @property (nonatomic, strong) UILabel *detailTitleLabel;
////    @property (nonatomic, strong) UILabel *detailTxtLabel;
////
//    if (0) {
//        
//   
//    self.detailView = [[UIView alloc]init];
//    [self addSubview:self.detailView];
//    self.detailView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
//    [self.detailView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.mas_centerY);
//        make.left.equalTo(self.mas_left).offset(50);
//        make.right.equalTo(self.mas_right).offset(-32);
//        make.height.equalTo(@57);
//    }];
//    self.detailTitleLabel = [[UILabel alloc]init];
//    [self.detailView addSubview:self.detailTitleLabel];
//    self.detailTitleLabel.text = @"A相输入电压特殊参数标记";
//    self.detailTitleLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
//    self.detailTitleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
//    self.detailTitleLabel.numberOfLines = 1;
//    self.detailTitleLabel.textAlignment = NSTextAlignmentLeft;
//    [self.detailTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.detailView.mas_top).offset(10);
//        make.left.equalTo(self.detailView.mas_left).offset(9.5);
//        make.right.equalTo(self.detailView.mas_right).offset(-20);
//        make.height.equalTo(@12);
//    }];
//    
//    self.detailTextTitleLabel = [[UILabel alloc]init];
//    [self.detailView addSubview:self.detailTextTitleLabel];
//    self.detailTextTitleLabel.text = @"电压过高";
//    self.detailTextTitleLabel.textColor = [UIColor colorWithHexString:@"#FFB428"];
//    self.detailTextTitleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
//    self.detailTextTitleLabel.numberOfLines = 1;
//    self.detailTextTitleLabel.textAlignment = NSTextAlignmentLeft;
//    [self.detailTextTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.detailTitleLabel.mas_bottom).offset(9.5);
//        make.left.equalTo(self.detailView.mas_left).offset(9.5);
//        make.right.equalTo(self.detailView.mas_right).offset(-20);
//        make.height.equalTo(@12);
//    }];
//     }
//    NSArray *array = [NSArray arrayWithObjects:@"正常",@"不正常", nil];
//    self.segmentedControl = [[UISegmentedControl alloc]initWithItems:array];
//    self.segmentedControl.frame = CGRectMake(SCREEN_WIDTH - 32 -84, 8,84,24);
//   
//    
//    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#FFFFFF"]}forState:UIControlStateSelected];
//    
//    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#2F5ED1"],NSFontAttributeName:[UIFont boldSystemFontOfSize:12.0f]}forState:UIControlStateNormal];
//    [self addSubview:self.segmentedControl];
//    self.segmentedControl.selectedSegmentIndex = 0;
//    self.segmentedControl.tintColor = [UIColor redColor];
//    self.segmentedControl.layer.borderWidth = 1;                   //    边框宽度，重新画边框，若不重新画，可能会出现圆角处无边框的情况
//    self.segmentedControl.layer.borderColor = [UIColor colorWithHexString:@"#2F5ED1"].CGColor; //     边框颜色
//    [self.segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]]
//                                forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    
//    [self.segmentedControl setBackgroundImage:[self createImageWithColor:[UIColor colorWithHexString:@"#2F5ED1"]]
//                                forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
//    
//    [self.segmentedControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.mas_right).offset(-32);
//        make.centerY.equalTo(self.mas_centerY);
//        make.width.equalTo(@84);
//        make.height.equalTo(@24);
//    }];
    
    
}

- (UIImage*)createImageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
       
    }
    return _tableView;
}
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = self.listArray[section];
    NSArray *arr = dic[@"childrens"];
    return arr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return self.listArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KG_XunShiLastDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_XunShiLastDetailCell"];
    if (cell == nil) {
        cell = [[KG_XunShiLastDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_XunShiLastDetailCell"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    self.currIndex = indexPath.row;
    self.currSection = indexPath.section;
    cell.specialData = ^(NSDictionary * _Nonnull dataDic) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];

        [dic setValue:safeString(dataDic[@"description"]) forKey:@"description"];
        [dic setValue:safeString(dataDic[@"specialTagName"]) forKey:@"specialTagName"];
        [dic setValue:safeString(dataDic[@"specialTagValue"]) forKey:@"specialTagValue"];
        [dic setValue:safeString(dataDic[@"patrolRecordId"]) forKey:@"patrolRecordId"];

        [dic setValue:safeString(dataDic[@"engineRoomCode"]) forKey:@"engineRoomCode"];
        [dic setValue:safeString(dataDic[@"engineRoomName"]) forKey:@"engineRoomName"];
      
        NSDictionary *currDic = self.listArray[self.currSection];
        [dic setValue:safeString(currDic[@"equipmentCode"]) forKey:@"equipmentCode"];
        [dic setValue:safeString(currDic[@"equipmentName"]) forKey:@"equipmentName"];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"saveSpecialData"
          object:self
        userInfo:dic];
    };
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.listArray[indexPath.section];
    if(dic.count) {
        NSArray *arr = dic[@"childrens"];
        if (arr.count) {
            NSDictionary *detailDic = arr[indexPath.row];
            cell.dataDic = detailDic;
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dic = self.listArray[indexPath.section];
    NSArray *arr = dic[@"childrens"];
    NSDictionary *detailDic = arr[indexPath.row];
    
    NSDictionary *dd = nil;
    NSArray *arr1 = detailDic[@"childrens"];
    if (arr1.count >0) {
        dd = [arr1 firstObject];
    }
    NSArray *sixArr = dd[@"childrens"];
    if (sixArr.count >0) {
        NSDictionary *sevenDic = [sixArr firstObject];
        if (isSafeDictionary(sevenDic[@"atcSpecialTag"])) {
            NSDictionary *atcDic = sevenDic[@"atcSpecialTag"];
            if (safeString(atcDic[@"specialTagCode"]).length >0) {
                return  40 + 57;
            }
        }
    }else {
        if (isSafeDictionary(dd[@"atcSpecialTag"])) {
            NSDictionary *atcDic = dd[@"atcSpecialTag"];
            if (safeString(atcDic[@"specialTagCode"]).length >0) {
                return  40 + 57;
            }
        }
    }
    
    
   
    return  40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headView.backgroundColor = [UIColor whiteColor];
  
    UIImageView *iconImage = [[UIImageView alloc]init];
    [headView addSubview:iconImage];
    iconImage.layer.cornerRadius = 2.5f;
   
    iconImage.layer.masksToBounds = YES;
    iconImage.backgroundColor = [UIColor colorWithHexString:@"#BABCC4"];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY);
        make.left.equalTo(headView.mas_left).offset(36);
        make.width.height.equalTo(@5);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
 
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:self.titleLabel];
    NSDictionary *dic = self.listArray[section];
    self.titleLabel.text = safeString(dic[@"equipmentName"]);
    if (safeString(dic[@"equipmentName"]).length == 0) {
        self.titleLabel.text = safeString(dic[@"title"]);
    }
    
    [self.titleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY);
        make.left.equalTo(iconImage.mas_right).offset(8);
        make.height.equalTo(headView.mas_height);
        make.width.equalTo(@150);
    }];
    
    
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
   
    return footView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    
   
    return 30.f;
}
- (void)setSecondString:(NSString *)secondString {
    _secondString = secondString;
}
- (void)setDataDic:(NSDictionary *)dataDic {
   
    _dataDic = dataDic;
    self.dataArray = dataDic[@"childrens"];
    
    
}
- (void)setRowCount:(NSInteger)rowCount {
    _rowCount = rowCount;
}

- (void)setListArray:(NSArray *)listArray {
    _listArray = listArray;
    [self.tableView reloadData];
}
@end
