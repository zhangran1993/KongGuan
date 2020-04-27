//
//  KG_XunShiTopView.m
//  Frame
//
//  Created by zhangran on 2020/4/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiTopView.h"
#import "KG_XunShiTopCell.h"

@interface KG_XunShiTopView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) NSArray *dataArray;

@end

@implementation KG_XunShiTopView


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
    
    return   self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 26;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_XunShiTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_XunShiTopCell"];
    if (cell == nil) {
        cell = [[KG_XunShiTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_XunShiTopCell"];
    }
    NSString *titleString = self.dataArray[indexPath.row];
    
    cell.titleLabel.text = safeString(titleString);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *headTitle = [[UILabel alloc]initWithFrame:CGRectMake(22.5, 0, 200, 44)];
    [headView addSubview:headTitle];
    headTitle.text = @"荣成导航台定期巡视报告";
    headTitle.textAlignment = NSTextAlignmentLeft;
    headTitle.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    headTitle.textColor = [UIColor colorWithHexString:@"#24252A"];
    headTitle.numberOfLines = 1;
    
    UIImageView *stastusImage = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH - 50, 10, 50, 24)];
    stastusImage.image = [UIImage imageNamed:@"finish_icon"];
    [headView addSubview:stastusImage];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(16, 43, SCREEN_WIDTH -32, 1)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [headView addSubview:lineView];
    
    
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    UIButton *footBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/2, 44)];
    [footBtn setTitle:@"收起" forState:UIControlStateNormal];
    footBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [footBtn setTitleColor:[UIColor colorWithHexString:@"#1860B0"] forState:UIControlStateNormal];
    [footBtn addTarget:self action:@selector(zhankaiMethod:) forControlEvents:UIControlEventTouchUpInside];
    [footBtn setImage:[UIImage imageNamed:@"shouqi_icon"] forState:UIControlStateNormal];
    return footView;
}
//展开
- (void)zhankaiMethod:(UIButton *)button {
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 44;
}


@end
