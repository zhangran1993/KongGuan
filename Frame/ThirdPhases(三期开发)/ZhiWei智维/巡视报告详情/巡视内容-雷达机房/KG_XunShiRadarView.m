//
//  KG_XunShiRadarView.m
//  Frame
//
//  Created by zhangran on 2020/4/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiRadarView.h"
#import "KG_LiXingWeiHuCell.h"
@interface KG_XunShiRadarView ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;


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
    self.dataArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
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
    
    
    UILabel *topTitle = [[UILabel alloc]init];
    [topView addSubview:topTitle];
    topTitle.text = @"巡视内容-雷达机房";
    [topTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shuImage.mas_right).offset(13.5);
        make.centerY.equalTo(topView.mas_centerY);
        make.width.equalTo(@200);
       
    }];
    topTitle.textColor = [UIColor colorWithHexString:@"#24252A"];
    topTitle.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    topTitle.numberOfLines = 1;
    topTitle.textAlignment = NSTextAlignmentLeft;
    
    
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
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
        _tableView.tableHeaderView = headView;
        headView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    }
    return _tableView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
    
    //    return self.dataArray.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KG_LiXingWeiHuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_LiXingWeiHuCell"];
    if (cell == nil) {
        cell = [[KG_LiXingWeiHuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_LiXingWeiHuCell"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    }
    //环境情况
    if(indexPath.section == 0) {
        
        
    }
    //设备情况
    if (indexPath.section == 1) {
        
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        return 92;
    }
    return  118;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(22, 15, 14, 14)];
    iconImage.image = [UIImage imageNamed:@"device_envIcon"];
    [headView addSubview:iconImage];
    
    UILabel *headTitle = [[UILabel alloc]initWithFrame:CGRectMake(48.5, 0, 200, 44)];
    [headView addSubview:headTitle];
    headTitle.text = @"环境情况";
    headTitle.textAlignment = NSTextAlignmentLeft;
    headTitle.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    headTitle.textColor = [UIColor colorWithHexString:@"#24252A"];
    headTitle.numberOfLines = 1;
    if (section == 0) {
        iconImage.image = [UIImage imageNamed:@"device_envIcon"];
        headTitle.text = @"环境情况";
    }else if(section == 1){
        iconImage.image = [UIImage imageNamed:@"device_equip"];
        headTitle.text = @"设备情况";
 
    }
    
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
   
    return footView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44.f;
}

@end
