//
//  KG_CenterTableView.m
//  Frame
//
//  Created by zhangran on 2020/4/1.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_NiTaiTuNoDataView.h"
#import "KG_CenterCell.h"
@interface  KG_NiTaiTuNoDataView()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) UIButton *bgBtn ;

@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSArray *dataArray;

                                                        
@end
@implementation KG_NiTaiTuNoDataView


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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_CenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_CenterCell"];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"KG_CenterCell" owner:self options:nil] lastObject];
    }
    if (indexPath.row == 0) {
        cell.iconImage.image = [UIImage imageNamed:@"导航DVOR"];
        cell.titleLabel.text = safeString(@"DVOR");
        NSDictionary *dataDic = self.dmeDic[@"totalDetail"];
        if([dataDic[@"status"] isEqualToString:@"0"]){
            cell.levelImagee.image = [UIImage imageNamed:@"level_normal"];
        }else if([dataDic[@"status"] isEqualToString:@"3"]){
            cell.levelImagee.image = [UIImage imageNamed:@"level_normal"];
        }else if([dataDic[@"status"] isEqualToString:@"1"]){
            cell.levelImagee.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%@",dataDic[@"level"]]]];
            cell.redDotImage.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",dataDic[@"level"]]];
            cell.redDotImage.text = [NSString stringWithFormat:@"%@",dataDic[@"num"]];
            
        }else{
            cell.levelImagee.image = [UIImage imageNamed:@"level_normal"];
        }
        if ([dataDic[@"num"] intValue] == 0) {
            cell.redDotImage.hidden = YES;
        }else {
            cell.redDotImage.hidden =NO;
        }
    }else if (indexPath.row == 1) {
        cell.iconImage.image = [UIImage imageNamed:@"导航DME"];
        cell.titleLabel.text = safeString(@"DME");
 
        NSDictionary *dataDic = self.dvorDic[@"totalDetail"];
        
        if([dataDic[@"status"] isEqualToString:@"0"]){
            cell.levelImagee.image = [UIImage imageNamed:@"level_normal"];
        }else if([dataDic[@"status"] isEqualToString:@"3"]){
            cell.levelImagee.image = [UIImage imageNamed:@"level_normal"];
        }else if([dataDic[@"status"] isEqualToString:@"1"]){
            cell.levelImagee.image =[UIImage imageNamed:[self getLevelImage:[NSString stringWithFormat:@"%@",dataDic[@"level"]]]];
            cell.redDotImage.backgroundColor = [self getTextColor:[NSString stringWithFormat:@"%@",dataDic[@"level"]]];
            cell.redDotImage.text = [NSString stringWithFormat:@"%@",dataDic[@"num"]];
            
        }else{
            cell.levelImagee.image = [UIImage imageNamed:@"level_normal"];
        }
        if ([dataDic[@"num"] intValue] == 0) {
            cell.redDotImage.hidden = YES;
        }else {
            cell.redDotImage.hidden =NO;
        }
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 50.f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    headView.backgroundColor = [UIColor whiteColor];
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 0, 100, 50)];
    
    titleLabel.text = @"导航设备";
 
    
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:titleLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(16, 49, SCREEN_WIDTH - 32 -32, 0.5)];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [headView addSubview:lineView];
    
    return headView;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    if (self.didsel) {
        self.didsel(indexPath.row);
    }

}


- (void)setEnvArray:(NSArray *)envArray {
    _envArray = envArray;
    self.dataArray = envArray;
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@(envArray.count *50+50));
    }];
    [self.tableView reloadData];
    
    
}

- (void)setDmeDic:(NSDictionary *)dmeDic {
    _dmeDic = dmeDic;
    [self.tableView reloadData];
}

- (void)setDvorDic:(NSDictionary *)dvorDic {
    _dvorDic = dvorDic;
    [self.tableView reloadData];
}
- (UIColor *)getTextColor:(NSString *)level {
    UIColor *textColor = [UIColor colorWithHexString:@"FFFFFF"];
    
    if ([level isEqualToString:@"0"]) {
        textColor = [UIColor colorWithHexString:@"FFFFFF"];
    }else if ([level isEqualToString:@"4"]) {
        textColor = [UIColor colorWithHexString:@"2986F1"];
    }else if ([level isEqualToString:@"3"]) {
        textColor = [UIColor colorWithHexString:@"FFA800"];
    }else if ([level isEqualToString:@"2"]) {
        textColor = [UIColor colorWithHexString:@"FC7D0E"];
    }else if ([level isEqualToString:@"1"]) {
        textColor = [UIColor colorWithHexString:@"F62546"];
    }
    
    //紧急
    return textColor;
}


- (NSString *)getLevelImage:(NSString *)level {
    NSString *levelString = @"level_normal";
    
    if ([level isEqualToString:@"0"]) {
        levelString = @"level_normal";
    }else if ([level isEqualToString:@"4"]) {
        levelString = @"level_prompt";
    }else if ([level isEqualToString:@"3"]) {
        levelString = @"level_ciyao";
    }else if ([level isEqualToString:@"2"]) {
        levelString = @"level_important";
    }else if ([level isEqualToString:@"1"]) {
        levelString = @"level_jinji";
    }
    
    //紧急
    return levelString;
}

- (NSString *)changeIconImage:(NSString *)icon {
    NSString *iconImage = @"level_normal";
    return iconImage;
}
@end
