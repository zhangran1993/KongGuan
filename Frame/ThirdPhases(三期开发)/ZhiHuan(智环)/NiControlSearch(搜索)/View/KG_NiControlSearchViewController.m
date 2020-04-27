//
//  KG_NiControlSearchViewController.m
//  Frame
//
//  Created by zhangran on 2020/4/9.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NiControlSearchViewController.h"
#import "KG_SearchCell.h"
@interface KG_NiControlSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSArray *dataArray;

      
@end

@implementation KG_NiControlSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];

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
        make.top.equalTo(self.view.mas_top).offset(NAVIGATIONBAR_HEIGHT-64);
        make.height.equalTo(@30);
    }];
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [searchView addSubview:cancelBtn];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#24252A"] forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [cancelBtn addTarget:self action:@selector(cancelMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(searchView.mas_right).offset(-16);
        make.top.equalTo(searchView.mas_top);
        make.height.equalTo(@30);
        make.width.equalTo(@30);
    }];
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    [searchView addSubview:iconImage];
    iconImage.image = [UIImage imageNamed:@"seach_icon"];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(searchView.mas_left).offset(6);
        make.width.height.equalTo(@18);
        make.centerY.equalTo(searchView.mas_centerY);
    }];
 
    UITextField *textField = [[UITextField alloc]init];
    [searchView addSubview:textField];
    textField.text = @"";
    textField.placeholder = @"";
    textField.delegate = self;
    textField.textColor = [UIColor colorWithHexString:@"#24252A"];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImage.mas_right).offset(9);
        make.height.equalTo(@30);
        make.right.equalTo(cancelBtn.mas_left).offset(-10);
        make.top.equalTo(searchView.mas_top);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    
    titleLabel.text = @"包含“空调”的内容";
  
    titleLabel.textColor = [UIColor colorWithHexString:@"#BABCC4"];
    titleLabel.font = [UIFont systemFontOfSize:12];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [searchView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(19);
        make.width.equalTo(@200);
        make.top.equalTo(searchView.mas_bottom).offset(13);
        make.height.equalTo(@17);
    }];
  
}


- (void)cancelMethod:(UIButton *)button {
    
}

//创建视图
-(void)setupDataSubviews
{
    
    [self.view addSubview:self.tableView];
  
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.
                         view.mas_top).offset(96+NAVIGATIONBAR_HEIGHT-64);
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
    
   
    KG_SearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_SearchCell"];
    if (cell == nil) {
        cell = [[KG_SearchCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_SearchCell"];
        
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
