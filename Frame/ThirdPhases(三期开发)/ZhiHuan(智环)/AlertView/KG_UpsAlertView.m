//
//  KG_UpsAlertView.m
//  Frame
//
//  Created by zhangran on 2020/4/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_UpsAlertView.h"
#import "KG_UpsAlertCell.h"
@interface  KG_UpsAlertView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSArray *dataArray;


@end
@implementation KG_UpsAlertView


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
    self.dataArray = [NSArray arrayWithObjects:@"综合分析法",@"综合指数法",@"灰色关联分析法", nil];
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
    
    UIImageView *topImage = [[UIImageView alloc]init];
    topImage.image = [UIImage imageNamed:@"slider_up"];
   
    [self addSubview:topImage];
    
    
    
    [self.tableView reloadData];
    [self addSubview:self.tableView];
    float xDep = NAVIGATIONBAR_HEIGHT;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(xDep);
        make.right.equalTo(self.mas_right).offset(-16);
        make.width.equalTo(@162);
        make.height.equalTo(@311);
    }];
    self.tableView.layer.cornerRadius = 8.f;
    self.tableView.layer.masksToBounds = YES;
    [topImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_top).offset(-7);
            make.right.equalTo(self.mas_right).offset(-28);
            make.width.equalTo(@25);
            make.height.equalTo(@7);
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
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_UpsAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_UpsAlertCell"];
    if (cell == nil) {
        cell = [[KG_UpsAlertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_UpsAlertCell"];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, 100, 40)];
    titleLabel.text = @"安防";
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:titleLabel];
    return headView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *didselString= @"comprehensiveScoringMethod";
    NSString *selString = self.dataArray[indexPath.row];
    if ([selString isEqualToString:@"综合分析法"]) {
        didselString = @"comprehensiveScoringMethod";
    }else if ([selString isEqualToString:@"综合指数法"]) {
        didselString = @"syntheticalIndexMethod";
    }else if ([selString isEqualToString:@"灰色关联分析法"]) {
        didselString = @"greyCorrelativeAnalysis";
    }
    if (self.didsel) {
        self.didsel(didselString);
    }
    self.hidden = YES;
}

@end
