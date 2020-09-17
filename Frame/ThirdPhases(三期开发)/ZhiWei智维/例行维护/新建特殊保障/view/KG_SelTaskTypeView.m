//
//  KG_SelTaskTypeView.m
//  Frame
//
//  Created by zhangran on 2020/9/4.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_SelTaskTypeView.h"

@interface KG_SelTaskTypeView ()<UITableViewDelegate,UITableViewDataSource>{
    
    
    
    
}
@property (nonatomic, strong)  UITableView        *tableView;

@property (nonatomic, strong)  NSMutableArray     *dataArray;

@property (nonatomic, strong)  UIButton           *bgBtn ;

@property (nonatomic, strong)  UIView             *centerView;


@end

@implementation KG_SelTaskTypeView

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
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"天气巡视" forKey:@"name"];
    [dic setValue:@"weatherInspection" forKey:@"code"];
    [self.dataArray addObject:dic];
    
    NSMutableDictionary *dic1 = [NSMutableDictionary dictionary];
    [dic1 setValue:@"雷达后巡视" forKey:@"name"];
    [dic1 setValue:@"radarAfter" forKey:@"code"];
    [self.dataArray addObject:dic1];
    
    NSMutableDictionary *dic2 = [NSMutableDictionary dictionary];
    [dic2 setValue:@"雷达前巡视" forKey:@"name"];
    [dic2 setValue:@"radarBefore" forKey:@"code"];
    [self.dataArray addObject:dic2];
    
    
    NSMutableDictionary *dic3 = [NSMutableDictionary dictionary];
    [dic3 setValue:@"飞行校飞维护" forKey:@"name"];
    [dic3 setValue:@"fligtSafeguard" forKey:@"code"];
    [self.dataArray addObject:dic3];
    
    
    NSMutableDictionary *dic4 = [NSMutableDictionary dictionary];
    [dic4 setValue:@"停机维护" forKey:@"name"];
    [dic4 setValue:@"stopSafeguard" forKey:@"code"];
    [self.dataArray addObject:dic4];
    
    
    
}

//创建视图
-(void)setupDataSubviews
{
    //按钮背景 点击消失
    self.bgBtn = [[UIButton alloc]init];
    [self addSubview:self.bgBtn];
    [self.bgBtn setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    self.bgBtn.alpha = 0.46;
    [self.bgBtn addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.centerView = [[UIView alloc] init];
    self.centerView.frame = CGRectMake(52.5,209,270,242);
    self.centerView.backgroundColor = [UIColor whiteColor];
    self.centerView.layer.cornerRadius = 12;
    self.centerView.layer.masksToBounds = YES;
    [self addSubview:self.centerView];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.mas_centerY);
        make.centerX.equalTo(self.mas_centerX);
        make.height.equalTo(@234);
        make.width.equalTo(@270);
    }];
    self.centerView.layer.cornerRadius = 12;
    self.centerView.layer.masksToBounds = YES;
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:titleLabel];
    
    titleLabel.text = @"选择任务类型";
    titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#030303"];
    titleLabel.numberOfLines = 1;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerView.mas_centerX);
        make.top.equalTo(self.centerView.mas_top);
        make.width.equalTo(@270);
        make.height.equalTo(@58);
    }];
    
    
    
    [self addSubview:self.tableView];
   
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_top).offset(58);
        make.left.equalTo(self.centerView.mas_left);
        make.right.equalTo(self.centerView.mas_right);
        make.bottom.equalTo(self.centerView.mas_bottom);
    }];
    [self.tableView reloadData];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = safeString(dic[@"name"]);
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#2F5ED1"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = self.dataArray[indexPath.row];
    if(self.didSelBlock) {
        self.didSelBlock(dic);
    }
    self.hidden = YES;
}

- (void)buttonClickMethod:(UIButton *)btn {
    self.hidden = YES;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}
@end
