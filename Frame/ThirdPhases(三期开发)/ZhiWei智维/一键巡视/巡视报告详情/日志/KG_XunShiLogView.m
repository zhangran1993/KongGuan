//
//  KG_XunShiLogView.m
//  Frame
//
//  Created by zhangran on 2020/4/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiLogView.h"
#import "KG_XunShiSegmentView.h"
#import "KG_LiXingWeiHuCell.h"
#import "KG_XunShiLogCell.h"
#import "KG_GetLogCell.h"
@interface KG_XunShiLogView ()<SegmentTapViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;

@property (nonatomic, strong) KG_XunShiSegmentView *segment;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UIView *bottomLogView;
@property (nonatomic ,strong) NSMutableArray *logArray;
@property (nonatomic ,strong) UITableView *logTableView;
@end

@implementation KG_XunShiLogView

-(instancetype)init {
    self = [super init];
    if (self) {
        [self createView];
       
    }
    return self;
}
- (void)createView {
    self.segment = [[KG_XunShiSegmentView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45) withDataArray:[NSArray arrayWithObjects:@"回复",@"日志", nil] withFont:14];
    self.segment.delegate = self;
    [self.segment selectIndex:2];
    [self addSubview:self.segment];
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segment.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.bottomView  = [[UIView alloc]init];
    [self addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@52);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    UIButton *addBtn = [[UIButton alloc]init];
    [self.bottomView addSubview:addBtn];
   
    [addBtn setImage:[UIImage imageNamed:@"log_addbtn"] forState:UIControlStateNormal];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView.mas_right).offset(-15.5);
        make.width.height.equalTo(@26);
        make.top.equalTo(self.bottomView.mas_top).offset(13);
    }];
    
    [addBtn addTarget:self action:@selector(addBtnMethod:) forControlEvents:UIControlEventTouchUpInside];
    UITextField *textField = [[UITextField alloc]init];
    [self.bottomView addSubview:textField];
    textField.placeholder = @"说说你的想法…";
    textField.backgroundColor = [UIColor whiteColor];
    textField.delegate = self;
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView.mas_left).offset(16);
        make.centerY.equalTo(self.bottomView.mas_centerY);
        make.height.equalTo(self.bottomView.mas_height);
        make.right.equalTo(addBtn.mas_left).offset(-9.5);
    }];
    textField.layer.cornerRadius = 4;
    textField.layer.masksToBounds = YES;
    
    self.bottomView.hidden = YES;
    self.tableView.hidden = YES;
    [self addSubview:self.logTableView];
    [self.logTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segment.mas_bottom);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
   
       
    
}

- (void)addBtnMethod :(UIButton *)btn{
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
        _tableView.tableHeaderView = headView;
        headView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    }
    return _tableView;
}

- (UITableView *)logTableView {
    if (!_logTableView) {
        _logTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _logTableView.delegate = self;
        _logTableView.dataSource = self;
        _logTableView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _logTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _logTableView.scrollEnabled = YES;
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
        _logTableView.tableHeaderView = headView;
        headView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    }
    return _logTableView;
}

- (NSMutableArray *)logArray
{
    if (!_logArray) {
        _logArray = [[NSMutableArray alloc] init];
    }
    return _logArray;
}

- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([self.logTableView isEqual:tableView]) {
        return self.logArr.count;
    }
    return self.receiveArr.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.logTableView isEqual:tableView]) {
        
        KG_GetLogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_GetLogCell"];
           if (cell == nil) {
               cell = [[KG_GetLogCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_GetLogCell"];
               cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
           }
           cell.selectionStyle = UITableViewCellSelectionStyleNone;
           NSDictionary *dic = self.logArr[indexPath.row];
           cell.dic =dic;
           
           return cell;
        
    }
    
    KG_XunShiLogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_XunShiLogCell"];
    if (cell == nil) {
        cell = [[KG_XunShiLogCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_XunShiLogCell"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSDictionary *dic = self.receiveArr[indexPath.row];
    cell.dic =dic;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.logTableView]) {
        return 44;
    }
    
    return  80;
}

- (void)setReceiveArr:(NSArray *)receiveArr {
    _receiveArr = receiveArr;
    [self.tableView reloadData];
}
- (void)setLogArr:(NSArray *)logArr {
    _logArr = logArr;
    [self.logTableView reloadData];
}


@end
