//
//  KG_XunShiHandleView.m
//  Frame
//
//  Created by zhangran on 2020/4/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiHandleView.h"
#import "KG_XunShiHandleCell.h"
@interface  KG_XunShiHandleView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@end
@implementation KG_XunShiHandleView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
        [self setupDataSubviews];
        
    }
    return self;
}
- (void)initData{
    self.dataArray = [NSArray arrayWithObjects:@"修改任务",@"移交任务",@"提交任务",@"删除任务", nil];
    
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
    
    
    
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-47);
        make.right.equalTo(self.mas_right);
        make.left.equalTo(self.mas_left);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(176+44+3));
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
        
        
        
        UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
        footView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 3)];
        bgView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        [footView addSubview:bgView];
        
        UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 3, footView.frame.size.width ,44-3 )];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [footView addSubview:cancelBtn];
        [cancelBtn addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
        [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _tableView.tableFooterView = footView;
        
        
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
    
    KG_XunShiHandleCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_XunShiHandleCell"];
    if (cell == nil) {
        cell = [[KG_XunShiHandleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_XunShiHandleCell"];
        
    }
    
    cell.titleLabel.text = safeString(self.dataArray[indexPath.row]);
    if (indexPath.row == 0) {
        cell.iconImage.image = [UIImage imageNamed:@"change_task"];
    }else if (indexPath.row == 1) {
        cell.iconImage.image = [UIImage imageNamed:@"move_task"];
    }else if (indexPath.row == 2) {
        cell.iconImage.image = [UIImage imageNamed:@"report_task"];
    }else if (indexPath.row == 3) {
        cell.iconImage.image = [UIImage imageNamed:@"delete_task"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    NSDictionary *dataDic = self.dataArray[indexPath.row];
   
    if (self.didsel) {
        self.didsel(dataDic);
    }
    self.hidden = YES;
}



@end
