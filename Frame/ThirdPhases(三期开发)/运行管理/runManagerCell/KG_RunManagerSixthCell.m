//
//  KG_RunManagerSixthCell.m
//  Frame
//
//  Created by zhangran on 2021/2/20.
//  Copyright © 2021 hibaysoft. All rights reserved.
//

#import "KG_RunManagerSixthCell.h"

@interface  KG_RunManagerSixthCell() {
    
    
}
@property (nonatomic,strong) UIButton        *jiaobanBtn;
@property (nonatomic,strong) UIButton        *jiebanBtn;
@property (nonatomic,strong) UIView          *runReprtView;
@property (nonatomic,strong) UIView          *createReportView;

@property (nonatomic,strong) UIImageView     *createIcon;
@property (nonatomic,strong) UILabel         *createReportLabel;
@property (nonatomic,strong) UIButton        *createReportBtn;
@end

@implementation KG_RunManagerSixthCell

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
        self.contentView.backgroundColor = self.backgroundColor;
        [self createSubviewsView];
    }
    return self;
}

- (void)createSubviewsView {
    
    self.runReprtView = [[UIView alloc]init];
    [self addSubview:self.runReprtView];
    [self.runReprtView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@70);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
    self.createReportView = [[UIView alloc]init];
    [self.runReprtView addSubview:self.createReportView];
    [self.createReportView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@147);
        make.height.equalTo(@37);
        make.left.equalTo(self.runReprtView.mas_left).offset(16);
        make.centerY.equalTo(self.runReprtView.mas_centerY);
    }];
    self.createReportView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    self.createReportView.layer.cornerRadius = 20;
    self.createReportView.layer.masksToBounds = YES;
    
    self.createIcon = [[UIImageView alloc]init];
    [self.createReportView addSubview:self.createIcon];
    self.createIcon.image = [UIImage imageNamed:@"run_createIcon"];
    [self.createIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@16);
        make.height.equalTo(@19);
        make.left.equalTo(self.createReportView.mas_left).offset(13);
        make.centerY.equalTo(self.createReportView.mas_centerY);
    }];
    
    self.createReportLabel = [[UILabel alloc]init];
    [self.createReportView addSubview:self.createReportLabel];
    self.createReportLabel.text = @"生成运行报告";
    self.createReportLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
    self.createReportLabel.font = [UIFont systemFontOfSize:16];
    [self.createReportLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.createIcon.mas_right).offset(6);
        make.centerY.equalTo(self.createIcon.mas_centerY);
        make.right.equalTo(self.createReportView.mas_right).offset(-6);
        make.height.equalTo(@22);
    }];
    
    self.createReportBtn = [[UIButton alloc]init];
    [self.createReportBtn setBackgroundColor:[UIColor clearColor]];
    [self.createReportView addSubview:self.createReportBtn];
    [self.createReportBtn addTarget:self action:@selector(CreateReportMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.createReportBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.createReportView.mas_height);
        make.centerY.equalTo(self.createReportView.mas_centerY);
        make.left.equalTo(self.createReportView.mas_left);
        make.right.equalTo(self.createReportView.mas_right);
    }];
    
    self.jiaobanBtn  = [[UIButton alloc]init];
    [self.jiaobanBtn setBackgroundColor:[UIColor clearColor]];
    self.jiaobanBtn.layer.borderWidth = 1;
    self.jiaobanBtn.layer.borderColor = [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0].CGColor;
    [self.jiaobanBtn setTitle:@"交班"  forState:UIControlStateNormal];
    self.jiaobanBtn.layer.cornerRadius = 20;
    self.jiaobanBtn.layer.masksToBounds = YES;
    [self.jiaobanBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    self.jiaobanBtn.titleLabel.font  = [UIFont systemFontOfSize:16];
    [self.runReprtView addSubview:self.jiaobanBtn];
    [self.jiaobanBtn addTarget:self action:@selector(jiaobanMethod) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.jiebanBtn  = [[UIButton alloc]init];
    [self.jiebanBtn setBackgroundColor:[UIColor clearColor]];
    self.jiebanBtn.layer.borderWidth = 1;
    self.jiebanBtn.layer.cornerRadius = 20;
    self.jiebanBtn.titleLabel.font  = [UIFont systemFontOfSize:16];
    [self.jiebanBtn setTitle:@"接班"  forState:UIControlStateNormal];
    self.jiebanBtn.layer.masksToBounds = YES;
    self.jiebanBtn.layer.borderColor = [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0].CGColor;
    [self.jiebanBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    self.jiaobanBtn.titleLabel.font  = [UIFont systemFontOfSize:16];
    [self.runReprtView addSubview:self.jiebanBtn];
    [self.jiebanBtn addTarget:self action:@selector(jiebanMethod) forControlEvents:UIControlEventTouchUpInside];
    [self.jiebanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@37);
        make.centerY.equalTo(self.createReportView.mas_centerY);
        make.width.equalTo(@64);
        make.right.equalTo(self.runReprtView.mas_right).offset(-16);
    }];
    [self.jiaobanBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@37);
        make.centerY.equalTo(self.createReportView.mas_centerY);
        make.right.equalTo(self.jiebanBtn.mas_left).offset(-9);
        make.width.equalTo(@64);
    }];
   
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E1E1E5"];
    [self.runReprtView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@0.5);
        make.left.equalTo(self.runReprtView.mas_left).offset(15);
        make.right.equalTo(self.runReprtView.mas_right).offset(-17);
        make.top.equalTo(self.jiaobanBtn.mas_bottom).offset(16);
    }];
    
}


