//
//  KG_GaojingView.m
//  Frame
//
//  Created by zhangran on 2020/4/16.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_GaojingView.h"
#import "KG_CenterCell.h"


#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface  KG_GaojingView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSArray *dataArray;

                                                        
@end
@implementation KG_GaojingView


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
//        _tableView.userInteractionEnabled = NO;
        
    }
    return _tableView;
}
-(NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSArray array];
    }
    return _dataArray;
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.dataArray.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 21;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
       
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    
    cell.textLabel.text = safeString(dataDic[@"name"]);
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.font = [UIFont my_font:14];
    [cell.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.textLabel.mas_centerY);
        make.left.equalTo(cell.mas_left);
        make.width.equalTo(@100);
    }];
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    
    UILabel *detaillabel = [[UILabel alloc]init];
    
    detaillabel.text = [NSString stringWithFormat:@"%@%@",safeString(dataDic[@"valueAlias"]),safeString(dataDic[@"unit"])];
    
    if ([safeString(dataDic[@"valueAlias"]) containsString:safeString(dataDic[@"unit"])]) {
        detaillabel.text = [NSString stringWithFormat:@"%@",safeString(dataDic[@"valueAlias"])] ;
    }
    if (safeString(dataDic[@"unit"]).length == 0) {
        detaillabel.text = [NSString stringWithFormat:@"%@",safeString(dataDic[@"valueAlias"])] ;
    }
    
    
    
    detaillabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    detaillabel.textAlignment = NSTextAlignmentRight;
    detaillabel.font = [UIFont systemFontOfSize:14];
    detaillabel.font = [UIFont my_font:14];
    [cell addSubview:detaillabel];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [detaillabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(cell.textLabel.mas_centerY);
        make.right.equalTo(cell.mas_right).offset(-5);
        make.width.equalTo(@100);
        make.height.equalTo(@21);
    }];
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}


- (void)setPowArray:(NSArray *)powArray {
    _powArray = powArray;
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary *dic in powArray) {
        if ([dic[@"picShow"] boolValue]) {
            [arr addObject:dic];
        }
    }
    self.dataArray = arr;
    [self.tableView reloadData];
}
@end
