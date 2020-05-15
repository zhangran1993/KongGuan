//
//  KG_XunJianReportViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/28.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunJianReportViewController.h"
#import "KG_XunJianReportCell.h"
@interface  KG_XunJianReportViewController()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) UITableView *tableView;

@end
@implementation KG_XunJianReportViewController

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
    
  
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
        make.left.equalTo(self.view.mas_left);
        make.width.equalTo(self.view.mas_width);
        make.height.equalTo(self.view.mas_height);
    }];
    
    

}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
    }
    return _tableView;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_XunJianReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_XunJianReportCell"];
    if (cell == nil) {
        cell = [[KG_XunJianReportCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_XunJianReportCell"];
        
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

}



@end
