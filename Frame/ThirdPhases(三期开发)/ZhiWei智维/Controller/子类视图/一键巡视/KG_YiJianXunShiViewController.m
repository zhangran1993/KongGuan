//
//  KG_YiJianXunShiViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/22.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_YiJianXunShiViewController.h"
#import "KG_YiJianXunShiCell.h"
@interface KG_YiJianXunShiViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) UIButton *addBtn;
@end

@implementation KG_YiJianXunShiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self createView];
} 
- (void)createView {
    
    self.addBtn = [[UIButton alloc]init];
    [self.view addSubview:self.addBtn];
    [self.addBtn setBackgroundImage:[UIImage imageNamed:@"add_btnIcon"] forState:UIControlStateNormal];
    [self.addBtn addTarget:self action:@selector(addMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY);
        make.right.equalTo(self.view.mas_right).offset(-12.5);
        make.width.height.equalTo(@56);
    }];
    [self.view bringSubviewToFront:self.addBtn];
    
}
//按钮添加方法
- (void)addMethod:(UIButton *)button {
    
    
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = self.view.backgroundColor;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = YES;
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
        _tableView.tableHeaderView = headView;
        headView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    }
    return _tableView;
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
    return 3;
   
//    return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KG_YiJianXunShiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_YiJianXunShiCell"];
    if (cell == nil) {
        cell = [[KG_YiJianXunShiCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_YiJianXunShiCell"];
        cell.backgroundColor = self.view.backgroundColor;
    }else {
        
        NSLog(@"1");
    }
            
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return  118;
}
             
@end
