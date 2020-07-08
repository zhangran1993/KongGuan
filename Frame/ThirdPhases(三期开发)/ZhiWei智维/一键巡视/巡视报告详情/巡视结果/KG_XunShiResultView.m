//
//  KG_XunShiResultView.m
//  Frame
//
//  Created by zhangran on 2020/4/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiResultView.h"

@interface KG_XunShiResultView ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic ,strong) UITableView      *tableView;
@property (nonatomic ,strong) NSMutableArray   *dataArray;

@end
@implementation KG_XunShiResultView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createView];
    }
        
    return  self;
}

- (void)createView {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@102);
    }];
    [self.tableView reloadData];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
    //    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.taskDescription.length == 0) {
//        cell.textLabel.text = @"一切情况正常";
        cell.textLabel.text = @"--";
    }else {
        cell.textLabel.text = safeString(self.taskDescription);
    }
    
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return  58.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *shuImage = [[UIImageView alloc]init];
    [headView addSubview:shuImage];
    shuImage.image = [UIImage imageNamed:@"shu_image"];
    [shuImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@3);
        make.height.equalTo(@15);
        make.left.equalTo(headView.mas_left).offset(16);
        make.centerY.equalTo(headView.mas_centerY);
    }];
    
    UILabel *headTitle = [[UILabel alloc]initWithFrame:CGRectMake(32.5, 0, 200, 44)];
    [headView addSubview:headTitle];
    headTitle.text = @"巡视结果";
    headTitle.textAlignment = NSTextAlignmentLeft;
    headTitle.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    headTitle.textColor = [UIColor colorWithHexString:@"#24252A"];
    headTitle.numberOfLines = 1;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(16, 43.5, SCREEN_WIDTH - 32, 0.5)];
    lineView.backgroundColor  = [UIColor colorWithHexString:@"#EFF0F7"];
    [headView addSubview:lineView];
    
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
- (void)setTaskDescription:(NSString *)taskDescription {
    _taskDescription = taskDescription;
    [self.tableView reloadData];
    
}

@end
