//
//  KG_DMETransFirstView.m
//  Frame
//
//  Created by zhangran on 2020/4/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_DMETransFirstView.h"
#import "KG_MonitorCell.h"
@interface  KG_DMETransFirstView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *dataArray;


@end
@implementation KG_DMETransFirstView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self setupDataSubviews];
        
    }
    return self;
}
//化数据
- (void)initData {
    NSArray *arr = [NSArray arrayWithObjects:@"正常",@"工作",@"发射机1", nil];
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
    
    return 1;
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
    
    cell.titleLabel.text = safeString(titleString);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 2) {
        if ([titleString isEqualToString:@"发射机1"]) {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#0032AF"];
            
        }else {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
        }
    }
    if (indexPath.section == 1) {
        
        if ([titleString isEqualToString:@"冷备"]) {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#B8BFCC"];
        }else {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
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

- (void)setWorkDic:(NSDictionary *)workDic{
    _workDic = workDic;
    
    NSString *workString = @"工作";
    //监视器A
    if([safeString(workDic[@"valueAlias"]) isEqualToString:@"A机"]){
        workString = @"工作";
        
    }else {
        if(safeString(workDic[@"valueAlias"]).length == 0){
            workString = @"工作";
            
        }else {
           
            if([safeString(self.rebeiDic[@"valueAlias"]) isEqualToString:@"冷备份"]){
                workString = @"冷备";
            }
        }
    }
    [_dataArray replaceObjectAtIndex:1 withObject:workString];
    [self.tableView reloadData];
    
}

- (void)setFasheDic:(NSDictionary *)fasheDic{
    _fasheDic = fasheDic;
    
    
    
    NSString *fasheString = @"正常";
    //监视器A
    if([safeString(fasheDic[@"valueAlias"]) isEqualToString:@"无告警"]){
        fasheString = @"正常";
        
    }else if([safeString(fasheDic[@"valueAlias"]) isEqualToString:@"A机告警"]){
        
        fasheString = @"正常";
    }else if([safeString(fasheDic[@"valueAlias"]) isEqualToString:@"B机告警"]){
        fasheString = @"告警";
        
    }else if([safeString(fasheDic[@"valueAlias"]) isEqualToString:@"全告警"]){
        fasheString = @"告警";
        
    }
    [_dataArray replaceObjectAtIndex:0 withObject:fasheString];
    [self.tableView reloadData];
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (void)setRebeiDic:(NSDictionary *)rebeiDic {
    _rebeiDic = rebeiDic;
}
@end
