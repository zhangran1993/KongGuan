//
//  KG_XunShiSelTimeView.m
//  Frame
//
//  Created by zhangran on 2020/9/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CreateDayWeiHuSelTimeView.h"
#import "KG_XunShiSelTimeCell.h"
@interface KG_CreateDayWeiHuSelTimeView ()<UITableViewDelegate,UITableViewDataSource> {
    
}

@property (nonatomic,strong) UITableView *tableView;
@property (strong, nonatomic) UIView *toolView; // 工具条
@property (strong, nonatomic) UILabel *titleLbl; // 标题
@property(nonatomic , strong) UIButton *saveBtn; //完成按钮
@property(nonatomic , strong) UIButton *cancelBtn ; //取消按钮

@property(nonatomic , copy)  NSString *timeStr;
@end

@implementation KG_CreateDayWeiHuSelTimeView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setupDataSubviews];
    }
    return self;
}
//初始化数据
- (void)initData {
    self.backgroundColor = [UIColor whiteColor];
    self.toolView = [[UIView alloc] init];
    self.toolView.frame = CGRectMake(0, 0, self.frame.size.width, 44);
    self.toolView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self addSubview:self.toolView];
    
    self.saveBtn = [[UIButton alloc] init];
    self.saveBtn.frame = CGRectMake(self.frame.size.width - 50, 2, 40, 40);
    [self.saveBtn setTitle:@"完成" forState:UIControlStateNormal];
    [self.saveBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.saveBtn addTarget:self action:@selector(saveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:self.saveBtn];
    
    self.cancelBtn = [[UIButton alloc] init];
    self.cancelBtn.frame = CGRectMake(10, 2, 40, 40);
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn  setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.toolView addSubview:self.cancelBtn];
    
    self.titleLbl = [[UILabel alloc] init];
    self.titleLbl.frame = CGRectMake(60, 2, self.frame.size.width - 120, 40);
    self.titleLbl.textAlignment = NSTextAlignmentCenter;
    self.titleLbl.textColor = WYLGrayColor(34);
    [self.toolView addSubview:self.titleLbl];
}

//创建视图
-(void)setupDataSubviews {
    
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.toolView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
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
    KG_XunShiSelTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_XunShiSelTimeCell"];
    if (cell == nil) {
        cell = [[KG_XunShiSelTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_XunShiSelTimeCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *str = self.dataArray[indexPath.row];
    cell.selTimeStr = self.timeStr;
    cell.timeStr = str;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str = self.dataArray[indexPath.row];
    self.timeStr = str;
    [self.tableView reloadData];
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    
    [self.tableView reloadData];
}


#pragma mark - 点击方法
/// 保存按钮点击方法
- (void)saveBtnClick {
    NSLog(@"点击了保存");
    if (self.saveBlockMethod) {
        self.saveBlockMethod(self.timeStr);
    }
   
}
/// 取消按钮点击方法
- (void)cancelBtnClick {
    NSLog(@"点击了取消");
    if (self.cancelBlockMethod) {
        self.cancelBlockMethod();
    }
}
@end
