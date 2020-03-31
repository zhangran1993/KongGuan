//
//  KG_OverAlertCenterView.m
//  Frame
//
//  Created by zhangran on 2020/3/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_OverAlertCenterView.h"
#import "KG_OverAlertCenterCell.h"
@interface KG_OverAlertCenterView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;
@end

@implementation KG_OverAlertCenterView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self setupSubviews];
        
    }
    return self;
}
//初始化数据
- (void)initData {
    self.dataArray = [NSArray arrayWithObjects:@"台站等级",@"设备年限",@"告警数量",@"设备故障率",@"告警等级",@"天气因素",@"设备等级",@"备件库存",@"巡视间隔",@"人员因素", nil];
}

//创建视图
-(void)setupSubviews
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
    
    UIImageView *topImage = [[UIImageView alloc]init];
    topImage.image = [UIImage imageNamed:@"alert_bgImage"];
    [self addSubview:topImage];
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@245);
        make.height.equalTo(@328);
    }];
    
    UIImageView *personImage = [[UIImageView alloc]init];
    personImage.image = [UIImage imageNamed:@"alert_text"];
    [self addSubview:personImage];
    [personImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topImage.mas_left).offset(7);
        make.top.equalTo(topImage.mas_top).offset(14);
        make.width.equalTo(@136);
        make.height.equalTo(@68);
    }];
    
    UIImageView *headImage = [[UIImageView alloc]init];
    headImage.image = [UIImage imageNamed:@"alert_person"];
    [self addSubview:headImage];
    [headImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topImage.mas_left).offset(87);
        make.top.equalTo(topImage.mas_top).offset(-12);
        make.width.equalTo(@184);
        make.height.equalTo(@117);
    }];
    UIImageView *starImage = [[UIImageView alloc]init];
    starImage.image = [UIImage imageNamed:@"alert_star"];
    [self addSubview:starImage];
    [starImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topImage.mas_left).offset(-12);
        make.top.equalTo(personImage.mas_bottom).offset(-5);
        make.width.equalTo(@64);
        make.height.equalTo(@9);
    }];
    
    UIView *centerView = [[UIView alloc]init];
    [self addSubview:centerView];
    centerView.backgroundColor = [UIColor colorWithHexString:@"#FAFDFF"];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topImage.mas_left).offset(12);
        make.right.equalTo(topImage.mas_right).offset(-12);
        make.width.equalTo(@221);
        make.height.equalTo(@87);
        make.top.equalTo(personImage.mas_bottom).offset(14);
    }];
    centerView.layer.cornerRadius = 2;
    centerView.layer.masksToBounds = YES;
    UILabel *centerLabel = [[UILabel alloc]init];
    [centerView addSubview:centerLabel];
    centerLabel.text = @"结合台站实际情况，多维度综合计算台站健康指数。计算数据具有实时性、全面性、科学性。";
    centerLabel.textColor = [UIColor colorWithHexString:@"#2E719B"];
    centerLabel.numberOfLines =0;
    centerLabel.font = [UIFont systemFontOfSize:14];
    centerLabel.textAlignment = NSTextAlignmentCenter;
    [centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(centerView.mas_left).offset(10);
        make.right.equalTo(centerView.mas_right).offset(-10);
        make.top.equalTo(centerView.mas_top).offset(11);
        make.bottom.equalTo(centerView.mas_bottom).offset(-6);
    }];
    
    UIView *bottomView = [[UIView alloc]init];
    [self addSubview:bottomView];
    bottomView.layer.cornerRadius = 2;
    bottomView.layer.masksToBounds = YES;
    bottomView.backgroundColor = [UIColor colorWithHexString:@"#FAFDFF"];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topImage.mas_left).offset(12);
        make.right.equalTo(topImage.mas_right).offset(-12);
        make.width.equalTo(@221);
        make.height.equalTo(@125);
        make.top.equalTo(centerView.mas_bottom).offset(7);
    }];
    
    [bottomView addSubview:self.tableView];
    [self.tableView reloadData];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bottomView.mas_top);
        make.bottom.equalTo(bottomView.mas_bottom);
        make.width.equalTo(bottomView.mas_width);
        make.height.equalTo(bottomView.mas_height);
    }];
    
    UIImageView *closeImage = [[UIImageView alloc]init];
    closeImage.image = [UIImage imageNamed:@"cancel_bottom"];
    [self addSubview:closeImage];
    [closeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(topImage.mas_centerX);
        make.top.equalTo(topImage.mas_bottom).offset(20);
        make.height.width.equalTo(@24);
    }];
    

}

// 背景按钮点击视图消失
- (void)buttonClickMethod :(UIButton *)btn {
    self.hidden = YES;
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
    
    return self.dataArray.count/2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return  20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_OverAlertCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_OverAlertCenterCell"];
    if (cell == nil) {
        cell = [[KG_OverAlertCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_OverAlertCenterCell"];
        
    }
    int row = (int)indexPath.row;
    cell.titleLabel.text = self.dataArray[row*2];
    cell.titleLabel1.text = self.dataArray[row*2 + 1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    NSString *selString = self.dataArray[indexPath.row];
//    if (self.didsel) {
//        self.didsel(selString);
//    }
//    self.hidden = YES;
}

@end
