//
//  KG_JiaoJieBanAlertView.m
//  Frame
//
//  Created by zhangran on 2020/5/29.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_JiaoJieBanAlertView.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface  KG_JiaoJieBanAlertView()<UITableViewDelegate,UITableViewDataSource>{
    
 
}
@property (nonatomic, strong) UIButton *zhibanBtn;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSDictionary *dataDic;

@property (nonatomic, strong) UITableView *tableView;
   
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UITextView *textView;

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) UIView *stationListView;
@end
@implementation KG_JiaoJieBanAlertView

- (instancetype)initWithCondition:(NSDictionary *)condition
{
    self = [super init];
    if (self) {
        self.dataDic = [condition[@"handoverInfo"] firstObject];
        [self.dataArray addObjectsFromArray:condition[@"handoverInfo"]];
        [self initData];
        [self setupDataSubviews];
        
    }
    return self;
}
//初始化数据
- (void)initData {
    
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
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.height.equalTo(@270);
        make.height.equalTo(@148);
    }];
    
//
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:titleLabel];
    titleLabel.text = @"选择交接班岗位";
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.font = [UIFont my_font:14];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.numberOfLines = 1;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerView.mas_centerX);
        make.top.equalTo(self.centerView.mas_top).offset(18);
        make.width.equalTo(@200);
        make.height.equalTo(@24);
    }];
    
    UIView *zhibanView = [[UIView alloc]init];
    [self.centerView addSubview:zhibanView];
    zhibanView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
    zhibanView.layer.borderColor = [[UIColor colorWithHexString:@"#E6E8ED"] CGColor];
    zhibanView.layer.borderWidth = 0.5;
    [zhibanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(16);
        make.right.equalTo(self.centerView.mas_right).offset(-16);
        make.top.equalTo(titleLabel.mas_bottom).offset(22);
        make.height.equalTo(@24);
    }];
    UIImageView *zhibanLeftIcon = [[UIImageView alloc]init];
    [zhibanView addSubview:zhibanLeftIcon];
    zhibanLeftIcon.image = [UIImage imageNamed:@"jiaojieban_leftIcon"];
    [zhibanLeftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhibanView.mas_left).offset(6);
        make.width.height.equalTo(@12);
        make.centerY.equalTo(zhibanView.mas_centerY);
    }];
    UILabel *zhibanLabel = [[UILabel alloc]init];
    [zhibanView addSubview:zhibanLabel];
    zhibanLabel.text = @"值班岗位";
    zhibanLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    zhibanLabel.font = [UIFont systemFontOfSize:12];
    zhibanLabel.font = [UIFont my_font:12];
    [zhibanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(zhibanLeftIcon.mas_right).offset(4);
        make.height.equalTo(@17);
        make.width.equalTo(@100);
        make.centerY.equalTo(zhibanView.mas_centerY);
    }];
    UIImageView *zhibanRightImage = [[UIImageView alloc]init];
    [zhibanView addSubview:zhibanRightImage];
    zhibanRightImage.image = [UIImage imageNamed:@"jiaojieban_rightIcon"];
    [zhibanRightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(zhibanView.mas_right).offset(-2);
        make.width.height.equalTo(@12);
        make.centerY.equalTo(zhibanView.mas_centerY);
    }];
    
    UIButton *bgBtn = [[UIButton alloc]init];
    [zhibanView addSubview:bgBtn];
    
    [bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(zhibanRightImage.mas_left).offset(-2);
        make.height.equalTo(zhibanView.mas_height);
        make.width.equalTo(@100);
        make.centerY.equalTo(zhibanView.mas_centerY);
    }];
    [bgBtn addTarget:self action:@selector(showStationList) forControlEvents:UIControlEventTouchUpInside];
    
    self.zhibanBtn = [[UIButton alloc]init];
    [zhibanView addSubview:self.zhibanBtn];
    [self.zhibanBtn setTitle:@"黄城导航台保障岗" forState:UIControlStateNormal];
    [self.zhibanBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    self.zhibanBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.zhibanBtn sizeToFit];
    [self.zhibanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(zhibanRightImage.mas_left).offset(-2);
        make.height.equalTo(zhibanView.mas_height);
        make.centerY.equalTo(zhibanView.mas_centerY);
    }];
    [self.zhibanBtn addTarget:self action:@selector(showStationList) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
    [self.centerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_bottom).offset(-44);
        make.height.equalTo(@1);
        make.width.equalTo(@270);
        make.left.equalTo(self.centerView.mas_left);
        make.right.equalTo(self.centerView.mas_right);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.centerView addSubview:cancelBtn];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left);
        make.top.equalTo(lineView.mas_bottom);
        make.width.equalTo(@135);
        make.height.equalTo(@43);
    }];
    
    
    UIButton *confirmBtn = [[UIButton alloc]init];
    [self.centerView addSubview:confirmBtn];
    [confirmBtn setTitle:@"确定" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmMethod:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView.mas_right);
        make.top.equalTo(lineView.mas_bottom);
        make.width.equalTo(@135);
        make.height.equalTo(@43);
    }];
    UIView *botLine = [[UIView alloc]init];
    botLine.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
    [self.centerView addSubview:botLine];
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerView.mas_centerX);
        make.bottom.equalTo(self.centerView.mas_bottom);
        make.width.equalTo(@1);
        make.height.equalTo(@43);
    }];
    [self refreshData];
}
//取消
- (void)cancelMethod:(UIButton *)button {
    self.hidden = YES;
    [self.textField resignFirstResponder];
}
//确定
- (void)confirmMethod:(UIButton *)button {
    if (self.confirmBlockMethod) {
        self.confirmBlockMethod(self.dataDic);
    }
}
- (void)buttonClickMethod:(UIButton *)button {
    self.hidden = YES;
    [self.textField resignFirstResponder];
    [self.textView resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField {
    
    [textField resignFirstResponder];
    
    return YES;
    
}
//选择岗位

- (void)showStationList {
    self.stationListView = [[UIView alloc]init];
    self.stationListView.backgroundColor = [UIColor whiteColor];
   
    [self.centerView addSubview:self.stationListView];
    
    [self.stationListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(2*30));
        make.top.equalTo(self.centerView.mas_top).offset(90);
        make.left.equalTo(self.centerView.mas_left).offset(16);
        make.right.equalTo(self.centerView.mas_right).offset(-16);
        
    }];
    [self.centerView mas_updateConstraints:^(MASConstraintMaker *make) {
       make.height.equalTo(@(148 + 2*30));
    }];
    
    [self addSubview:self.tableView];
    self.tableView.layer.borderWidth = 0.5;
    self.tableView.layer.borderColor = [[UIColor colorWithHexString:@"#E6E8ED"] CGColor];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.stationListView.mas_top);
        make.left.equalTo(self.stationListView.mas_left);
        make.right.equalTo(self.stationListView.mas_right);
        make.bottom.equalTo(self.stationListView.mas_bottom);
    }];
    
    
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
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return   2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
   
    NSDictionary *dic = self.dataArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [CommonExtension getWorkType:safeString(dic[@"post"])];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    cell.textLabel.font = [UIFont my_font:12];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.dataDic = self.dataArray[indexPath.row];
       [self refreshData];
}
- (void)refreshData {
    if (self.dataDic.count) {
        
        [self.zhibanBtn setTitle:[CommonExtension getWorkType:self.dataDic[@"post"]] forState:UIControlStateNormal];
        
    }
}

@end
