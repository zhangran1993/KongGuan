//
//  KG_TransFirstView.m
//  
//
//  Created by zhangran on 2020/4/10.
//

#import "KG_TransFirstView.h"
#import "KG_MonitorCell.h"
@interface  KG_TransFirstView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSArray *dataArray;

                                                        
@end
@implementation KG_TransFirstView


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
    self.dataArray = [NSArray arrayWithObjects:@"自身状态：正常",@"数据状态：正常",@"旁路：关",@"开启",@"监视器1", nil];
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
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return   1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 26;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_MonitorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_MonitorCell"];
    if (cell == nil) {
        cell = [[KG_MonitorCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_MonitorCell"];
    }
    NSString *titleString = self.dataArray[indexPath.section];
    
    cell.titleLabel.text = safeString(titleString);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    headView.backgroundColor = [UIColor whiteColor];
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
   
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1.f;
}

@end
