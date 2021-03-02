//
//  KG_ZhiTaiBottomView.m
//  Frame
//
//  Created by zhangran on 2020/4/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ZhiTaiBottomNavigationView.h"
#import "KG_ZhiTaiBottomNavigationCell.h"
@interface  KG_ZhiTaiBottomNavigationView()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic, strong) UIButton         *bgBtn ;

@property (nonatomic, strong) UITableView      *tableView;

@property (nonatomic, strong) NSArray          *dataArray;

@property (nonatomic, strong) UIImageView      *headStatusImage;

@property (nonatomic, strong) UIImageView      *headTitleLabel;

@property (nonatomic, strong) UILabel          *headNumLabel;

@end

@implementation KG_ZhiTaiBottomNavigationView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setupDataSubviews];
        self.frame = frame;
        
    }
    return self;
}
//初始化数据
- (void)initData {
    //    self.dataArray = [NSArray arrayWithObjects:@"1",@"2",@"3", nil];
}
- (void)rightMethod {
    
    NSDictionary * Detail = @{
                               @"stationName":safeString(self.currDic[@"stationName"]) ,
                               @"machine_name":safeString(self.currDic[@"name"]),
                               @"name":safeString(self.currDic[@"name"]),
                               @"stationCode":safeString(self.currDic[@"stationCode"]),
                               @"code":safeString(self.currDic[@"code"]),
                               @"engineRoomCode":safeString(self.currDic[@"engineRoomCode"]),
                               @"category":safeString(self.currDic[@"category"]),
                               @"isSystemEquipment":[NSNumber numberWithBool:[self.currDic[@"isSystemEquipment"]boolValue]]
                               };
    if (self.clickToDetail) {
        self.clickToDetail(Detail);
    }
}
//创建视图
-(void)setupDataSubviews
{
    
    
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
   
}

// 背景按钮点击视图消失
- (void)buttonClickMethod :(UIButton *)btn {
    self.hidden = YES;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        
    }
    return _tableView;
}
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}



#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.dataArray.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_ZhiTaiBottomNavigationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_ZhiTaiBottomNavigationCell"];
    if (cell == nil) {
        cell = [[KG_ZhiTaiBottomNavigationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_ZhiTaiBottomNavigationCell"];
    }
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    
    cell.dataDic = dataDic;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50.f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
   
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [tableHeadView addSubview:titleLabel];
    titleLabel.text = safeString(self.titleString);
    if (safeString(self.titleString).length == 0) {
        titleLabel.text = @"";
    }
    titleLabel.numberOfLines = 1;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:16];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tableHeadView.mas_centerY);
        make.left.equalTo(tableHeadView.mas_left).offset(16);
        make.width.lessThanOrEqualTo(@250);
        
    }];
    NSDictionary *dataDic = self.dataArray[section];
       
    if([safeString(dataDic[@"category"]) isEqualToString:@"navigation"]) {
        
        titleLabel.text = @"导航设备";
    }else if([safeString(dataDic[@"category"]) isEqualToString:@"radar"]) {
        
        titleLabel.text = @"雷达设备";
    }else{
        titleLabel.text = @"设备";
    }
  
   
    UIImageView *lineImage = [[UIImageView alloc]init];
    lineImage.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [tableHeadView addSubview:lineImage];
    [lineImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableHeadView.mas_left).offset(16);
        make.right.equalTo(tableHeadView.mas_right).offset(-15);
        make.bottom.equalTo(tableHeadView.mas_bottom);
        make.height.equalTo(@1);
    }];
    
    return tableHeadView;
}

- (void)setCurrIndex:(int )currIndex {
    _currIndex = currIndex;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.currDic = self.dataArray[indexPath.row];
    
    NSDictionary * Detail = @{
        @"stationName":safeString(self.currDic[@"stationName"]) ,
        @"machine_name":safeString(self.currDic[@"name"]),
        @"name":safeString(self.currDic[@"name"]),
        @"stationCode":safeString(self.currDic[@"stationCode"]),
        @"code":safeString(self.currDic[@"code"]),
        @"engineRoomCode":safeString(self.currDic[@"engineRoomCode"]),
        @"category":safeString(self.currDic[@"category"]),
        @"isSystemEquipment":[NSNumber numberWithBool:[self.currDic[@"isSystemEquipment"]boolValue]]
    };
    if (self.clickToDetail) {
        self.clickToDetail(Detail);
    }
    
}


- (void)setSecArray:(NSArray *)secArray {
    _secArray = secArray;
    self.dataArray = secArray;
    if (self.dataArray.count) {
       [self.tableView reloadData];
    }
   
    
}
- (void)setTitleString:(NSString *)titleString {
    _titleString = titleString;
    [self.tableView reloadData];
}
- (void)setCurrDic:(NSDictionary *)currDic {
    _currDic = currDic;
}

- (NSString *)getLevelImage:(NSString *)level {
    NSString *levelString = @"level_normal";
    
    if ([level isEqualToString:@"0"]) {
        levelString = @"level_normal";
    }else if ([level isEqualToString:@"4"]) {
        levelString = @"level_prompt";
    }else if ([level isEqualToString:@"3"]) {
        levelString = @"level_ciyao";
    }else if ([level isEqualToString:@"2"]) {
        levelString = @"level_important";
    }else if ([level isEqualToString:@"1"]) {
        levelString = @"level_jinji";
    }
    
    //紧急
    return levelString;
}
@end
