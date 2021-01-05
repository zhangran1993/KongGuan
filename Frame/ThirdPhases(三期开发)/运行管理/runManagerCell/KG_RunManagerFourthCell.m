//
//  KG_RunManagerFourthCell.m
//  Frame
//
//  Created by zhangran on 2020/6/4.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_RunManagerFourthCell.h"
#import "KG_RunJiaoJieBanCell.h"
@interface KG_RunManagerFourthCell ()<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong)  UIView    *jiaojiebanView;//交接班View


@property (nonatomic, strong)  UITableView *jiaoJieBanTableView;//3
@end

@implementation KG_RunManagerFourthCell

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
- (void)setJiaojiebanListArr:(NSArray *)jiaojiebanListArr {
    _jiaojiebanListArr = jiaojiebanListArr;
    [self setUpJiaoJieBanView];
}

- (void)setUpJiaoJieBanView {
    [self.jiaojiebanView removeFromSuperview];
    self.jiaojiebanView = nil;
    self.jiaojiebanView =  [[UIView alloc]init];
    [self addSubview:self.jiaojiebanView];
    [_jiaoJieBanTableView removeFromSuperview];
    _jiaoJieBanTableView = nil;
  
    [self.jiaojiebanView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@(self.jiaojiebanListArr.count *80+40));
    }];
    
    UIView *leftView = [[UIView alloc]init];
    leftView.backgroundColor = [UIColor colorWithHexString:@"#2A6EFD"];
    [self.jiaojiebanView addSubview:leftView];
    leftView.layer.cornerRadius = 2;
    leftView.layer.masksToBounds = YES;
    [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jiaojiebanView.mas_left).offset(16);
        make.width.equalTo(@4);
        make.top.equalTo(self.jiaojiebanView.mas_top).offset(10);
        make.height.equalTo(@15);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.jiaojiebanView addSubview:titleLabel];
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.font = [UIFont my_font:16];
    titleLabel.text = [NSString stringWithFormat:@"%@",@"交接班记录"];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(leftView.mas_right).offset(4);
        make.centerY.equalTo(leftView.mas_centerY);
        make.width.equalTo(@200);
        make.height.equalTo(@17);
    }];
    UIButton *Btn1 = [[UIButton alloc]init];

    [self.jiaojiebanView addSubview:Btn1];
    [Btn1 addTarget:self action:@selector(jiaojieBanRecord) forControlEvents:UIControlEventTouchUpInside];
    [Btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@100);
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(self.jiaojiebanView.mas_right).offset(-16);
    }];

    UIButton *reportRightBtn = [[UIButton alloc]init];
    [reportRightBtn setImage:[UIImage imageNamed:@"common_right"] forState:UIControlStateNormal];
    [self.jiaojiebanView addSubview:reportRightBtn];
    [reportRightBtn addTarget:self action:@selector(jiaojieBanRecord) forControlEvents:UIControlEventTouchUpInside];
    [reportRightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.right.equalTo(self.jiaojiebanView.mas_right).offset(-16);
    }];
    UILabel *recordLabel = [[UILabel alloc]init];
    [self.jiaojiebanView addSubview:recordLabel];
    recordLabel.textColor = [UIColor colorWithHexString:@"#9294A0"];
    recordLabel.font = [UIFont systemFontOfSize:12];
    recordLabel.font = [UIFont my_font:12];
    recordLabel.textAlignment = NSTextAlignmentRight;
    recordLabel.text = [NSString stringWithFormat:@""];
    [recordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(reportRightBtn.mas_left);
        make.centerY.equalTo(titleLabel.mas_centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@17);
    }];
    //
    
    [self.jiaojiebanView addSubview:self.jiaoJieBanTableView];
    [self.jiaoJieBanTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.jiaojiebanView.mas_left);
        make.right.equalTo(self.jiaojiebanView.mas_right);
        make.top.equalTo(recordLabel.mas_bottom).offset(10);
        make.height.equalTo(@(self.jiaojiebanListArr.count *80));
    }];
    [self.jiaoJieBanTableView reloadData];
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E1E1E5"];
    [self.jiaojiebanView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.equalTo(self.jiaojiebanView.mas_left).offset(15);
        make.right.equalTo(self.jiaojiebanView.mas_right).offset(-17);
        make.top.equalTo(self.jiaoJieBanTableView.mas_bottom).offset(2);
    }];
    
}
- (UITableView *)jiaoJieBanTableView {
    if (!_jiaoJieBanTableView) {
        _jiaoJieBanTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _jiaoJieBanTableView.delegate = self;
        _jiaoJieBanTableView.dataSource = self;
        _jiaoJieBanTableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _jiaoJieBanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _jiaoJieBanTableView.scrollEnabled = NO;
        
        
    }
    return _jiaoJieBanTableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if ([tableView isEqual:self.jiaoJieBanTableView]) {
        return self.jiaojiebanListArr.count;
    }
    return 0;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
   
    if ([tableView isEqual:self.jiaoJieBanTableView]) {
        
        KG_RunJiaoJieBanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KG_RunJiaoJieBanCell"];
        if (cell == nil) {
            cell = [[KG_RunJiaoJieBanCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"KG_RunJiaoJieBanCell"];
        }
        cell.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSDictionary *dataDic = self.jiaojiebanListArr[indexPath.row];
        cell.dic = dataDic;
        
        return cell;
    }
    
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:self.jiaoJieBanTableView]) {
        return 80 ;
    }
    return 50;
}

- (void)jiaojieBanRecord {
    if (self.jiaojiebanBlockMethod) {
        self.jiaojiebanBlockMethod();
    }
}


@end
