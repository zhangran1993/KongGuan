//
//  KG_ZhiTaiBottomView.m
//  Frame
//
//  Created by zhangran on 2020/4/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ZhiTaiBottomView.h"
#import "KG_ZhiTaiBottomCell.h"
@interface  KG_ZhiTaiBottomView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UIImageView *headStatusImage;
@property (nonatomic, strong) UIImageView *headTitleLabel;
@property (nonatomic, strong) UILabel    *headNumLabel;
@end
@implementation KG_ZhiTaiBottomView


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
        _tableView.scrollEnabled = YES;
        
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
    
    KG_ZhiTaiBottomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_ZhiTaiBottomCell"];
    if (cell == nil) {
        cell = [[KG_ZhiTaiBottomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_ZhiTaiBottomCell"];
    }
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    
    cell.dataDic = dataDic;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 54.f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54)];
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    [tableHeadView addSubview:iconImage];
    iconImage.image = [UIImage imageNamed:@"vhf_icon"];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.left.equalTo(tableHeadView.mas_left).offset(16);
        make.centerY.equalTo(tableHeadView.mas_centerY);
        
    }];
    
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
        make.left.equalTo(iconImage.mas_right).offset(2);
        make.width.lessThanOrEqualTo(@250);
        
    }];
    UIImageView *rightImage = [[UIImageView alloc]init];
    rightImage.image = [UIImage imageNamed:@"right_iconImage"];
    [tableHeadView addSubview:rightImage];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tableHeadView.mas_centerY);
        make.right.equalTo(tableHeadView.mas_right).offset(-9);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    
    self.headStatusImage = [[UIImageView alloc]init];
    self.headStatusImage.image = [UIImage imageNamed:@"level_prompt"];
    [tableHeadView addSubview:self.headStatusImage];
    [self.headStatusImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tableHeadView.mas_centerY);
        make.right.equalTo(rightImage.mas_left).offset(-1);
        make.width.equalTo(@32);
        make.height.equalTo(@17);
    }];
    
    self.headNumLabel = [[UILabel alloc]init];
    [tableHeadView addSubview:self.headNumLabel];
    self.headNumLabel.layer.cornerRadius = 5.f;
    self.headNumLabel.layer.masksToBounds = YES;
    self.headNumLabel.text = @"1";
    self.headNumLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.headNumLabel.font = [UIFont systemFontOfSize:10];
    self.headNumLabel.numberOfLines = 1;
    
    self.headNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.headNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headStatusImage.mas_right).offset(-5);
        make.bottom.equalTo(self.headStatusImage.mas_top).offset(5);
        make.width.equalTo(@10);
        make.height.equalTo(@10);
    }];
   
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


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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


@end
