//
//  KG_RadarEnvCell.m
//  Frame
//
//  Created by zhangran on 2020/4/26.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_WeiHuContentSecondCell.h"
#import "KG_WeihuContentThirdCell.h"
@interface KG_WeiHuContentSecondCell ()<UITableViewDelegate,UITableViewDataSource>{
    
}

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSArray *dataArray;

@end

@implementation KG_WeiHuContentSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if([super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        
        [self createUI];
    }
    
    return self;
}



- (void)createUI{
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];

}

- (UIImage*)createImageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}



- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
       
    }
    return _tableView;
}
- (NSArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSArray alloc] init];
    }
    return _dataArray;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary *dic = self.dataArray[section];
    NSArray *arr = dic[@"childrens"];
    return arr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
   return self.dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KG_WeihuContentThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_WeihuContentThirdCell"];
    if (cell == nil) {
        cell = [[KG_WeihuContentThirdCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_WeihuContentThirdCell"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    self.dataArray = self.dataDic[indexPath.section];
    NSDictionary *dic = self.dataArray[indexPath.section];
    NSArray *arr = dic[@"childrens"];
    NSDictionary *detailDic = arr[indexPath.row];
    cell.dataDic = detailDic;
   
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
  
    return  40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    headView.backgroundColor = [UIColor whiteColor];
  
    UIImageView *iconImage = [[UIImageView alloc]init];
    [headView addSubview:iconImage];
    iconImage.layer.cornerRadius = 2.5f;
   
    iconImage.layer.masksToBounds = YES;
    iconImage.backgroundColor = [UIColor colorWithHexString:@"#BABCC4"];
    [iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY);
        make.left.equalTo(headView.mas_left).offset(36);
        make.width.height.equalTo(@5);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
 
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.numberOfLines = 1;
    self.titleLabel.textAlignment = NSTextAlignmentLeft;
    [headView addSubview:self.titleLabel];
    NSDictionary *dic = self.dataArray[section];
    self.titleLabel.text = safeString(dic[@"equipmentName"]);
    if (safeString(dic[@"equipmentName"]).length == 0) {
        self.titleLabel.text = safeString(dic[@"title"]);
    }
    
    [self.titleLabel  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headView.mas_centerY);
        make.left.equalTo(iconImage.mas_right).offset(8);
        make.height.equalTo(headView.mas_height);
        make.right.equalTo(headView.mas_right).offset(-20);
    }];
    
    
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.001)];
   
    return footView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40.f;
}
- (void)setSecondString:(NSString *)secondString {
    _secondString = secondString;
}
- (void)setDataDic:(NSDictionary *)dataDic {
   
    _dataDic = dataDic;
//    self.dataArray = dataDic[@"childrens"];
    
    
}
- (void)setRowCount:(NSInteger)rowCount {
    _rowCount = rowCount;
}

- (void)setListArray:(NSArray *)listArray {
    _listArray = listArray;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dataDic  in listArray) {
        if (![dataDic[@"cardDisplay"] boolValue]) {
            [arr addObject:dataDic];
        }
    }
    self.dataArray = arr;
    [self.tableView reloadData];
}
@end
