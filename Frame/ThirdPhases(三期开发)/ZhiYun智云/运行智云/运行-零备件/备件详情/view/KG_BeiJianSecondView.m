//
//  KG_BeiJianFirstView.m
//  Frame
//
//  Created by zhangran on 2020/7/31.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_BeiJianSecondView.h"
#import "KG_BeiJianDetailCell.h"
@interface KG_BeiJianSecondView ()<UITableViewDelegate,UITableViewDataSource>{
    

}


@property (nonatomic,strong)    UITableView             *tableView;

@property (nonatomic,strong)    NSMutableArray          *dataArray;

@end

@implementation KG_BeiJianSecondView


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
       
    }
    return self;
}
//初始化数据
- (void)initData {
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH- 32, 250)];
    [self addSubview:bgView];

  
    [bgView addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(bgView.mas_top);
        make.left.equalTo(bgView.mas_left);
        make.right.equalTo(bgView.mas_right);
        make.bottom.equalTo(bgView.mas_bottom);
    }];
    
    
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
    
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSDictionary *dataDic = self.dataArray[indexPath.row];
   
    return 50;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_BeiJianDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_BeiJianDetailCell"];
    if (cell == nil) {
        cell = [[KG_BeiJianDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_BeiJianDetailCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.titleLabel.text = @"序列号";
        cell.detailLabel.text = safeString(self.dataDic[@"serialNumber"]);
        cell.detailLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    }else if (indexPath.row == 1) {
        cell.titleLabel.text = @"编号";
        cell.detailLabel.text = safeString(self.dataDic[@"code"]);
        cell.detailLabel.textColor = [UIColor colorWithHexString:@"#626470"];
        
    }else if (indexPath.row == 2) {
        cell.titleLabel.text = @"部件号";
        cell.detailLabel.text = safeString(self.dataDic[@"partNumber"]);
        cell.detailLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    }else if (indexPath.row == 3) {
        cell.titleLabel.text = @"存放地点";
        cell.detailLabel.text = safeString(self.dataDic[@"storageLocation"]);
        cell.detailLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    }else if (indexPath.row == 4) {
        cell.titleLabel.text = @"入库时间";
        cell.detailLabel.text = [self timestampToTimeStr:safeString(self.dataDic[@"time"])];
        cell.detailLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    }
    
    
    return cell;
    
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.tableView reloadData];
  
}

- (void)setCategoryString:(NSString *)categoryString {
    _categoryString = categoryString;
    [self.tableView reloadData];
}
//将时间戳转换为时间字符串
- (NSString *)timestampToTimeStr:(NSString *)timestamp {
    if (isSafeObj(timestamp)==NO) {
        return @"-/-";
    }
    NSDate *date=[NSDate dateWithTimeIntervalSince1970:timestamp.integerValue/1000];
    NSString *timeStr=[[self dateFormatWith:@"YYYY-MM-dd HH:mm"] stringFromDate:date];
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