- (void)CreateReportMethod {
    if (self.createReportBlockMethod) {
        self.createReportBlockMethod();
    }
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
////如果运行报告已经生成，并且尚为完成接班，则为true。如果已经接班完成，则为false。
//@property (nonatomic,copy)      NSString   *enableGenerateGlobal;             //是否可生成运行报告
//@property (nonatomic,copy)      NSString   *enableSucceedGlobal;              //是否可接班
//@property (nonatomic,copy)      NSString   *enableHandoverGlobal;            //是否可交班
- (void)setDetailModel:(KG_RunManagerDetailModel *)detailModel {
    _detailModel = detailModel;
    //是否为接班人
    if(detailModel.enableSucceedGlobal) {
        self.jiebanBtn.layer.borderColor =  [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0].CGColor;
        [self.jiebanBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
        self.jiebanBtn.userInteractionEnabled = YES;
    }else {
        self.jiebanBtn.layer.borderColor = [[UIColor colorWithHexString:@"#E3E3E5"] CGColor];
        [self.jiebanBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
        self.jiebanBtn.userInteractionEnabled = NO;
    }
    //是否为交班人
    if(detailModel.enableHandoverGlobal) {
        self.jiaobanBtn.layer.borderColor = [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0].CGColor;
        [self.jiaobanBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
        self.jiaobanBtn.userInteractionEnabled = YES;
    }else {
        self.jiaobanBtn.layer.borderColor = [[UIColor colorWithHexString:@"#E3E3E5"] CGColor];
        [self.jiaobanBtn setTitleColor:[UIColor colorWithHexString:@"#BABCC4"] forState:UIControlStateNormal];
        self.jiaobanBtn.userInteractionEnabled = NO;
    }
    //是否能生成运行报告
    if(detailModel.enableGenerateGlobal) {
        self.createReportView.layer.borderColor = [UIColor colorWithRed:47/255.0 green:94/255.0 blue:209/255.0 alpha:1.0].CGColor;
        self.createReportView.layer.borderWidth = 1;
        self.createIcon.image = [UIImage imageNamed:@"run_createIcon"];
        self.createReportLabel.textColor = [UIColor colorWithHexString:@"#FFFFFF"];
        self.createReportBtn.userInteractionEnabled = YES;
        self.createReportView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    }else {
        self.createReportView.layer.borderColor = [[UIColor colorWithHexString:@"#E3E3E5"] CGColor];
        self.createReportView.layer.borderWidth = 1;
        self.createIcon.image = [UIImage imageNamed:@"create_unselIcon"];
        self.createReportLabel.textColor = [UIColor colorWithHexString:@"#BEBFC7"];
        self.createReportBtn.userInteractionEnabled = NO;
        self.createReportView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    }
    
    
}
@end
