//
//  KG_OperationGuideView.m
//  Frame
//
//  Created by zhangran on 2020/6/17.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_OperationGuideView.h"
@interface KG_OperationGuideView ()<UITableViewDataSource,UITableViewDelegate>{
    
}

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArray;


@property (nonatomic,strong) UIView *headView;
@property (nonatomic,strong) UIButton *moreBtn;

@end
@implementation KG_OperationGuideView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI {
    [self addSubview:self.tableView];
   
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 45)];
    self.tableView.tableHeaderView = self.headView;
    UIImageView *iconImage = [[UIImageView alloc]init];
    [self.headView addSubview:iconImage];
    iconImage.image = [UIImage imageNamed:@"operaguide_icon"];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headView.mas_left).offset(16);
        make.width.height.equalTo(@14);
        make.top.equalTo(self.headView.mas_top).offset(16);
        
    }];
    
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.headView addSubview:titleLabel];
    titleLabel.text = @"操作指引";
    titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.numberOfLines = 1;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImage.mas_right).offset(12.5);
        make.centerY.equalTo(self.headView.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(@24);
    }];
    
    self.moreBtn = [[UIButton alloc]init];
    [self.headView addSubview:self.moreBtn];
    [self.moreBtn addTarget:self action:@selector(moreMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn setTitleColor:[UIColor colorWithHexString:@"#1860B0"] forState:UIControlStateNormal];
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.moreBtn setImage:[UIImage imageNamed:@"blue_jiantou"] forState:UIControlStateNormal];
    [self.moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
    
    [self.moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0,130, 0, 0)];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.headView.mas_right).offset(-20);
        make.centerY.equalTo(iconImage.mas_centerY  );
        make.width.equalTo(@100);
        make.height.equalTo(@(102 -44));
    }];
      
    
}
- (void)moreMethod:(UIButton *)button {
    if (self.moreAction) {
        self.moreAction();
    }
    
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
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (self.dataArray.count >3) {
        return 3;
    }
    return  self.dataArray.count ;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell ==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = @"1.";
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    cell.textLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightMedium];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
}
@end
