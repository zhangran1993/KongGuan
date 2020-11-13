//
//  KG_InstrumentationDetailFifthCell.m
//  Frame
//
//  Created by zhangran on 2020/9/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_InstrumentationDetailFifthCell.h"
#import "KG_InstrumentationDetailContentFifthCell.h"
@interface  KG_InstrumentationDetailFifthCell() <UITableViewDelegate,UITableViewDataSource>{
    
    
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
@end

@implementation KG_InstrumentationDetailFifthCell

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
//    self.centerView.layer.shadowOffset = CGSizeMake(0,2);
//    self.centerView.layer.shadowOpacity = 1;
//    self.centerView.layer.shadowRadius = 2;
    
    
    
    self.iconImage = [[UIImageView alloc]init];
    [self.centerView addSubview:self.iconImage];
    self.iconImage.image = [UIImage imageNamed:@"kg_guideDoc"];
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
    self.titleLabel.text = @"操作说明文档";
    self.titleLabel.numberOfLines = 2;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconImage.mas_right).offset(7);
        make.width.equalTo(@120);
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
    
    
    self.tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-32, 40)];
    
    self.footBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-32, 40)];
    [self.footBtn setTitle:@"收起" forState:UIControlStateNormal];
    if (self.shouqi) {
        [self.footBtn setTitle:@"展开" forState:UIControlStateNormal];
    }
    self.footBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.footBtn setTitleColor:[UIColor colorWithHexString:@"#1860B0"] forState:UIControlStateNormal];
    [self.footBtn addTarget:self action:@selector(zhankaiMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.footBtn setImage:[UIImage imageNamed:@"shouqi_icon"] forState:UIControlStateNormal];
    if (self.shouqi) {
        
        [self.footBtn setImage:[UIImage imageNamed:@"zhankai"]  forState:UIControlStateNormal];
    }
    [self.footBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 70, 0,0 )];
    [self.tableHeadView addSubview:self.footBtn];
    
}
- (void)zhankaiMethod :(UIButton *)button {
    self.firstEnter = YES;
    
    if (self.shouqi) {
        self.shouqi = NO;
        if (self.changeShouQiBlock) {
            self.changeShouQiBlock(self.shouqi);
        }
 
    }else {
        self.shouqi = YES;

        if (self.changeShouQiBlock) {
            self.changeShouQiBlock(self.shouqi);
        }
        
    }
    
    if (self.shouqi) {
        [self.footBtn setTitle:@"展开" forState:UIControlStateNormal];
         [self.footBtn setImage:[UIImage imageNamed:@"zhankai"]  forState:UIControlStateNormal];
    }else {
        [self.footBtn setImage:[UIImage imageNamed:@"shouqi_icon"] forState:UIControlStateNormal];
        [self.footBtn setTitle:@"收起" forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

- (void)setDataModel:(KG_InstrumentationDetailModel *)dataModel {
    _dataModel = dataModel;
    
    self.dataArray = self.dataModel.fileList;
    self.tableView.tableFooterView = self.tableHeadView;
    
    if (!self.firstEnter) {
        
        if (self.dataArray.count >2) {
            self.shouqi = YES;
            
        }else {
            self.shouqi = NO;
            
        }
        if (self.shouqi) {
            [self.footBtn setTitle:@"展开" forState:UIControlStateNormal];
            [self.footBtn setImage:[UIImage imageNamed:@"zhankai"]  forState:UIControlStateNormal];
        }else {
            [self.footBtn setImage:[UIImage imageNamed:@"shouqi_icon"] forState:UIControlStateNormal];
            [self.footBtn setTitle:@"收起" forState:UIControlStateNormal];
        }
        [self.tableView reloadData];
        return;
    }

    
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
    if (self.shouqi) {
        return 2;
    }
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_InstrumentationDetailContentFifthCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_InstrumentationDetailContentFifthCell"];
    if (cell == nil) {
        cell = [[KG_InstrumentationDetailContentFifthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_InstrumentationDetailContentFifthCell"];
    }
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    cell.dataDic = dataDic;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
  
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    
    if(self.pushToNextStep){
        self.pushToNextStep(dataDic);
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


@end
