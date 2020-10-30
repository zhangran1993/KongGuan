//
//  KG_CaseLibraryDetailFirstCell.m
//  Frame
//
//  Created by zhangran on 2020/10/15.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_CaseLibraryDetailThirdCell.h"
#import "KG_CaseLibraryDetailReasonCell.h"
@interface KG_CaseLibraryDetailThirdCell () <UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong)  UITableView        *tableView;

@property (nonatomic, strong)  NSArray            *dataArray;

@property (nonatomic ,strong)     UIView          *centerView;

@property (nonatomic ,strong)     UILabel         *titleLabel;

@property (nonatomic ,strong)     UIImageView     *iconImage;


@end
@implementation KG_CaseLibraryDetailThirdCell

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
    
    self.centerView = [[UIView alloc]init];
    self.centerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top).offset(5);
        make.height.equalTo(@110);
    }];
    self.centerView.layer.cornerRadius = 10.f;
    self.centerView.layer.masksToBounds = YES;
    self.centerView.layer.shadowOffset = CGSizeMake(0,2);
    self.centerView.layer.shadowOpacity = 1;
    self.centerView.layer.shadowRadius = 2;

    self.iconImage = [[UIImageView alloc]init];
    [self.centerView addSubview:self.iconImage];
    self.iconImage.image = [UIImage imageNamed:@"kg_anliku_reason"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(15);
        make.top.equalTo(self.centerView.mas_top).offset(14);
       
        make.width.height.equalTo(@18);
    }];
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"可能原因分析";
    self.titleLabel.numberOfLines = 1;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(7);
        make.width.equalTo(@200);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.height.equalTo(@20);
    }];
    [self.centerView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(9);
        make.left.equalTo(self.centerView.mas_left);
        make.right.equalTo(self.centerView.mas_right);
        make.bottom.equalTo(self.centerView.mas_bottom);
    }];
    [self.tableView reloadData];
  
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
     return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_CaseLibraryDetailReasonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_CaseLibraryDetailReasonCell"];
    if (cell == nil) {
        cell = [[KG_CaseLibraryDetailReasonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_CaseLibraryDetailReasonCell"];
    }
//    NSDictionary *dic = self.dataArray[indexPath.row];
//    cell.dic = dic;
    
    cell.reasonStr = safeString(self.dataModel.reason);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)buttonClickMethod:(UIButton *)btn {
    self.hidden = YES;
}

//将时间戳转换为时间字符串
- (NSString *)timestampToTimeStr:(NSString *)timestamp {
    if (isSafeObj(timestamp)==NO) {
        return @"-/-";
    }
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp.integerValue/1000];
    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd HH:mm:ss"] stringFromDate:date];
    //    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd"] stringFromDate:date];
    return timeStr;
    
}
- (NSDateFormatter *)dateFormatWith:(NSString *)formatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:formatStr];//@"YYYY-MM-dd HH:mm:ss"
    //设置时区
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    return formatter;
}

- (void)setDataModel:(KG_CaseLibraryDetailModel *)dataModel {
    _dataModel = dataModel;
    [self.tableView reloadData];
  
    
}

@end
