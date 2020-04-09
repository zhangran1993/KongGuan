//
//  KG_CenterTableView.m
//  Frame
//
//  Created by zhangran on 2020/4/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CenterView.h"
#import "KG_CenterCell.h"
@interface  KG_CenterView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSArray *dataArray;

                                                        
@end
@implementation KG_CenterView


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
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        
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
    
    return  self.dataArray.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_CenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_CenterCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"KG_CenterCell" owner:self options:nil] lastObject];
    }
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    
    cell.dataDic = dataDic;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50.f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, 100, 40)];
    if(self.dataArray.count ){
        titleLabel.text = safeString(self.dataArray[section][@"name"]);
    }
    
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:titleLabel];
    return headView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}


- (void)setSecArray:(NSArray *)secArray {
    _secArray = secArray;
    self.dataArray = secArray;
    [self.tableView reloadData];
    
}

- (void)setEnvArray:(NSArray *)envArray {
    _envArray = envArray;
    self.dataArray = envArray;
    [self.tableView reloadData];
    
    
}

- (void)setPowArray:(NSArray *)powArray {
    _powArray = powArray;
    self.dataArray = powArray;
    [self.tableView reloadData];
    
    
}
@end
