//
//  KG_InstrumentationDetailFifthCell.m
//  Frame
//
//  Created by zhangran on 2020/9/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_StationFileEnvEventRecordCell.h"
#import "KG_EquipmentHistoryDetailFourthCell.h"
@interface  KG_StationFileEnvEventRecordCell() <UITableViewDelegate,UITableViewDataSource>{
    
    
}

@property (nonatomic, strong)     UITableView        *tableView;

@property (nonatomic, strong)     NSArray            *dataArray;

@property (nonatomic ,strong)     UIView             *centerView;

@property (nonatomic ,strong)     UIImageView        *iconImage;

@property (nonatomic ,strong)     UILabel            *titleLabel;

@property (nonatomic ,strong)     UIView             *tableHeadView;

@property (nonatomic ,assign)     BOOL               shouqi;

@property (nonatomic ,assign)     BOOL               firstEnter;

@property (nonatomic ,strong)     UIButton           *footBtn;

@property (nonatomic ,strong)     UIButton           *rightBtn;
@end

@implementation KG_StationFileEnvEventRecordCell

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
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.centerView.layer.cornerRadius = 10.f;
    self.centerView.layer.masksToBounds = YES;
    self.centerView.layer.shadowOffset = CGSizeMake(0,2);
    self.centerView.layer.shadowOpacity = 1;
    self.centerView.layer.shadowRadius = 2;
    
    
    
    self.iconImage = [[UIImageView alloc]init];
    [self.centerView addSubview:self.iconImage];
    self.iconImage.image = [UIImage imageNamed:@"kg_stationEnveeventRecord"];
    [self.iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(15);
        make.top.equalTo(self.centerView.mas_top).offset(14);
        
        make.width.height.equalTo(@18);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.titleLabel];
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    self.titleLabel.text = @"台站关键环境事件记录";
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(7);
        make.right.equalTo(self.centerView.mas_right).offset(-50);
        make.centerY.equalTo(self.iconImage.mas_centerY);
        make.height.equalTo(@45);
    }];
    [self.centerView addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_top).offset(48);
        make.left.equalTo(self.centerView.mas_left);
        make.right.equalTo(self.centerView.mas_right);
        make.bottom.equalTo(self.centerView.mas_bottom);
    }];
    
    self.rightBtn = [[UIButton alloc]init];
    self.rightBtn.hidden = YES;
    [self.centerView addSubview:self.rightBtn];
    [self.rightBtn setImage: [UIImage imageNamed:@"common_right"] forState:UIControlStateNormal];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.right.equalTo(self.centerView.mas_right).offset(-10);
        make.centerY.equalTo(self.titleLabel.mas_centerY);
    }];
    
    
    self.tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    
//    UIView *lineView = [[UIView alloc]init];
//    [self.tableHeadView addSubview:lineView];
//    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
//    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.tableHeadView.mas_left).offset(16);
//        make.right.equalTo(self.tableHeadView.mas_right).offset(-16);
//        make.height.equalTo(@1);
//        make.top.equalTo(self.tableHeadView.mas_top);
//    }];
    
    
    self.footBtn = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/4, 0, SCREEN_WIDTH/2, 40)];
    [self.footBtn setTitle:@"更多" forState:UIControlStateNormal];
   
    self.footBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.footBtn setTitleColor:[UIColor colorWithHexString:@"#1860B0"] forState:UIControlStateNormal];
    [self.footBtn addTarget:self action:@selector(moreMethod:) forControlEvents:UIControlEventTouchUpInside];
   
    [self.tableHeadView addSubview:self.footBtn];
   
    self.tableView.tableFooterView = self.tableHeadView;
    
}

- (void)moreMethod:(UIButton *)button {
    if(self.moreMethodBlock){
        self.moreMethodBlock(safeString(self.titleLabel.text));
    }
        
}

- (void)setDataModel:(KG_EquipmentHistoryModel *)dataModel {
    _dataModel = dataModel;
    
    self.dataArray = self.dataModel.fileList;
    self.tableView.tableFooterView = self.tableHeadView;
    
    [self.tableView reloadData];
   
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataArray.count >2) {
        return 2;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_EquipmentHistoryDetailFourthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_EquipmentHistoryDetailFourthCell"];
    if (cell == nil) {
        cell = [[KG_EquipmentHistoryDetailFourthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_EquipmentHistoryDetailFourthCell"];
    }
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    cell.dataDic = dataDic;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    if (self.pushToNextStep) {
        self.pushToNextStep(self.titleLabel.text,dataDic);
    }
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

- (void)setCurrSection:(NSInteger)currSection {
    _currSection = currSection;
    self.titleLabel.text = @"台站关键环境事件记录";
    self.rightBtn.hidden = YES;
   
    
}


- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    
}


- (void)setListArray:(NSArray *)listArray {
    _listArray = listArray;
    self.dataArray = listArray;
    [self.tableView reloadData];
}
@end
