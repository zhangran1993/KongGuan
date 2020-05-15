//
//  KG_TransBottomView.m
//  Frame
//
//  Created by zhangran on 2020/4/10.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_TransBottomView.h"
#import "KG_TransBottomCell.h"
@interface  KG_TransBottomView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *dataArray;

                                                        
@end
@implementation KG_TransBottomView


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
    NSArray *arr = [NSArray arrayWithObjects:@"系统正常",@"-",@"通信", nil];
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
    
    KG_TransBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_TransBottomCell"];
    if (cell == nil) {
        cell = [[KG_TransBottomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_TransBottomCell"];
    }
    NSString *titleString = self.dataArray[indexPath.section];
    
    cell.titleLabel.text = safeString(titleString);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.titleLabel.text = safeString(titleString);
        if ([safeString(titleString) containsString:@"正常"]) {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#36C6A5"];
        }else {
            cell.bgView.backgroundColor = [UIColor colorWithHexString:@"#F11B3D"];
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

- (void)setBottomDic:(NSDictionary *)bottomDic {
    _bottomDic = bottomDic;
    
    NSString *checkString = @"系统正常";
    //监视器A
    if([safeString(bottomDic[@"valueAlias"]) isEqualToString:@"系统正常"]){
        checkString = @"系统正常";
        
    }else if([safeString(bottomDic[@"valueAlias"]) isEqualToString:@"系统维护"]){
        
        checkString = @"系统维护";
    }
    [_dataArray replaceObjectAtIndex:0 withObject:checkString];
    [self.tableView reloadData];
    
}
@end
