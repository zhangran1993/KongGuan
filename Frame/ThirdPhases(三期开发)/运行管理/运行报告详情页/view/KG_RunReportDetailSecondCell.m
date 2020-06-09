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
        
        return self.model.autoAlarm.count;
    }else {
        return self.model.manualAlarm.count;
    }
    return   2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        NSDictionary *dic = self.model.autoAlarm[indexPath.row];
        NSString *str = [NSString stringWithFormat:@"%d.%@%@",(int)indexPath.row +1,safeString(dic[@"name"]),safeString(dic[@"description"])];
        CGRect fontRect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40-26, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
        NSLog(@"%f",fontRect.size.height);
        return fontRect.size.height +24;
        
    }else {
        NSDictionary *dic = self.model.manualAlarm[indexPath.row];
        NSString *str = [NSString stringWithFormat:@"%d.%@",(int)indexPath.row +1,safeString(dic[@"recordDescription"])];
        CGRect fontRect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40-26, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
        NSLog(@"%f",fontRect.size.height);
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
        NSDictionary *dic = self.model.autoAlarm[indexPath.row];
        NSString *str = [NSString stringWithFormat:@"%d.%@%@",(int)indexPath.row +1,safeString(dic[@"name"]),safeString(dic[@"description"])];
        cell.string = str;
    }else {
        NSDictionary *dic = self.model.manualAlarm[indexPath.row];
        NSString *str = [NSString stringWithFormat:@"%d.%@",(int)indexPath.row +1,safeString(dic[@"recordDescription"])];
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
