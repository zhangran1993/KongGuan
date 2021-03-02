//
//  KG_RunReportDetailThirdCell.m
//  Frame
//
//  Created by zhangran on 2020/6/2.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunReportDetailSeventhCell.h"
#import "KG_RunReportDetailCommonCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface  KG_RunReportDetailSeventhCell()<UITableViewDelegate,UITableViewDataSource>{
    
}


@property (nonatomic, strong) UITableView *tableView;


@property (nonatomic, strong) NSArray *dataArray;


@end
@implementation KG_RunReportDetailSeventhCell

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
    iconImage.image = [UIImage imageNamed:@"runReport_contentIcon"];
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
    titleLabel.text = @"其他内容补充";
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



#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return   1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *str = self.model.info[@"manualAlarmContent"];
    CGRect fontRect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 40-26, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
    NSLog(@"%f",fontRect.size.height);
    if([self.pushType isEqualToString:@"create"]) {
        
       return fontRect.size.height+26 +30;
    }
    if (str.length == 0) {
        return 0;
    }
    return fontRect.size.height+26;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KG_RunReportDetailCommonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportDetailCommonCell"];
    if (cell == nil) {
        cell = [[KG_RunReportDetailCommonCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportDetailCommonCell"];
    }
   
    NSString *str = safeString(self.model.info[@"description"]);
    cell.string  =str;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textString = ^(NSString * _Nonnull textStr) {
        if (self.textString) {
            self.textString(textStr);
        }
    };
     if ([self.pushType isEqualToString:@"create"]) {
         cell.textView.userInteractionEnabled = YES;
     }else {
         cell.textView.userInteractionEnabled = NO;
     }
    return cell;
}



- (void)setModel:(KG_RunReportDeatilModel *)model {
    _model = model;
    
   
   
}
- (void)setPushType:(NSString *)pushType {
    _pushType = pushType;
    [self.tableView reloadData];
}
@end
