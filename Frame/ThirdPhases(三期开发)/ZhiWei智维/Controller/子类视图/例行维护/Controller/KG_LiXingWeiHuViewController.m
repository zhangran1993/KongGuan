//
//  KG_LiXingWeiHuViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_LiXingWeiHuViewController.h"
#import "SegmentTapView.h"
#import "KG_LiXingWeiHuCell.h"
@interface KG_LiXingWeiHuViewController ()<SegmentTapViewDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;

@property (nonatomic, strong) SegmentTapView *segment;

@property (nonatomic ,strong) UIButton *addBtn;

@end

@implementation KG_LiXingWeiHuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createView];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segment.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
}

//按钮添加方法
- (void)addMethod:(UIButton *)button {
    
    
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
    KG_LiXingWeiHuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_LiXingWeiHuCell"];
    if (cell == nil) {
        cell = [[KG_LiXingWeiHuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_LiXingWeiHuCell"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    }
    if (indexPath.row == 1) {
        [cell.starImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
    
        [cell.starLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        [cell.timeImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(cell.starImage.mas_bottom);
        }];
        cell.taskButton.hidden = YES;
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 1) {
        return 92;
    }
    return  118;
}

- (void)createView {
    self.segment = [[SegmentTapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44) withDataArray:[NSArray arrayWithObjects:@"日维护",@"周/月维护",@"季/年维护",@"巡检", nil] withFont:15];
    self.segment.delegate = self;
    [self.view addSubview:self.segment];
    
    
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


@end
