//
//  KG_MonitorSecondView.m
//  Frame
//
//  Created by zhangran on 2020/4/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//
#import "KG_MonitorSecondView.h"
#import "KG_MonitorCell.h"
@interface  KG_MonitorSecondView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *dataArray;

                                                        
@end
@implementation KG_MonitorSecondView


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
    NSArray *arr = [NSArray arrayWithObjects:@"自身状态：正常",@"数据状态：正常",@"旁路：关",@"开启",@"监视器2", nil];
    
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
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001f;
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
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_MonitorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_MonitorCell"];
    if (cell == nil) {
        cell = [[KG_MonitorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_MonitorCell"];
    }
    NSString *titleString = self.dataArray[indexPath.section];
    
    cell.titleLabel.text = safeString(titleString);
    if (indexPath.section == 0) {
        if ([safeString(titleString) containsString:@"正常"]) {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
        }else {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#F11B3D"];
        }
    }
    if (indexPath.section == 1) {
        if ([safeString(titleString) containsString:@"正常"]) {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
        }else {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#F11B3D"];
        }
    }
    if (indexPath.section == 2) {
        if ([safeString(titleString) containsString:@"开"]) {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
        }else {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#F11B3D"];
        }
    }
    if (indexPath.section == 3) {
        if ([safeString(titleString) containsString:@"开启"]) {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
        }else {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#F11B3D"];
        }
    }
    if (indexPath.section == 4) {
        cell.titleLabel.text = safeString(titleString);
        if ([titleString containsString:@"监视器"] ) {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#0032AF"];
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}




- (void)setCheckDic:(NSDictionary *)checkDic{
    _checkDic = checkDic;
    
    NSString *checkString = @"自身状态：正常";
    //监视器A
    if([safeString(checkDic[@"valueAlias"]) isEqualToString:@"正常"]){
        checkString = @"自身状态：正常";
        
    }else if([safeString(checkDic[@"valueAlias"]) isEqualToString:@"故障"]){
        
        checkString = @"自身状态：故障";
    }
    [_dataArray replaceObjectAtIndex:0 withObject:checkString];
    [self.tableView reloadData];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSString *dataString = @"数据正常";
    //监视器A
    if([safeString(dataDic[@"valueAlias"]) isEqualToString:@"正常"]){
        dataString = @"数据正常";
        
    }else if([safeString(dataDic[@"valueAlias"]) isEqualToString:@"预警"]){
        
        dataString = @"数据预警";
    }else if([safeString(dataDic[@"valueAlias"]) isEqualToString:@"告警"]){
        dataString = @"数据告警";
    }
    
    [_dataArray replaceObjectAtIndex:1 withObject:dataString];
    [self.tableView reloadData];
}
- (void)setWorkDic:(NSDictionary *)workDic {
    _workDic = workDic;
    NSString *dataString = @"数据正常";
    //监视器A
    if([safeString(workDic[@"valueAlias"]) isEqualToString:@"工作"]){
        dataString = @"旁路：开";
        
    }else if([safeString(workDic[@"valueAlias"]) isEqualToString:@"维护"]){
        
        dataString = @"旁路：关";
    }else if([safeString(workDic[@"valueAlias"]) isEqualToString:@"监视器1旁路"]){
        dataString = @"旁路：关";
    }else if([safeString(workDic[@"valueAlias"]) isEqualToString:@"监视器2旁路"]){
        dataString = @"旁路：开";
    }
    
    [_dataArray replaceObjectAtIndex:2 withObject:dataString];
    [self.tableView reloadData];
}

- (void)setEquipStatusDic:(NSDictionary *)equipStatusDic {
    _equipStatusDic = equipStatusDic;
    
    NSString *dataString = @"开启";
    //监视器A
    if([safeString(equipStatusDic[@"valueAlias"]) isEqualToString:@"监视器2开"]){
        dataString = @"开启";
        
    }else if([safeString(equipStatusDic[@"valueAlias"]) isEqualToString:@"监视器2关"]){
        
        dataString = @"关闭";
    }
    
    [_dataArray replaceObjectAtIndex:3 withObject:dataString];
    [self.tableView reloadData];
}
@end
