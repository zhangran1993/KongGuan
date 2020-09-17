//
//  KG_ContactTopView.m
//  Frame
//
//  Created by zhangran on 2020/8/31.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_ContactTopView.h"
#import "KG_ContactTopCell.h"
@interface KG_ContactTopView ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    
}

@property (nonatomic,strong) UITableView      *tableView;

@property (nonatomic,strong) NSArray          *dataArray;

@end

@implementation KG_ContactTopView

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
    textField.delegate = self;
    textField.placeholder = @"搜索";
    textField.returnKeyType = UIReturnKeySearch;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 72)];
    
    UIImageView *leftIcon = [[UIImageView alloc]init];
    leftIcon.image = [UIImage imageNamed:@"kg_logo"];
    [headView addSubview:leftIcon];
    [leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@38);
        make.left.equalTo(headView.mas_left).offset(16);
        make.centerY.equalTo(headView.mas_centerY);
    }];
    orgInfo *info = self.dataArray[section];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [headView addSubview:titleLabel];
    titleLabel.text = safeString(info.orgName);
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftIcon.mas_right).offset(6);
        make.right.equalTo(headView.mas_right).offset(-20);
        make.height.equalTo(headView.mas_height);
        make.centerY.equalTo(headView.mas_centerY);
        
    }];
    return headView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 72;
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
    return footView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    orgInfo *info = self.dataArray[section];
    return info.subOrgInfo.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    KG_ContactTopCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_ContactTopCell"];
    if (cell == nil) {
        cell = [[KG_ContactTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_ContactTopCell"];
    }
    orgInfo *info = self.dataArray[indexPath.section];
    NSDictionary *dataDic  = info.subOrgInfo[indexPath.row];
    cell.dataDic = dataDic;
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
//搜索方法
- (void)searchButtonClick {
    
    if (self.searchMethod) {
        self.searchMethod();
    }
}

- (void)setModel:(KG_AddressbookModel *)model {
    _model = model;
    
    self.dataArray = model.orgInfo;
    [self.tableView reloadData];
}
@end
