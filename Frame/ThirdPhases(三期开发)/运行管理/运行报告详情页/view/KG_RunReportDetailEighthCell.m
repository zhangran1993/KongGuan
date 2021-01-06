//
//  KG_RunReportDetailThirdCell.m
//  Frame
//
//  Created by zhangran on 2020/6/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunReportDetailEighthCell.h"
#import "KG_RunReportDetailJiaoJieBanCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface  KG_RunReportDetailEighthCell()<UITableViewDelegate,UITableViewDataSource>{
    
}


@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSMutableArray *dataArray;


@end
@implementation KG_RunReportDetailEighthCell

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
    iconImage.image = [UIImage imageNamed:@"runReport_JiaoJieBanRecordIcon"];
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
    titleLabel.font = [UIFont my_font:14];
    titleLabel.text = @"交接班记录";
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
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



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return   self.model.changeShifts.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_RunReportDetailJiaoJieBanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailJiaoJieBanCell"];
    if (cell == nil) {
        cell = [[KG_RunReportDetailJiaoJieBanCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailJiaoJieBanCell"];
    }
    NSDictionary *dic = self.model.changeShifts[indexPath.row];
    cell.dic = dic;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}




- (void)setModel:(KG_RunReportDeatilModel *)model {
    _model = model;
    [self.tableView reloadData];
}

@end
