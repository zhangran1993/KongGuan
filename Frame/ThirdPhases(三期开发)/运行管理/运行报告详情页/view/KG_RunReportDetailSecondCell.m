//
//  KG_RunReportDetailThirdCell.m
//  Frame
//
//  Created by zhangran on 2020/6/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunReportDetailSecondCell.h"
#import "KG_RunReportDetailCommonCell.h"
@interface  KG_RunReportDetailSecondCell()<UITableViewDelegate,UITableViewDataSource>{
    
}


@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *dataArray;


@end
@implementation KG_RunReportDetailSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviewsView];
    }
    return self;
}

- (void)createSubviewsView {
    
    [self addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    UIView *tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
    self.tableView.tableHeaderView = tableHeadView;
    
    UIImageView *iconImage = [[UIImageView alloc]init];
    [tableHeadView addSubview:iconImage];
    iconImage.image = [UIImage imageNamed:@"runReport_happenResultIcon"];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tableHeadView.mas_left).offset(16);
        make.top.equalTo(tableHeadView.mas_top).offset(21);
        make.width.height.equalTo(@16);
    }];
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    titleLabel.text = @"设备发生问题及处理情况";
    [tableHeadView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImage.mas_right).offset(4);
        make.top.equalTo(tableHeadView.mas_top).offset(16);
        make.width.equalTo(@250);
        make.height.equalTo(@24);
    }];
 
    [self.tableView reloadData];
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
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}



#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0 ){
        
        return 1;
    }else {
        return 1;
    }
    return   2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        NSString *str = self.model.info[@"autoAlarmContent"];
        if (safeString(self.model.info[@"autoAlarmContent"]).length== 0) {
            return 0;
        }
        CGRect fontRect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40-26, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
        NSLog(@"%f",fontRect.size.height);
        
        
        return fontRect.size.height +24;
        
    }else {
        NSString *str = self.model.info[@"manualAlarmContent"];
        CGRect fontRect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40-26, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
        NSLog(@"%f",fontRect.size.height);
        if (safeString(self.model.info[@"manualAlarmContent"]).length== 0) {
            return 0;
        }
        return fontRect.size.height+24;
    }
//    CGRect fontRect = [dic[@"content"] boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
//    NSLog(@"%f",fontRect.size.height);
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_RunReportDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailCommonCell"];
    if (cell == nil) {
        cell = [[KG_RunReportDetailCommonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailCommonCell"];
    }
    if (indexPath.section == 0) {
        NSString *str = self.model.info[@"autoAlarmContent"];

        cell.string = str;
    }else {
        NSString *str = self.model.info[@"manualAlarmContent"];
       
        cell.string = str;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44.f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *leftImage = [[UIImageView alloc]init];
    leftImage.backgroundColor = [UIColor colorWithHexString:@"#447AF1"];
    [headView addSubview:leftImage];
    leftImage.layer.cornerRadius = 2;
    leftImage.layer.masksToBounds = YES;
    [leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headView.mas_left).offset(26);
        make.centerY.equalTo(headView.mas_centerY);
        make.width.equalTo(@4);
        make.height.equalTo(@16);
    }];
    UILabel *titleLabel = [[UILabel alloc]init];
    [headView addSubview:titleLabel];
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:14];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftImage.mas_right).offset(6);
        make.top.equalTo(headView.mas_top);
        make.height.equalTo(headView.mas_height);
        make.width.equalTo(@200);
    }];
    
    if (section == 0) {
        titleLabel.text = @"设备实时监控";
    }else {
        titleLabel.text = @"运行事件";
    }
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH,0.01)];
    
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.01f;
}


- (void)setModel:(KG_RunReportDeatilModel *)model {
    _model = model;
    [self.tableView reloadData];
}



@end
