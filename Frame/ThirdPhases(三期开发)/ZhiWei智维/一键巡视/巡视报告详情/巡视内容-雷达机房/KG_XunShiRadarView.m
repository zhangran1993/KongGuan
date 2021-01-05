//
//  KG_XunShiRadarView.m
//  Frame
//
//  Created by zhangran on 2020/4/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiRadarView.h"
#import "KG_LiXingWeiHuCell.h"
#import "KG_RadarEnvCell.h"
@interface KG_XunShiRadarView ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSArray *dataArray;
@property (nonatomic ,strong) UILabel *topTitle;
@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,copy) NSString *seondString;
@end

@implementation KG_XunShiRadarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
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
    UIView *topView = [[UIView alloc]init];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@44);
    }];
    
    UIImageView *shuImage = [[UIImageView alloc]init];
    [topView addSubview:shuImage];
    shuImage.image = [UIImage imageNamed:@"shu_image"];
    [shuImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@3);
        make.height.equalTo(@15);
        make.left.equalTo(topView.mas_left).offset(16);
        make.centerY.equalTo(topView.mas_centerY);
    }];
    
    
    self.topTitle = [[UILabel alloc]init];
    [topView addSubview:self.topTitle];
    self.topTitle.text = @"巡视内容-雷达机房";
    [self.topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shuImage.mas_right).offset(13.5);
        make.centerY.equalTo(topView.mas_centerY);
        make.width.equalTo(@200);
       
    }];
    self.topTitle.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.topTitle.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.topTitle.font = [UIFont my_font:16];
    self.topTitle.numberOfLines = 1;
    self.topTitle.textAlignment = NSTextAlignmentLeft;
    
    
    UIView *lineView = [[UIView alloc]init];
    [topView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView.mas_left).offset(16);
        make.right.equalTo(topView.mas_right).offset(-16);
        make.height.equalTo(@1);
        make.bottom.equalTo(topView.mas_bottom);
    }];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_bottom);
        make.left.equalTo(topView.mas_left);
        make.right.equalTo(topView.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
   
        
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        
        _tableView.userInteractionEnabled = YES;
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
    
    return 1;
  
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return [self.detailModel.childrens count];
}
    

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KG_RadarEnvCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RadarEnvCell"];
    if (cell == nil) {
        cell = [[KG_RadarEnvCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RadarEnvCell"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
  
    cell.listArray = self.detailModel.childrens[indexPath.section][@"childrens"];
//    if(indexPath.row == 0) {
//        cell.leftIcon.hidden = NO;
//        cell.segmentedControl.hidden = YES;
//        cell.titleLabel.text = safeString(detailDic[@"title"]);
//        if (safeString(detailDic[@"title"]).length == 0) {
//            cell.titleLabel.text = safeString(detailDic[@"engineRoomName"]);
//        }
//    }else {
//        cell.leftIcon.hidden = YES;
//        NSDictionary *dic = detailDic[@"childrens"] [indexPath.row -1];
//        cell.titleLabel.text = safeString(dic[@"title"]);
//        if (safeString(dic[@"title"]).length == 0) {
//            cell.titleLabel.text = safeString(dic[@"measureTagName"]);
//        }
//    }
   
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    self.dataArray =  self.detailModel.childrens[indexPath.section][@"childrens"];
   
    NSInteger thirdHeight = 0;
    NSInteger fourthHeight = 0;
   
    
    
    NSArray *thirdArr = self.dataArray;
    thirdHeight = thirdArr.count *30;
    for (NSDictionary *detailArr in thirdArr) {
        NSArray *fourthArr = detailArr[@"childrens"];
        fourthHeight += fourthArr.count *40;
        for (NSDictionary *fifDic in fourthArr) {
            NSArray *fifArr = fifDic[@"childrens"];
            NSDictionary *sixDic = [fifArr firstObject];
            
            NSArray *sixArr = sixDic[@"childrens"];
            if (sixArr.count >0) {
                NSDictionary *sevenDic = [sixArr firstObject];
                if (isSafeDictionary(sevenDic[@"atcSpecialTag"])) {
                    NSDictionary *specDic = sevenDic[@"atcSpecialTag"];
                    if (safeString(specDic[@"specialTagCode"]).length >0) {
                        fourthHeight += 57;
                    }
                }
            }else {
                if (isSafeDictionary(sixDic[@"atcSpecialTag"])) {
                    NSDictionary *specDic = sixDic[@"atcSpecialTag"];
                    if (safeString(specDic[@"specialTagCode"]).length >0) {
                        fourthHeight += 57;
                    }
                }
            }

        }
    }
    
    
    NSLog(@"第5层高度：-----------%ld",(long)thirdHeight);
    NSLog(@"第6层高度：-----------%ld",(long)fourthHeight);
    return thirdHeight +fourthHeight;
}

//1层
- (void)setDetailModel:(taskDetail *)detailModel {
    _detailModel = detailModel;
    NSDictionary *dic = [detailModel.childrens firstObject];
    self.topTitle.text = safeString(dic[@"stationName"]) ;
    if (safeString(dic[@"stationName"]).length == 0) {
        self.topTitle.text = safeString(dic[@"engineRoomName"]) ;
       
    }
    if ([UserManager shareUserManager].isChangeTask) {
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,50)];
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(32, 3, SCREEN_WIDTH -64, 44)];
        [footView addSubview:button];
        [button setTitle:@"新增内容" forState:UIControlStateNormal];
        [button setBackgroundColor: [UIColor colorWithRed:151/255.0 green:173/255.0 blue:228/255.0 alpha:1.0]];
        button.layer.cornerRadius = 4;
        button.userInteractionEnabled = NO;
        [button setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        self.tableView.tableFooterView = footView;
        
    }
   
    [self.tableView reloadData];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headView.backgroundColor = [UIColor whiteColor];
  
    UIImageView *iconImage = [[UIImageView alloc]init];
    [headView addSubview:iconImage];
    
    iconImage.image = [UIImage imageNamed:@"device_envIcon"];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY);
        make.left.equalTo(headView.mas_left).offset(22);
        make.width.height.equalTo(@14);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
 
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:self.titleLabel];
    NSArray *arr = self.detailModel.childrens;
    NSDictionary *dataDic = arr[section];
  
    self.titleLabel.text = safeString(dataDic[@"title"]);
    
    
    [self.titleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY);
        make.left.equalTo(iconImage.mas_right).offset(8);
        make.height.equalTo(headView.mas_height);
        make.width.equalTo(@150);
    }];
    
    
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
  
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
    footView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    return footView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}

@end
