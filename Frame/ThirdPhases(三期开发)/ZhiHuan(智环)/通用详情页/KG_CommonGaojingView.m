//
//  KG_CommonGaojingView.m
//  Frame
//
//  Created by zhangran on 2020/5/6.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CommonGaojingView.h"
#import "KG_CommonGaoJingCell.h"
#import "KG_GaojingView.h"
@interface KG_CommonGaojingView ()<UITableViewDelegate,UITableViewDataSource>{
    
}


@property (nonatomic, strong) UITableView    *tableView;


@end

@implementation KG_CommonGaojingView


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
    
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F9FAFC"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        
    }
    return _tableView;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_CommonGaoJingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_CommonGaoJingCell"];
    if (cell == nil) {
        cell = [[KG_CommonGaoJingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_CommonGaoJingCell"];
    }
    cell.backgroundColor = [UIColor colorWithHexString:@"#F9FAFC"];
    NSDictionary *dic = self.dataArray[indexPath.row];
    
    cell.titleLabel.text = safeString(dic[@"name"]);
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
  
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self.tableView reloadData];
}
@end
