//
//  KG_RunManagerThirdCell.m
//  Frame
//
//  Created by zhangran on 2020/6/4.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunManagerThirdCell.h"
#import "KG_RunReportCell.h"
#import "UILabel+ChangeFont.h"
#import "UIFont+Addtion.h"
#import "FMFontManager.h"
#import "ChangeFontManager.h"
@interface KG_RunManagerThirdCell ()<UITableViewDelegate,UITableViewDataSource>{
    
    
}
@property (nonatomic, strong)  UIView    *runReprtView;//运行报告View

@property (nonatomic, strong)  UITableView *runReportTableView;//3
@end

@implementation KG_RunManagerThirdCell

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
   
}

- (void)setJiaoJieBanInfo:(NSDictionary *)jiaoJieBanInfo {
    _jiaoJieBanInfo = jiaoJieBanInfo;
}
- (void)setStationRunReportArr:(NSArray *)stationRunReportArr {
    _stationRunReportArr = stationRunReportArr;
    [self setUpRunReportView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    
   if ([tableView isEqual:self.runReportTableView]) {
        
        KG_RunReportCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunReportCell"];
        if (cell == nil) {
            cell = [[KG_RunReportCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunReportCell"];
        }
        cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dataDic = self.stationRunReportArr[indexPath.row];
        cell.dataDic = dataDic;
        
        return cell;
   }
    return nil;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
     if ([tableView isEqual:self.runReportTableView]) {
        return self.stationRunReportArr.count;
    }
    return 0;
}


- (void)setUpRunReportView {
    
    [self.runReprtView removeFromSuperview];
    self.runReprtView = nil;
    self.runReprtView =  [[UIView alloc]init];
    [_runReportTableView removeFromSuperview];
    _runReportTableView = nil;
    [self addSubview:self.runReprtView];
    NSInteger tableHeight = 80 *self.stationRunReportArr.count;
    [self.runReprtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@(55+ tableHeight +70));
    }];
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor colorWithHexString:@"#2A6EFD"];
    [self.runReprtView addSubview:leftView];
    leftView.layer.cornerRadius = 2;
    leftView.layer.masksToBounds = YES;
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.runReprtView.mas_left).offset(16);
        make.width.equalTo(@4);
        make.top.equalTo(self.mas_top).offset(22);
        make.height.equalTo(@15);
    }];
    
    UILabel *stationReportLabel = [[UILabel alloc]init];
    [self.runReprtView addSubview:stationReportLabel];
    stationReportLabel.text = @"台站运行报告";
    stationReportLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    stationReportLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    stationReportLabel.font = [UIFont my_font:16];
    [stationReportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right).offset(8);
        make.centerY.equalTo(leftView.mas_centerY);
        make.width.equalTo(@200);
    }];
    
    UIButton *reportRightBtn = [[UIButton alloc]init];
    [reportRightBtn setImage:[UIImage imageNamed:@"common_right"] forState:UIControlStateNormal];
    [self.runReprtView addSubview:reportRightBtn];
    [reportRightBtn addTarget:self action:@selector(reportRightMethod) forControlEvents:UIControlEventTouchUpInside];
    [reportRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.centerY.equalTo(stationReportLabel.mas_centerY);
        make.right.equalTo(self.runReprtView.mas_right).offset(-26);
    }];
    
    [self.runReprtView addSubview:self.runReportTableView];
   
    [self.runReportTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.runReprtView.mas_left).offset(16);
        make.height.equalTo(@(tableHeight));
        make.right.equalTo(self.runReprtView.mas_right).offset(-16);
        make.top.equalTo(reportRightBtn.mas_bottom).offset(15);
    }];
    [self.runReportTableView reloadData];
   
}

- (UITableView *)runReportTableView {
    if (!_runReportTableView) {
        _runReportTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _runReportTableView.delegate = self;
        _runReportTableView.dataSource = self;
        _runReportTableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _runReportTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _runReportTableView.scrollEnabled = YES;
        
        
    }
    return _runReportTableView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:self.runReportTableView]) {
        return 80;
    }
    return 50;
    
  
}

- (void)reportRightMethod {
    if (self.runReportBlockMethod) {
        self.runReportBlockMethod();
    }
}

- (void)jiebanMethod {
    if (self.jiebanBlockMethod) {
        self.jiebanBlockMethod();
    }
}

- (void)jiaobanMethod {
    if (self.jiaobanBlockMethod) {
        self.jiaobanBlockMethod();
    }
}

- (void)CreateReportMethod {
    if (self.createReportBlockMethod) {
        self.createReportBlockMethod();
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dataDic = self.stationRunReportArr[indexPath.row];
    if (self.gotoDetailBlockMethod) {
        self.gotoDetailBlockMethod(dataDic);
    }
}

- (void)setModel:(KG_RunManagerDetailModel *)model {
    _model = model;
}
@end
