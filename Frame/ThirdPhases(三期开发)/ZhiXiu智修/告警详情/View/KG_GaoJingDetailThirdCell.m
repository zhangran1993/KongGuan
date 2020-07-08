//
//  KG_GaoJingDetailThirdCell.m
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_GaoJingDetailThirdCell.h"


@interface KG_GaoJingDetailThirdCell (){
    
    
}

@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) UIButton *btn5;

@property (nonatomic, strong) UIView *line1;
@property (nonatomic, strong) UIView *line2;
@property (nonatomic, strong) UIView *line3;
@property (nonatomic, strong) UIView *line4;


@end

@implementation KG_GaoJingDetailThirdCell

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
    
    
    self.line1 = [[UIView alloc]init];
    [self addSubview:self.line1];
    self.line1.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(38);
        make.width.equalTo(@77);
        make.height.equalTo(@3);
        make.top.equalTo(self.mas_top).offset(72);
    }];
    
    self.line2 = [[UIView alloc]init];
    self.line2.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
    [self addSubview:self.line2];
    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line1.mas_right);
        make.width.equalTo(@77);
        make.height.equalTo(@3);
        make.top.equalTo(self.mas_top).offset(72);
    }];
    
    self.line3 = [[UIView alloc]init];
    self.line3.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
    [self addSubview:self.line3];
    [self.line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line2.mas_right);
        make.width.equalTo(@77);
        make.height.equalTo(@3);
        make.top.equalTo(self.mas_top).offset(72);
    }];
    
    
    self.line4 = [[UIView alloc]init];
    self.line4.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
    [self addSubview:self.line4];
    [self.line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.line3.mas_right);
        make.width.equalTo(@77);
        make.height.equalTo(@3);
        make.top.equalTo(self.mas_top).offset(72);
    }];
    
    
    
    
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.text = @"处理流程";
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(13);
        make.width.equalTo(@120);
        make.height.equalTo(@22);
    }];
    
    self.btn1 = [[UIButton alloc]init];
    [self addSubview:self.btn1];
    [self.btn1 setImage:[UIImage imageNamed:@"告警确认gray"] forState:UIControlStateNormal];
    [self.btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.top.equalTo(titleLabel.mas_bottom).offset(17);
        make.width.height.equalTo(@40);
    }];
    [self.btn1 addTarget:self action:@selector(btn1Method:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label1 = [[UILabel alloc]init];
    [self addSubview:label1];
    label1.text = @"告警确认";
    label1.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font = [UIFont systemFontOfSize:12];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btn1.mas_centerX);
        make.top.equalTo(self.btn1.mas_bottom).offset(8);
        make.width.equalTo(@60);
        make.height.equalTo(@22);
    }];
    
    
    self.btn2 = [[UIButton alloc]init];
    [self addSubview:self.btn2];
    [self.btn2 setImage:[UIImage imageNamed:@"应急处理gray"] forState:UIControlStateNormal];
    [self.btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btn1.mas_right).offset(34);
        make.top.equalTo(titleLabel.mas_bottom).offset(17);
        make.width.height.equalTo(@40);
    }];
    [self.btn2 addTarget:self action:@selector(btn1Method:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label2 = [[UILabel alloc]init];
    [self addSubview:label2];
    label2.text = @"应急处理";
    label2.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font = [UIFont systemFontOfSize:12];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btn2.mas_centerX);
        make.top.equalTo(self.btn2.mas_bottom).offset(8);
        make.width.equalTo(@60);
        make.height.equalTo(@22);
    }];
    
    self.btn3 = [[UIButton alloc]init];
    [self addSubview:self.btn3];
    [self.btn3 setImage:[UIImage imageNamed:@"故障通告gray"] forState:UIControlStateNormal];
    [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btn2.mas_right).offset(34);
        make.top.equalTo(titleLabel.mas_bottom).offset(17);
        make.width.height.equalTo(@40);
    }];
    [self.btn3 addTarget:self action:@selector(btn1Method:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label3 = [[UILabel alloc]init];
    [self addSubview:label3];
    label3.text = @"故障通告";
    label3.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font = [UIFont systemFontOfSize:12];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btn3.mas_centerX);
        make.top.equalTo(self.btn3.mas_bottom).offset(8);
        make.width.equalTo(@60);
        make.height.equalTo(@22);
    }];
    
    self.btn4 = [[UIButton alloc]init];
    [self addSubview:self.btn4];
    [self.btn4 setImage:[UIImage imageNamed:@"设备排故gray"] forState:UIControlStateNormal];
    [self.btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btn3.mas_right).offset(34);
        make.top.equalTo(titleLabel.mas_bottom).offset(17);
        make.width.height.equalTo(@40);
    }];
    [self.btn4 addTarget:self action:@selector(btn1Method:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label4= [[UILabel alloc]init];
    [self addSubview:label4];
    label4.text = @"设备排故";
    label4.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.font = [UIFont systemFontOfSize:12];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btn4.mas_centerX);
        make.top.equalTo(self.btn4.mas_bottom).offset(8);
        make.width.equalTo(@60);
        make.height.equalTo(@22);
    }];
    
    self.btn5 = [[UIButton alloc]init];
    [self addSubview:self.btn5];
    [self.btn5 setImage:[UIImage imageNamed:@"告警解决gray"] forState:UIControlStateNormal];
    [self.btn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btn4.mas_right).offset(34);
        make.top.equalTo(titleLabel.mas_bottom).offset(17);
        make.width.height.equalTo(@40);
    }];
    [self.btn5 addTarget:self action:@selector(btn1Method:) forControlEvents:UIControlEventTouchUpInside];
    UILabel *label5= [[UILabel alloc]init];
    [self addSubview:label5];
    label5.text = @"告警解决";
    label5.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
    label5.textAlignment = NSTextAlignmentCenter;
    label5.font = [UIFont systemFontOfSize:12];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btn5.mas_centerX);
        make.top.equalTo(self.btn5.mas_bottom).offset(8);
        make.width.equalTo(@60);
        make.height.equalTo(@22);
    }];
    
}


