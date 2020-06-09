//
//  KG_RunReportDetailThirdCell.m
//  Frame
//
//  Created by zhangran on 2020/6/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunReportDetailThirdCell.h"
#import "KG_RunReportDetailCommonCell.h"
@interface  KG_RunReportDetailThirdCell()<UITableViewDelegate,UITableViewDataSource>{
    
}


@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *dataArray;


@end
@implementation KG_RunReportDetailThirdCell

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
    iconImage.image = [UIImage imageNamed:@"runReport_deviceTryIcon"];
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
    titleLabel.text = @"设备调整调试情况";
    [tableHeadView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(iconImage.mas_right).offset(4);
        make.top.equalTo(tableHeadView.mas_top).offset(16);
        make.width.equalTo(@250);
        make.height.equalTo(@24);
    }];
   
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
    return self.dataArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return   1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.model.changeManagement[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%d.%@",(int)indexPath.row +1,safeString(dic[@"title"])];
    CGRect fontRect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, 200) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
    NSLog(@"%f",fontRect.size.height);
    
    return fontRect.size.height +24;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_RunReportDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailCommonCell"];
    if (cell == nil) {
        cell = [[KG_RunReportDetailCommonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailCommonCell"];
    }
    NSDictionary *dic = self.model.changeManagement[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%d.%@",(int)indexPath.row +1,safeString(dic[@"recordDescription"])];
    cell.string = str;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.001f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    headView.backgroundColor = [UIColor whiteColor];
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 24)];
    
    return headView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 24.f;
}

- (void)setModel:(KG_RunReportDeatilModel *)model {
    _model = model;
    
       [self.tableView reloadData];
}


@end
