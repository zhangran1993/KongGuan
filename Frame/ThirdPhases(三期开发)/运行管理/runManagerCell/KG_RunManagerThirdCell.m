//
//  KG_RunManagerThirdCell.m
//  Frame
//
//  Created by zhangran on 2020/6/4.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunManagerThirdCell.h"
#import "KG_RunReportCell.h"
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
    [stationReportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right).offset(8);
        make.centerY.equalTo(leftView.mas_centerY);
        make.width.equalTo(@150);
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
    UIView *createReportView = [[UIView alloc]init];
    [self.runReprtView addSubview:createReportView];
    [createReportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@147);
        make.height.equalTo(@37);
        make.left.equalTo(self.runReprtView.mas_left).offset(16);
        make.top.equalTo(self.runReportTableView.mas_bottom).offset(16);
    }];
    createReportView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    createReportView.layer.cornerRadius = 20;
    createReportView.layer.masksToBounds = YES;
    
    UIImageView *createIcon = [[UIImageView alloc]init];
    [createReportView addSubview:createIcon];
    createIcon.image = [UIImage imageNamed:@"run_createIcon"];
    [createIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@16);
        make.height.equalTo(@19);
        make.left.equalTo(createReportView.mas_left).offset(13);
        make.centerY.equalTo(createReportView.mas_centerY);
    }];
    
    UILabel *createReportLabel = [[UILabel alloc]init];
    [createReportView addSubview:createReportLabel];
    createReportLabel.text = @"生成运行报告";
    createReportLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    createReportLabel.font = [UIFont systemFontOfSize:16];
    [createReportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(createIcon.mas_right).offset(6);
        make.centerY.equalTo(createIcon.mas_centerY);
        make.right.equalTo(createReportView.mas_right).offset(-6);
        make.height.equalTo(@22);
    }];
    
    UIButton *createReportBtn = [[UIButton alloc]init];
    [createReportBtn setBackgroundColor:[UIColor clearColor]];
    [createReportView addSubview:createReportBtn];
    [createReportBtn addTarget:self action:@selector(CreateReportMethod) forControlEvents:UIControlEventTouchUpInside];
    [createReportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(createReportView.mas_height);
        make.centerY.equalTo(createReportView.mas_centerY);
        make.left.equalTo(createReportView.mas_left);
        make.right.equalTo(createReportView.mas_right);
    }];
    
    UIButton *jiaobanBtn  = [[UIButton alloc]init];
    [jiaobanBtn setBackgroundColor:[UIColor clearColor]];
    jiaobanBtn.layer.borderWidth = 1;
    jiaobanBtn.layer.borderColor = [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0].CGColor;
    [jiaobanBtn setTitle:@"交班"  forState:UIControlStateNormal];
    jiaobanBtn.layer.cornerRadius = 20;
    jiaobanBtn.layer.masksToBounds = YES;
    [jiaobanBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    jiaobanBtn.titleLabel.font  = [UIFont systemFontOfSize:16];
    [self.runReprtView addSubview:jiaobanBtn];
    [jiaobanBtn addTarget:self action:@selector(jiaobanMethod) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *jiebanBtn  = [[UIButton alloc]init];
    [jiebanBtn setBackgroundColor:[UIColor clearColor]];
    jiebanBtn.layer.borderWidth = 1;
    jiebanBtn.layer.cornerRadius = 20;
    jiebanBtn.titleLabel.font  = [UIFont systemFontOfSize:16];
    [jiebanBtn setTitle:@"接班"  forState:UIControlStateNormal];
    jiebanBtn.layer.masksToBounds = YES;
    jiebanBtn.layer.borderColor = [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0].CGColor;
    [jiebanBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    jiaobanBtn.titleLabel.font  = [UIFont systemFontOfSize:16];
    [self.runReprtView addSubview:jiebanBtn];
    [jiebanBtn addTarget:self action:@selector(jiebanMethod) forControlEvents:UIControlEventTouchUpInside];
    [jiebanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@37);
        make.centerY.equalTo(createReportView.mas_centerY);
        make.width.equalTo(@64);
        make.right.equalTo(self.runReprtView.mas_right).offset(-16);
    }];
    [jiaobanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@37);
        make.centerY.equalTo(createReportView.mas_centerY);
        make.right.equalTo(jiebanBtn.mas_left).offset(-9);
        make.width.equalTo(@64);
    }];
    //是否为接班人
    if([self.jiaoJieBanInfo[@"isSuccessor"] boolValue]) {
        jiebanBtn.layer.borderColor =  [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0].CGColor;
        [jiebanBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
        jiebanBtn.userInteractionEnabled = YES;
    }else {
        jiebanBtn.layer.borderColor = [[UIColor colorWithHexString:@"#E3E3E5"] CGColor];
        [jiebanBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
        jiebanBtn.userInteractionEnabled = NO;
    }
    //是否为交班人
    if([self.jiaoJieBanInfo[@"isHandoverPerson"] boolValue]) {
        jiaobanBtn.layer.borderColor = [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0].CGColor;
        [jiaobanBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
        jiaobanBtn.userInteractionEnabled = YES;
    }else {
        jiaobanBtn.layer.borderColor = [[UIColor colorWithHexString:@"#E3E3E5"] CGColor];
        [jiaobanBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
        jiaobanBtn.userInteractionEnabled = NO;
    }
    //是否能生成运行报告
    if([self.jiaoJieBanInfo[@"isRunReport"] boolValue]) {
        createReportView.layer.borderColor = [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0].CGColor;
        createReportView.layer.borderWidth = 1;
        createIcon.image = [UIImage imageNamed:@"run_createIcon"];
        createReportLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        createReportBtn.userInteractionEnabled = YES;
        createReportView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    }else {
        createReportView.layer.borderColor = [[UIColor colorWithHexString:@"#E3E3E5"] CGColor];
        createReportView.layer.borderWidth = 1;
        createIcon.image = [UIImage imageNamed:@"create_unselIcon"];
        createReportLabel.textColor = [UIColor colorWithHexString:@"#BEBFC7"];
        createReportBtn.userInteractionEnabled = NO;
        createReportView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    }
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E1E1E5"];
    [self.runReprtView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.equalTo(self.runReprtView.mas_left).offset(15);
        make.right.equalTo(self.runReprtView.mas_right).offset(-17);
        make.top.equalTo(jiaobanBtn.mas_bottom).offset(16);
    }];
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
@end
