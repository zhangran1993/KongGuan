//
//  KG_ContactTopView.m
//  Frame
//
//  Created by zhangran on 2020/8/31.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ContactTopSecondView.h"
#import "KG_ContactTopCell.h"
@interface KG_ContactTopSecondView ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic,strong) UITableView      *tableView;

@property (nonatomic,strong) NSArray          *dataArray;

@property (nonatomic,strong) UILabel          *secLabel;

@end

@implementation KG_ContactTopSecondView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self setupDataSubviews];
        
    }
    return self;
}

//创建视图
-(void)setupDataSubviews
{
    UIView *searchView = [[UIView alloc]init];
    [self addSubview:searchView];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.height.equalTo(@40);
    }];
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F5F6F8"];
    searchView.layer.cornerRadius = 20.f;
    searchView.layer.masksToBounds = YES;
    
    UIImageView *searchIcon = [[UIImageView alloc]init];
    [searchView addSubview:searchIcon];
    searchIcon.image = [UIImage imageNamed:@"kg_search"];
    [searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.left.equalTo(searchView.mas_left).offset(16);
        make.centerY.equalTo(searchView.mas_centerY);
    }];
    
    UITextField *textField = [[UITextField alloc]init];
    [searchView addSubview:textField];
    textField.placeholder = @"搜索";
    textField.textColor = [UIColor colorWithHexString:@""];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchIcon.mas_right).offset(9);
        make.right.equalTo(searchView.mas_right).offset(-20);
        make.height.equalTo(searchView.mas_height);
        make.centerY.equalTo(searchView.mas_centerY);
    }];
    UIButton *searchBtn = [[UIButton alloc]init];
    [searchView addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [searchBtn setTitle:@"" forState:UIControlStateNormal];
    
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchIcon.mas_right).offset(9);
        make.right.equalTo(searchView.mas_right).offset(-20);
        make.height.equalTo(searchView.mas_height);
        make.centerY.equalTo(searchView.mas_centerY);
    }];
    
    
    
    
    [self addSubview:self.tableView];
   
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(searchView.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 56)];
    
    UILabel *leftLabel = [[UILabel alloc]init];
    [headView addSubview:leftLabel];
    leftLabel.text = @"联系人";
    leftLabel.textColor = [UIColor colorWithHexString:@"#004EC4"];
    leftLabel.font = [UIFont systemFontOfSize:14];
    leftLabel.textAlignment = NSTextAlignmentLeft;
    [leftLabel sizeToFit];
    [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(16);
        make.height.equalTo(@20);
        make.top.equalTo(headView.mas_top).offset(13);
        
    }];
    
    
    UIImageView *leftIcon = [[UIImageView alloc]init];
    leftIcon.image = [UIImage imageNamed:@"kg_smallSlider"];
    [headView addSubview:leftIcon];
    [leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@14);
        make.left.equalTo(leftLabel.mas_right);
        make.centerY.equalTo(leftLabel.mas_centerY);
    }];
    
    self.secLabel = [[UILabel alloc]init];
    [headView addSubview:self.secLabel];
    self.secLabel.text = @"技术保障部";
    self.secLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    self.secLabel.font = [UIFont systemFontOfSize:14];
    self.secLabel.textAlignment = NSTextAlignmentLeft;
    [self.secLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftIcon.mas_right);
        make.width.equalTo(@150);
        make.height.equalTo(@20);
        make.centerY.equalTo(leftLabel.mas_centerY);
        
    }];
    
    UIView *botView = [[UIView alloc]init];
    [headView addSubview:botView];
    botView.backgroundColor= [UIColor colorWithHexString:@"#F6F7F9"];
    [botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
        make.left.equalTo(headView.mas_left);
        make.right.equalTo(headView.mas_right);
        make.bottom.equalTo(headView.mas_bottom);
    }];
    
    
    
    self.tableView.tableHeaderView = headView;
    
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
    KG_ContactTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_ContactTopCell"];
    if (cell == nil) {
        cell = [[KG_ContactTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_ContactTopCell"];
    }
    secorgInfo *info = self.dataArray[indexPath.row];
    
    cell.titleLabel.text = [NSString stringWithFormat:@"%@(%@)",safeString(info.orgName),safeString(info.userSize)];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.pushToNextPage) {
        self.pushToNextPage(indexPath.section,indexPath.row);
    }
}

-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    
    [textField resignFirstResponder];
   
    NSLog(@"点击了搜索");
    return YES;
    
}

- (void)setModel:(KG_AddressbookSecondModel *)model {
    _model = model;
    
    self.dataArray = model.orgInfo;
    [self.tableView reloadData];
}

- (void)setSecTitle:(NSString *)secTitle {
    _secTitle = secTitle;
    
    self.secLabel.text = safeString(secTitle);
}
//搜索方法
- (void)searchButtonClick {
    
    if (self.searchMethod) {
        self.searchMethod();
    }
}
@end
