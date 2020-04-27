//
//  KG_NiControlViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NiControlViewController.h"
#import "KG_NiControlCell.h"
@interface KG_NiControlViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSArray *dataArray;

      

@end

@implementation KG_NiControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createSearchUI];
    [self setupDataSubviews];
}

- (void)createSearchUI {
    
    UIView *searchView = [[UIView alloc]init];
    [self.view addSubview:searchView];
    searchView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    [searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@44);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, 100, 40)];
   
    titleLabel.text = @"";
   
    
    titleLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [searchView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(16);
        make.width.equalTo(@100);
        make.top.equalTo(self.view.mas_top);
        make.height.equalTo(@44);
    }];
    
    
    UIButton *startBtn = [[UIButton  alloc]init];
    [startBtn setTitle:@"2020.03.02" forState:UIControlStateNormal];
    [startBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    startBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [searchView addSubview:startBtn];
    [startBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    startBtn.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    startBtn.layer.cornerRadius = 2;
    startBtn.layer.masksToBounds = YES;
    [startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchView.mas_left).offset(107);
        make.width.equalTo(@96);
        make.height.equalTo(@24);
        make.top.equalTo(searchView.mas_top).offset(10);
    }];
    
    UIButton *endBtn = [[UIButton  alloc]init];
    [endBtn setTitle:@"2020.03.02" forState:UIControlStateNormal];
    [endBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    endBtn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    [searchView addSubview:endBtn];
    [endBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    [endBtn addTarget:self action:@selector(endButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [endBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(startBtn.mas_right).offset(22);
        make.width.equalTo(@96);
        make.height.equalTo(@24);
        make.top.equalTo(searchView.mas_top).offset(10);
    }];
    endBtn.layer.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1.0].CGColor;
    endBtn.layer.cornerRadius = 2;
    endBtn.layer.masksToBounds = YES;
    
    UIButton *resetBtn  = [[UIButton alloc]init];
    [resetBtn setTitle:@"重置" forState:UIControlStateNormal];
    [searchView addSubview:resetBtn];
    resetBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [resetBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    [resetBtn addTarget:self action:@selector(resetButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
           make.right.equalTo(searchView.mas_right).offset(-16);
           make.width.equalTo(@30);
           make.height.equalTo(@20);
           make.top.equalTo(searchView.mas_top).offset(12);
       }];
}


- (void)startButtonClick:(UIButton *)button {
    
}
- (void)endButtonClick:(UIButton *)button {
    
}
- (void)resetButtonClick:(UIButton *)button {
    
}
//创建视图
-(void)setupDataSubviews
{
    
    [self.view addSubview:self.tableView];
  
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.
                         view.mas_top).offset(44);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    [self.tableView reloadData];

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
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    KG_NiControlCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_NiControlCell"];
    if (cell == nil) {
        cell = [[KG_NiControlCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_NiControlCell"];
        
    }
    NSDictionary *dataDic = self.dataArray[indexPath.row];
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

@end