- (void)btn1Method:(UIButton *)btn {
    
    
}
- (void)setModel:(KG_GaoJingDetailModel *)model {
    _model = model;
    NSString *recordStatus = safeString(model.info[@"recordStatus"]);
    recordStatus = @"completed";
    if ([recordStatus isEqualToString:@"unconfirmed"]) {
        //
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line2.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line3.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line4.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        
        [self.btn1 setImage:[UIImage imageNamed:@"告警确认gray"] forState:UIControlStateNormal];
        [self.btn2 setImage:[UIImage imageNamed:@"应急处理gray"] forState:UIControlStateNormal];
        [self.btn3 setImage:[UIImage imageNamed:@"故障通告gray"] forState:UIControlStateNormal];
        [self.btn4 setImage:[UIImage imageNamed:@"设备排故gray"] forState:UIControlStateNormal];
        [self.btn5 setImage:[UIImage imageNamed:@"告警解决gray"] forState:UIControlStateNormal];
        
    }else if ([recordStatus isEqualToString:@"confirmed"]) {//告警确认
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line2.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line3.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line4.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        
        [self.btn1 setImage:[UIImage imageNamed:@"告警确认"] forState:UIControlStateNormal];
        [self.btn2 setImage:[UIImage imageNamed:@"应急处理gray"] forState:UIControlStateNormal];
        [self.btn3 setImage:[UIImage imageNamed:@"故障通告gray"] forState:UIControlStateNormal];
        [self.btn4 setImage:[UIImage imageNamed:@"设备排故gray"] forState:UIControlStateNormal];
        [self.btn5 setImage:[UIImage imageNamed:@"告警解决gray"] forState:UIControlStateNormal];
    }else if ([recordStatus isEqualToString:@"emergency"]) {//应急处理
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line2.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line3.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line4.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        
        [self.btn1 setImage:[UIImage imageNamed:@"告警确认"] forState:UIControlStateNormal];
        [self.btn2 setImage:[UIImage imageNamed:@"应急处理"] forState:UIControlStateNormal];
        [self.btn3 setImage:[UIImage imageNamed:@"故障通告gray"] forState:UIControlStateNormal];
        [self.btn4 setImage:[UIImage imageNamed:@"设备排故gray"] forState:UIControlStateNormal];
        [self.btn5 setImage:[UIImage imageNamed:@"告警解决gray"] forState:UIControlStateNormal];
    }else if ([recordStatus isEqualToString:@"announce"]) {//故障通告
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line2.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line3.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line4.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        
        [self.btn1 setImage:[UIImage imageNamed:@"告警确认"] forState:UIControlStateNormal];
        [self.btn2 setImage:[UIImage imageNamed:@"应急处理"] forState:UIControlStateNormal];
        [self.btn3 setImage:[UIImage imageNamed:@"故障通告"] forState:UIControlStateNormal];
        [self.btn4 setImage:[UIImage imageNamed:@"设备排故gray"] forState:UIControlStateNormal];
        [self.btn5 setImage:[UIImage imageNamed:@"告警解决gray"] forState:UIControlStateNormal];
    }else if ([recordStatus isEqualToString:@"shooting"]) {//设备排故
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line2.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line3.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line4.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        
        [self.btn1 setImage:[UIImage imageNamed:@"告警确认"] forState:UIControlStateNormal];
        [self.btn2 setImage:[UIImage imageNamed:@"应急处理"] forState:UIControlStateNormal];
        [self.btn3 setImage:[UIImage imageNamed:@"故障通告"] forState:UIControlStateNormal];
        [self.btn4 setImage:[UIImage imageNamed:@"设备排故"] forState:UIControlStateNormal];
        [self.btn5 setImage:[UIImage imageNamed:@"告警解决gray"] forState:UIControlStateNormal];
    }else if ([recordStatus isEqualToString:@"completed"]) {//告警解决
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line2.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line3.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line4.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        
        [self.btn1 setImage:[UIImage imageNamed:@"告警确认"] forState:UIControlStateNormal];
        [self.btn2 setImage:[UIImage imageNamed:@"应急处理"] forState:UIControlStateNormal];
        [self.btn3 setImage:[UIImage imageNamed:@"故障通告"] forState:UIControlStateNormal];
        [self.btn4 setImage:[UIImage imageNamed:@"设备排故"] forState:UIControlStateNormal];
        [self.btn5 setImage:[UIImage imageNamed:@"告警解决"] forState:UIControlStateNormal];
    }
}

@end
