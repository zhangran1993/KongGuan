//
//  KG_TransFirstView.m
//
//
//  Created by zhangran on 2020/4/10.
//

#import "KG_TransSecondView.h"
#import "KG_MonitorCell.h"
@interface  KG_TransSecondView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *dataArray;

                                                        
@end
@implementation KG_TransSecondView


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
    NSArray *arr = [NSArray arrayWithObjects:@"主机",@"正常工作",@"发射机2", nil];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_MonitorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_MonitorCell"];
    if (cell == nil) {
        cell = [[KG_MonitorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_MonitorCell"];
    }
    NSString *titleString = self.dataArray[indexPath.section];
    
    cell.titleLabel.text = safeString(titleString);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if(indexPath.section == 0) {
        cell.titleLabel.text = safeString(titleString);
        if ([safeString(titleString) containsString:@"关机"]) {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#F11B3D"];
        }else {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
            if ([safeString(titleString) containsString:@"主机"]) {
                cell.titleLabel.text = @"工作";
                cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
            }else if ([safeString(titleString) containsString:@"冷备"]) {
                cell.titleLabel.text = @"备机";
                cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#B8BFCC"];
            }
        }
        
    }
    if(indexPath.section == 1) {
        if ([safeString(titleString) containsString:@"工作"]) {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
        }else {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#B8BFCC"];
        }
        cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
        if ([safeString(titleString) containsString:@"主机"]) {
            cell.titleLabel.text = @"主机";
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
        }else if ([safeString(titleString) containsString:@"备机"]) {
            cell.titleLabel.text = @"备机";
            if ([self.hotDic[@"valueAlias"] isEqualToString:@"冷备份"]) {
                cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
            }else {
                cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#B8BFCC"];
            }
        }
    }
    if (indexPath.section == 2) {
        cell.titleLabel.text = safeString(titleString);
        if ([titleString containsString:@"发射机"] ) {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#0032AF"];
        }
    }
    return cell;
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


- (void)setWorkDic:(NSDictionary *)workDic {
    _workDic = workDic;
    NSString *pangluString = @"关机";
    //监视器A
    if([safeString(workDic[@"valueAlias"]) isEqualToString:@"关机"]){
        pangluString = @"关机";
        
    }else if([safeString(workDic[@"valueAlias"]) isEqualToString:@"B机"]){
        
        pangluString = @"主机";
    }else if([safeString(workDic[@"valueAlias"]) isEqualToString:@"A机"]){
        pangluString = @"备机";
        if([safeString(self.hotDic[@"valueAlias"]) isEqualToString:@"热备份"]){
            pangluString = @"热备";
            
        }else {
            pangluString = @"冷备";
        }
    }
    [_dataArray replaceObjectAtIndex:0 withObject:pangluString];
    [self.tableView reloadData];
}

- (void)setHotDic:(NSDictionary *)hotDic {
    _hotDic = hotDic;
    
    
}

-(void)setStatusDic:(NSDictionary *)statusDic {
    _statusDic = statusDic;
    NSString *pangluString = @"正常关闭";
    //监视器A
    if([safeString(statusDic[@"valueAlias"]) isEqualToString:@"发射机2正常关闭"]){
        pangluString = @"正常关闭";
        
    }else if([safeString(statusDic[@"valueAlias"]) isEqualToString:@"告警关闭"]){
        
        pangluString = @"告警关闭";
    }else if([safeString(statusDic[@"valueAlias"]) isEqualToString:@"未关闭"]){
        
        pangluString = @"正常工作";
    }
    [_dataArray replaceObjectAtIndex:1 withObject:pangluString];
    [self.tableView reloadData];
}
@end
