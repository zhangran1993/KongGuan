//
//  KG_InstrumentationDetailCell.m
//  Frame
//
//  Created by zhangran on 2020/9/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_InstrumentationDetailSecondCell.h"
#import "KG_InstrumentationContentCell.h"
@interface KG_InstrumentationDetailSecondCell ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong)     UITableView        *tableView;

@property (nonatomic, strong)     NSMutableArray     *dataArray;

@property (nonatomic ,strong)     UIView             *centerView;

@end

@implementation KG_InstrumentationDetailSecondCell

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
    
    [self.dataArray addObject:@"序列号"];
    [self.dataArray addObject:@"校验批次"];
    [self.dataArray addObject:@"校验周期"];
    [self.dataArray addObject:@"存放地点"];
    [self.dataArray addObject:@"投产时间"];
    
  
    
    self.centerView = [[UIView alloc]init];
    self.centerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self addSubview:self.centerView];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.right.equalTo(self.mas_right).offset(-16);
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.centerView.layer.cornerRadius = 10.f;
    self.centerView.layer.masksToBounds = YES;
//    self.centerView.layer.shadowOffset = CGSizeMake(0,2);
//    self.centerView.layer.shadowOpacity = 1;
//    self.centerView.layer.shadowRadius = 2;
//    
    [self.centerView addSubview:self.tableView];
   
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_top);
        make.left.equalTo(self.centerView.mas_left);
        make.right.equalTo(self.centerView.mas_right);
        make.bottom.equalTo(self.centerView.mas_bottom);
    }];
    
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    
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
    
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_InstrumentationContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_InstrumentationContentCell"];
    if (cell == nil) {
        cell = [[KG_InstrumentationContentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_InstrumentationContentCell"];
    }
//    NSDictionary *dic = self.dataArray[indexPath.section];
//    cell.dic = dic;
    
    if(indexPath.row == 0) {
        
        cell.detailLabel.text = safeString(self.dataModel.serialNumber);
    }else if(indexPath.row == 1) {
        cell.detailLabel.text = [self getBatahStr:safeString(self.dataModel.batch)];
        
    }else if(indexPath.row == 2) {
        cell.detailLabel.text = safeString(self.dataModel.cycle);
        
    }else if(indexPath.row == 3) {
        cell.detailLabel.text = safeString(self.dataModel.stockLocation);
        
    }else if(indexPath.row == 4) {
        cell.detailLabel.text = [self timestampToTimeStr:safeString(self.dataModel.productTime)];
    }
    cell.titleLabel.text = safeString(self.dataArray[indexPath.row]);
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
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


-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)setDataModel:(KG_InstrumentationDetailModel *)dataModel {
    _dataModel = dataModel;
    [self.tableView reloadData];
    
}

- (NSString *)getBatahStr:(NSString *)batch {
    
    NSString *ss = @"一批次";
    if([batch isEqualToString:@"oneBatch"]){
        ss = @"一批次";
    }else if([batch isEqualToString:@"twoBatch"]){
        ss = @"二批次";
    }else if([batch isEqualToString:@"threeBatch"]){
        ss = @"三批次";
    }
    return ss;
        
}
@end
