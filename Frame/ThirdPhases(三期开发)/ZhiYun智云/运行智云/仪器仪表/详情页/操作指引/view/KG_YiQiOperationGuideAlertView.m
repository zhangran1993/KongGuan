//
//  KG_YiQiOperationGuideAlertView.m
//  Frame
//
//  Created by zhangran on 2020/9/24.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_YiQiOperationGuideAlertView.h"
#import "KG_YiQiOperationGuideAlertCell.h"

#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_YiQiOperationGuideAlertView ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong)  UITableView        *tableView;

@property (nonatomic, strong)  NSArray            *dataArray;

@property (nonatomic, strong)  UIButton           *bgBtn ;

@property (nonatomic, strong)  UIView             *centerView;

@end

@implementation KG_YiQiOperationGuideAlertView


- (instancetype)initWithDataArray:(NSArray *)dataArray
{
    self = [super init];
    if (self) {
        self.dataArray = dataArray;
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
        
        make.top.equalTo(self.mas_top).offset((SCREEN_HEIGHT -326)/2);
        make.left.equalTo(self.mas_left).offset(53);
        make.right.equalTo(self.mas_right).offset(-53);
        make.height.equalTo(@(44 *self.dataArray.count +60));
    }];
    [self.centerView addSubview:self.tableView];
   
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_top);
        make.left.equalTo(self.centerView.mas_left);
        make.right.equalTo(self.centerView.mas_right);
        make.height.equalTo(self.centerView.mas_height);
    }];
    self.tableView.scrollEnabled = NO;
    [self.tableView reloadData];
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-106, 58)];
    headView.backgroundColor = [UIColor clearColor];
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-106, 58)];
    [headView addSubview:headLabel];
    headLabel.textAlignment = NSTextAlignmentCenter;
    headLabel.text = @"选择操作指引分类";
    headLabel.textColor = [UIColor colorWithHexString:@"#030303"];
    headLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    headLabel.font = [UIFont my_font:18];
    UIView *lineView = [[UIView alloc]init];
    [headView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(16);
        make.right.equalTo(headView.mas_right).offset(-16);
        make.top.equalTo(headLabel.mas_bottom);
        make.height.equalTo(@1);
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
    
    KG_YiQiOperationGuideAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_YiQiOperationGuideAlertCell"];
    if (cell == nil) {
        cell = [[KG_YiQiOperationGuideAlertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_YiQiOperationGuideAlertCell"];
    }
    cell.titleLabel.text = safeString(self.dataArray[indexPath.row][@"name"]);
    cell.titleLabel.textColor = [UIColor colorWithHexString:@"#2F5ED1"];
    
    if (self.dataArray.count) {
        if (indexPath.row == self.dataArray.count -1) {
            cell.lineView.hidden = YES;
        }else {
            cell.lineView.hidden = NO;
        }
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *ss = safeString(self.dataArray[indexPath.row][@"code"]);
    NSString *name = safeString(self.dataArray[indexPath.row][@"name"]);
    if (self.selTypeStr) {
        self.selTypeStr(ss,name);
    }
    self.hidden = YES;
}

- (void)buttonClickMethod:(UIButton *)btn {
    self.hidden = YES;
}

//将时间戳转换为时间字符串
- (NSString *)timestampToTimeStr:(NSString *)timestamp {
    if (isSafeObj(timestamp)==NO) {
        return @"-/-";
    }
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp.integerValue/1000];
    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd HH:mm:ss"] stringFromDate:date];
    //    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd"] stringFromDate:date];
    return timeStr;
    
}
- (NSDateFormatter *)dateFormatWith:(NSString *)formatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatStr];//@"YYYY-MM-dd HH:mm:ss"
    //设置时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    return formatter;
}



@end
