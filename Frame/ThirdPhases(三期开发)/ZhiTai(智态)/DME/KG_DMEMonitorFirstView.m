//
//  KG_DMEMonitorFirstView.m
//  Frame
//
//  Created by zhangran on 2020/4/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_DMEMonitorFirstView.h"
#import "KG_MonitorCell.h"
@interface  KG_DMEMonitorFirstView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, assign) int pangluAlarmStatus;

@property (nonatomic, assign) int workAlarmStatus;
@end
@implementation KG_DMEMonitorFirstView


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
    NSArray *arr = [NSArray arrayWithObjects:@"旁路：关",@"工作",@"监视器1", nil];
    [self.dataArray addObjectsFromArray:arr];
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
    [self.tableView reloadData];

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



#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return   1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 26;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_MonitorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_MonitorCell"];
    if (cell == nil) {
        cell = [[KG_MonitorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_MonitorCell"];
    }
    NSString *titleString = self.dataArray[indexPath.section];
    
    if (indexPath.section == 0) {
        cell.titleLabel.text = safeString(titleString);
        if (self.pangluAlarmStatus == 1) {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#F11B3D"];//红色
        }else {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];//绿色
           
        }
     
    }
    
    if (indexPath.section == 1) {
        cell.titleLabel.text = safeString(titleString);
        if (self.workAlarmStatus == 1) {
           cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#F11B3D"];
            
        }else {
           cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
        }
    }

    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 2) {
        cell.titleLabel.text = safeString(titleString);
        if ([titleString containsString:@"监视器"] ) {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#0032AF"];
        }
    }
    
    
    
    
    
    return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    headView.backgroundColor = [UIColor whiteColor];
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
   
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}

- (void)setPangluDic:(NSDictionary *)pangluDic{
    _pangluDic = pangluDic;
    self.pangluAlarmStatus = [safeString(pangluDic[@"alarmStatus"]) intValue];
    NSString *pangluString = @"旁路：关";
    //监视器A
    if([safeString(pangluDic[@"valueAlias"]) isEqualToString:@"旁路都打开"]){
        pangluString = @"旁路：开";
        
    }else if([safeString(pangluDic[@"valueAlias"]) isEqualToString:@"旁路都关闭"]){
        
        pangluString = @"旁路：关";
    }else if([safeString(pangluDic[@"valueAlias"]) isEqualToString:@"A旁路"]){
        pangluString = @"旁路：开";
        
    }else if([safeString(pangluDic[@"valueAlias"]) isEqualToString:@"B旁路"]){
        pangluString = @"旁路：关";
        
    }
    
    if([safeString(pangluDic[@"valueAlias"]) containsString:@"告警"]) {
        pangluString = @"告警";
        
    }
    [_dataArray replaceObjectAtIndex:0 withObject:pangluString];
    [self.tableView reloadData];
}
- (void)setCheckDic:(NSDictionary *)checkDic{
    _checkDic = checkDic;
     self.workAlarmStatus = [safeString(checkDic[@"alarmStatus"]) intValue];
    NSString *checkString = @"工作";
    //监视器A
    if([safeString(checkDic[@"valueAlias"]) isEqualToString:@"监测1/2均告警"]){
        checkString = @"告警";
        
    }else if([safeString(checkDic[@"valueAlias"]) isEqualToString:@"监测2告警"]){
        
        checkString = @"工作";
    }else if([safeString(checkDic[@"valueAlias"]) isEqualToString:@"监测1告警"]){
        checkString = @"告警";
        
    }else if([safeString(checkDic[@"valueAlias"]) isEqualToString:@"监测1/2无告警"]){
        checkString = @"工作";
        
    }
    [_dataArray replaceObjectAtIndex:1 withObject:checkString];
    [self.tableView reloadData];
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

@end
