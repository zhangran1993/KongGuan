//
//  KG_ZhiTaiRightAlertView.m
//  Frame
//
//  Created by zhangran on 2020/4/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//
#import "KG_ZhiTaiRightAlertView.h"
#import "KG_UpsAlertCell.h"
@interface  KG_ZhiTaiRightAlertView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@end
@implementation KG_ZhiTaiRightAlertView


- (instancetype)init
{
    self = [super init];
    if (self) {
       
        [self setupDataSubviews];
        
    }
    return self;
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
    float xDep = NAVIGATIONBAR_HEIGHT;
    UIView *bgView = [[UIView alloc]init];
    [self addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(xDep);
        make.right.equalTo(self.mas_right).offset(-16);
        make.width.equalTo(@162);
        make.height.equalTo(@311);
    }];
    bgView.layer.cornerRadius = 8.f;
    bgView.layer.masksToBounds = YES;
    UIImageView *topImage = [[UIImageView alloc]init];
    topImage.image = [UIImage imageNamed:@"slider_up"];
   
    [self addSubview:topImage];
    
    [self addSubview:self.tableView];
    
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
        _tableView.scrollEnabled = YES;
        
    }
    return _tableView;
}



#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *categoryArray = self.dataArray[section][@"categoryInfo"];
    return categoryArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_UpsAlertCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_UpsAlertCell"];
    if (cell == nil) {
        cell = [[KG_UpsAlertCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_UpsAlertCell"];
        
    }
    NSDictionary *dataDic = self.dataArray[indexPath.section];
    
    NSDictionary *detailDic = dataDic[@"categoryInfo"][indexPath.row];
    cell.titleLabel.text = safeString(detailDic[@"categoryName"]);
    
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
   
    NSDictionary *dataDic = self.dataArray[section];
    titleLabel.text = safeString(dataDic[@"groupName"]);
       
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(14,39,133 , 1)];
    [headView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
   
    return headView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    NSDictionary *dataDic = self.dataArray[indexPath.section];
    NSDictionary *detailDic = dataDic[@"categoryInfo"][indexPath.row];
    
    if (self.didsel) {
        self.didsel(detailDic);
    }
    self.hidden = YES;
}


- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self.tableView reloadData];
}
@end
