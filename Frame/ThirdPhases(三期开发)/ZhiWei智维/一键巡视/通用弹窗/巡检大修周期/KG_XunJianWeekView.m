//
//  KG_XunJianWeekView.m
//  Frame
//
//  Created by zhangran on 2020/4/28.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunJianWeekView.h"
#import "KG_XunJianWeekCell.h"
@interface  KG_XunJianWeekView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@end
@implementation KG_XunJianWeekView

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
    self.dataArray = [NSArray arrayWithObjects:@"选择内容模块",@"环境情况",@"动力情况",@"设备情况",@"其他", nil];
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
    UIView *centerView = [[UIView alloc] init];
    centerView.frame = CGRectMake(52.5,209,270,234);
    centerView.backgroundColor = [UIColor whiteColor];
    centerView.layer.cornerRadius = 12;
    centerView.layer.masksToBounds = YES;
    [self addSubview:centerView];
    [centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@270);
        make.height.equalTo(@254);
    }];
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(centerView.mas_bottom).offset(-10);
        make.right.equalTo(centerView.mas_right);
        make.left.equalTo(centerView.mas_left);
        make.width.equalTo(centerView.mas_width);
        make.top.equalTo(centerView.mas_top).offset(10);
    }];
    
    
    [self.tableView reloadData];
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
    
    KG_XunJianWeekCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_XunJianWeekCell "];
    if (cell == nil) {
        cell = [[KG_XunJianWeekCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_XunJianWeekCell"];
        
    }
    
    cell.titleLabel.text = safeString(self.dataArray[indexPath.row]);
    if (indexPath.row == 0) {
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"#030303"];
        cell.titleLabel.font = [UIFont systemFontOfSize:18];
    }else {
        cell.titleLabel.textColor = [UIColor colorWithHexString:@"#004EC4"];
        cell.titleLabel.font = [UIFont systemFontOfSize:17];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
 


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    NSString *str = self.dataArray[indexPath.row];
   
    if (self.didsel) {
        self.didsel(str);
    }
    self.hidden = YES;
}



@end
