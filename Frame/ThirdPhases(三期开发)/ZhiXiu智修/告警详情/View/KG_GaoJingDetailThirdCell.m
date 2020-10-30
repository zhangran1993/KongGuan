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

@property (nonatomic, strong) UIView   *line1;
@property (nonatomic, strong) UIView   *line2;
@property (nonatomic, strong) UIView   *line3;
@property (nonatomic, strong) UIView   *line4;

@property (nonatomic, strong) UIView   *botView;

@property (nonatomic, strong) UIButton *botBtn;

@property (nonatomic, copy) NSString   *gaoJingStatus;



@property (nonatomic, strong) UIImageView   *image2;

@property (nonatomic, strong) UIImageView   *image3;

@property (nonatomic, strong) UIImageView   *image4;



@property (nonatomic, strong) UILabel   *label1;
@property (nonatomic, strong) UILabel   *label2;
@property (nonatomic, strong) UILabel   *label3;
@property (nonatomic, strong) UILabel   *label4;
@property (nonatomic, strong) UILabel   *label5;
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
    
    self.label1 = [[UILabel alloc]init];
    [self addSubview:self.label1];
    self.label1.text = @"告警确认";
    self.label1.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
    self.label1.textAlignment = NSTextAlignmentCenter;
    self.label1.font = [UIFont systemFontOfSize:12];
    [self.label1 mas_makeConstraints:^(MASConstraintMaker *make) {
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
    [self.btn2 addTarget:self action:@selector(btn2Method:) forControlEvents:UIControlEventTouchUpInside];
    self.label2 = [[UILabel alloc]init];
    [self addSubview:self.label2];
    self.label2.text = @"应急处理";
    self.label2.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
    self.label2.textAlignment = NSTextAlignmentCenter;
    self.label2.font = [UIFont systemFontOfSize:12];
    [self.label2 sizeToFit];
    [self.label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btn2.mas_centerX);
        make.top.equalTo(self.btn2.mas_bottom).offset(8);
        make.height.equalTo(@22);
    }];
    
    self.image2 = [[UIImageView alloc]init];
    [self addSubview:self.image2];
    self.image2.image = [UIImage imageNamed:@"kg_liucheng_slider_gray"];
    [self.image2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label2.mas_right);
        make.centerY.equalTo(self.label2.mas_centerY);
        make.width.equalTo(@4);
        make.height.equalTo(@4);
    }];
    
    
    self.btn3 = [[UIButton alloc]init];
    [self addSubview:self.btn3];
    [self.btn3 setImage:[UIImage imageNamed:@"故障通告gray"] forState:UIControlStateNormal];
    [self.btn3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btn2.mas_right).offset(34);
        make.top.equalTo(titleLabel.mas_bottom).offset(17);
        make.width.height.equalTo(@40);
    }];
    [self.btn3 addTarget:self action:@selector(btn3Method:) forControlEvents:UIControlEventTouchUpInside];
    self.label3 = [[UILabel alloc]init];
    [self addSubview:self.label3];
    self.label3.text = @"故障通告";
    self.label3.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
    self.label3.textAlignment = NSTextAlignmentCenter;
    [self.label3 sizeToFit];
    self.label3.font = [UIFont systemFontOfSize:12];
    [self.label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btn3.mas_centerX);
        make.top.equalTo(self.btn3.mas_bottom).offset(8);
       
        make.height.equalTo(@22);
    }];
    self.image3 = [[UIImageView alloc]init];
    [self addSubview:self.image3];
    self.image3.image = [UIImage imageNamed:@"kg_liucheng_slider_gray"];
    [self.image3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label3.mas_right);
        make.centerY.equalTo(self.label3.mas_centerY);
        make.width.equalTo(@4);
        make.height.equalTo(@4);
    }];
    
    self.btn4 = [[UIButton alloc]init];
    [self addSubview:self.btn4];
    [self.btn4 setImage:[UIImage imageNamed:@"设备排故gray"] forState:UIControlStateNormal];
    [self.btn4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btn3.mas_right).offset(34);
        make.top.equalTo(titleLabel.mas_bottom).offset(17);
        make.width.height.equalTo(@40);
    }];
    [self.btn4 addTarget:self action:@selector(btn4Method:) forControlEvents:UIControlEventTouchUpInside];
    self.label4 = [[UILabel alloc]init];
    [self addSubview:self.label4];
    self.label4.text = @"设备排故";
    self.label4.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
    self.label4.textAlignment = NSTextAlignmentCenter;
    self.label4.font = [UIFont systemFontOfSize:12];
    [self.label4 sizeToFit];
    [self.label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btn4.mas_centerX);
        make.top.equalTo(self.btn4.mas_bottom).offset(8);
      
        make.height.equalTo(@22);
    }];
    self.image4 = [[UIImageView alloc]init];
    [self addSubview:self.image4];
    self.image4.image = [UIImage imageNamed:@"kg_liucheng_slider_gray"];
    [self.image4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.label4.mas_right);
        make.centerY.equalTo(self.label4.mas_centerY);
        make.width.equalTo(@4);
        make.height.equalTo(@4);
    }];
    
    
    self.btn5 = [[UIButton alloc]init];
    [self addSubview:self.btn5];
    [self.btn5 setImage:[UIImage imageNamed:@"告警解决gray"] forState:UIControlStateNormal];
    [self.btn5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btn4.mas_right).offset(34);
        make.top.equalTo(titleLabel.mas_bottom).offset(17);
        make.width.height.equalTo(@40);
    }];
  
    self.label5 = [[UILabel alloc]init];
    [self addSubview:self.label5];
    self.label5.text = @"告警解决";
    self.label5.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
    self.label5.textAlignment = NSTextAlignmentCenter;
    self.label5.font = [UIFont systemFontOfSize:12];
    [self.label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btn5.mas_centerX);
        make.top.equalTo(self.btn5.mas_bottom).offset(8);
        make.width.equalTo(@60);
        make.height.equalTo(@22);
    }];
    
    self.botView = [[UIView alloc]init];
    [self addSubview:self.botView];
    [self.botView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.btn1.mas_centerX);
        make.top.equalTo(self.label1.mas_bottom).offset(11);
        make.width.equalTo(@44);
        make.height.equalTo(@36);
    }];
    
    self.botBtn = [[UIButton alloc]init];
    [self.botView addSubview:self.botBtn];
    [self.botBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.botBtn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    [self.botBtn setBackgroundImage:[UIImage imageNamed:@"kg_gaojing_liuchengBgImage"] forState:UIControlStateNormal];
    self.botBtn.titleLabel.font = [UIFont systemFontOfSize:12];
 
    [self.botBtn addTarget:self action:@selector(confirmMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.botBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.botView.mas_left);
        make.top.equalTo(self.botView.mas_top);
        make.left.equalTo(self.botView.mas_left);
        make.right.equalTo(self.botView.mas_right);
    }];
    
    
    
}

- (void)confirmMethod :(UIButton *)btn {
    
    NSString *record = safeString(self.model.info[@"recordStatus"]);
    NSString *recordStatus = @"unconfirmed";
    
    if ([record isEqualToString:@"unconfirmed"]) {
        recordStatus = @"confirmed";
        
    }else if ([record isEqualToString:@"confirmed"]) {//告警确认
        recordStatus = @"emergency";
    }else if ([record isEqualToString:@"emergency"]) {//应急处理
        recordStatus = @"announce";
    }else if ([record isEqualToString:@"announce"]) {//故障通告
        recordStatus = @"shooting";
    }else if ([record isEqualToString:@"shooting"]) {//设备排故
        recordStatus = @"completed";
    }else if ([record isEqualToString:@"completed"]) {//完成
        recordStatus = @"finish";
    }
    
    
   
    
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
    
   
    
    if ([recordStatus isEqualToString:@"unconfirmed"]) {
        
        self.botView.hidden = YES;
    }else if ([recordStatus isEqualToString:@"confirmed"]) {//告警确认
        self.botView.hidden = NO;
        self.label1.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label2.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label3.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label4.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label5.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        
        [self.botView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.btn2.mas_centerX);
            make.top.equalTo(self.btn2.mas_bottom).offset(37);
            make.width.equalTo(@44);
            make.height.equalTo(@36);
        }];
        
    }else if ([recordStatus isEqualToString:@"announce"]) {//故障通告
        self.botView.hidden = NO;
        self.label3.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label1.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label2.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        
        self.label4.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label5.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        
        
        [self.botView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.btn3.mas_centerX);
            make.top.equalTo(self.btn3.mas_bottom).offset(37);
            make.width.equalTo(@44);
            make.height.equalTo(@36);
        }];
        
    }else if ([recordStatus isEqualToString:@"shooting"]) {//设备排故
        self.botView.hidden = NO;
        self.label4.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label1.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label2.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label3.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        
        self.label5.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        
        
        [self.botView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.btn4.mas_centerX);
            make.top.equalTo(self.btn4.mas_bottom).offset(37);
            make.width.equalTo(@44);
            make.height.equalTo(@36);
        }];
        
    }else if ([recordStatus isEqualToString:@"completed"]) {//告警解决
        self.botView.hidden = NO;
        self.label5.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label1.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label2.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label3.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label4.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        
        
        [self.botView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.btn5.mas_centerX);
            make.top.equalTo(self.btn5.mas_bottom).offset(37);
            make.width.equalTo(@44);
            make.height.equalTo(@36);
        }];
        
    }else if ([recordStatus isEqualToString:@"finish"]) {//告警解决
        self.botView.hidden = YES;
      
    }
    
    if (self.changeStatus) {
        self.changeStatus(recordStatus);
    }
    
}


- (void)btn2Method:(UIButton *)btn {
    if (self.pushToNextStep) {
        self.pushToNextStep(@"EmergencyTreatment",self.model);
    }
}

- (void)btn3Method:(UIButton *)btn {
    if (self.pushToNextStep) {
        self.pushToNextStep(@"FailureNotice",self.model);
    }
}

- (void)btn4Method:(UIButton *)btn {
    if (self.pushToNextStep) {
        self.pushToNextStep(@"EquipmentTroubleshooting",self.model);
    }
}

- (void)setModel:(KG_GaoJingDetailModel *)model {
    _model = model;
    NSString *recordStatus = safeString(model.info[@"recordStatus"]);
    NSString *sstatus = safeString(model.info[@"status"]);
    NSString *hangUpStatus = safeString(model.info[@"hangupStatus"]);
    
//    self.image2.image = [UIImage imageNamed:@"kg_liucheng_slider_gray"];
//    self.image3.image = [UIImage imageNamed:@"kg_liucheng_slider_gray"];
//    self.image4.image = [UIImage imageNamed:@"kg_liucheng_slider_gray"];
//    self.label1.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
//    self.label2.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
//    self.label3.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
//    self.label4.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
//    self.label5.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
//    self.botView.hidden = NO;
    if ([recordStatus isEqualToString:@"unconfirmed"]) {
        
        self.label1.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label2.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label3.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label4.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label5.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line2.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line3.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line4.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        
        [self.btn1 setImage:[UIImage imageNamed:@"告警确认gray"] forState:UIControlStateNormal];
        [self.btn2 setImage:[UIImage imageNamed:@"应急处理gray"] forState:UIControlStateNormal];
        [self.btn3 setImage:[UIImage imageNamed:@"故障通告gray"] forState:UIControlStateNormal];
        [self.btn4 setImage:[UIImage imageNamed:@"设备排故gray"] forState:UIControlStateNormal];
        [self.btn5 setImage:[UIImage imageNamed:@"告警解决gray"] forState:UIControlStateNormal];
        
        self.image2.image = [UIImage imageNamed:@"kg_liucheng_slider_gray"];
        self.image3.image = [UIImage imageNamed:@"kg_liucheng_slider_gray"];
        self.image4.image = [UIImage imageNamed:@"kg_liucheng_slider_gray"];
        
    }else if ([recordStatus isEqualToString:@"confirmed"]) {//告警确认
        self.label1.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label2.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label3.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label4.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label5.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line2.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line3.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line4.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        
        [self.btn1 setImage:[UIImage imageNamed:@"告警确认"] forState:UIControlStateNormal];
        [self.btn2 setImage:[UIImage imageNamed:@"应急处理gray"] forState:UIControlStateNormal];
        [self.btn3 setImage:[UIImage imageNamed:@"故障通告gray"] forState:UIControlStateNormal];
        [self.btn4 setImage:[UIImage imageNamed:@"设备排故gray"] forState:UIControlStateNormal];
        [self.btn5 setImage:[UIImage imageNamed:@"告警解决gray"] forState:UIControlStateNormal];
        
        self.image2.image = [UIImage imageNamed:@"kg_liucheng_slider_blue"];
        self.image3.image = [UIImage imageNamed:@"kg_liucheng_slider_gray"];
        self.image4.image = [UIImage imageNamed:@"kg_liucheng_slider_gray"];
    }else if ([recordStatus isEqualToString:@"emergency"]) {//应急处理
        self.label1.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label2.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label3.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label4.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label5.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line2.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line3.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line4.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        
        [self.btn1 setImage:[UIImage imageNamed:@"告警确认"] forState:UIControlStateNormal];
        [self.btn2 setImage:[UIImage imageNamed:@"应急处理"] forState:UIControlStateNormal];
        [self.btn3 setImage:[UIImage imageNamed:@"故障通告gray"] forState:UIControlStateNormal];
        [self.btn4 setImage:[UIImage imageNamed:@"设备排故gray"] forState:UIControlStateNormal];
        [self.btn5 setImage:[UIImage imageNamed:@"告警解决gray"] forState:UIControlStateNormal];
        
        self.image2.image = [UIImage imageNamed:@"kg_liucheng_slider_blue"];
        self.image3.image = [UIImage imageNamed:@"kg_liucheng_slider_gray"];
        self.image4.image = [UIImage imageNamed:@"kg_liucheng_slider_gray"];
    }else if ([recordStatus isEqualToString:@"announce"]) {//故障通告
        self.label1.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label2.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label3.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label4.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        self.label5.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line2.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line3.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        self.line4.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        
        [self.btn1 setImage:[UIImage imageNamed:@"告警确认"] forState:UIControlStateNormal];
        [self.btn2 setImage:[UIImage imageNamed:@"应急处理"] forState:UIControlStateNormal];
        [self.btn3 setImage:[UIImage imageNamed:@"故障通告"] forState:UIControlStateNormal];
        [self.btn4 setImage:[UIImage imageNamed:@"设备排故gray"] forState:UIControlStateNormal];
        [self.btn5 setImage:[UIImage imageNamed:@"告警解决gray"] forState:UIControlStateNormal];
        
        self.image2.image = [UIImage imageNamed:@"kg_liucheng_slider_blue"];
        self.image3.image = [UIImage imageNamed:@"kg_liucheng_slider_blue"];
        self.image4.image = [UIImage imageNamed:@"kg_liucheng_slider_gray"];
       
    }else if ([recordStatus isEqualToString:@"shooting"]) {//设备排故
        self.label1.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label2.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label3.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label4.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label5.textColor = [UIColor colorWithHexString:@"#BBBBBB"];
        
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line2.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line3.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line4.backgroundColor = [UIColor colorWithHexString:@"#F2F3F5"];
        
        [self.btn1 setImage:[UIImage imageNamed:@"告警确认"] forState:UIControlStateNormal];
        [self.btn2 setImage:[UIImage imageNamed:@"应急处理"] forState:UIControlStateNormal];
        [self.btn3 setImage:[UIImage imageNamed:@"故障通告"] forState:UIControlStateNormal];
        [self.btn4 setImage:[UIImage imageNamed:@"设备排故"] forState:UIControlStateNormal];
        [self.btn5 setImage:[UIImage imageNamed:@"告警解决gray"] forState:UIControlStateNormal];
        self.image2.image = [UIImage imageNamed:@"kg_liucheng_slider_blue"];
        self.image3.image = [UIImage imageNamed:@"kg_liucheng_slider_blue"];
        self.image4.image = [UIImage imageNamed:@"kg_liucheng_slider_blue"];
    }else if ([recordStatus isEqualToString:@"completed"]) {//告警解决
        self.label1.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label2.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label3.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label4.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label5.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line2.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line3.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line4.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        
        [self.btn1 setImage:[UIImage imageNamed:@"告警确认"] forState:UIControlStateNormal];
        [self.btn2 setImage:[UIImage imageNamed:@"应急处理"] forState:UIControlStateNormal];
        [self.btn3 setImage:[UIImage imageNamed:@"故障通告"] forState:UIControlStateNormal];
        [self.btn4 setImage:[UIImage imageNamed:@"设备排故"] forState:UIControlStateNormal];
        [self.btn5 setImage:[UIImage imageNamed:@"告警解决"] forState:UIControlStateNormal];
     
        self.image2.image = [UIImage imageNamed:@"kg_liucheng_slider_blue"];
        self.image3.image = [UIImage imageNamed:@"kg_liucheng_slider_blue"];
        self.image4.image = [UIImage imageNamed:@"kg_liucheng_slider_blue"];
    }
    
    [self.botBtn setTitle:@"完成" forState:UIControlStateNormal];
    if ([recordStatus isEqualToString:@"unconfirmed"]) {
        
        self.botView.hidden = NO;
        [self.botView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.btn1.mas_centerX);
            make.top.equalTo(self.btn1.mas_bottom).offset(37);
            make.width.equalTo(@44);
            make.height.equalTo(@36);
        }];
    }else if ([recordStatus isEqualToString:@"confirmed"]) {//告警确认
//        [self.botBtn setTitle:@"确认" forState:UIControlStateNormal];
        self.botView.hidden = NO;
        [self.botView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.btn2.mas_centerX);
            make.top.equalTo(self.btn2.mas_bottom).offset(37);
            make.width.equalTo(@44);
            make.height.equalTo(@36);
        }];
        
    }else if ([recordStatus isEqualToString:@"emergency"]) {//应急处理
        self.botView.hidden = NO;
        [self.botView mas_remakeConstraints:^(MASConstraintMaker *make) {
                   make.centerX.equalTo(self.btn3.mas_centerX);
                   make.top.equalTo(self.btn3.mas_bottom).offset(37);
                   make.width.equalTo(@44);
                   make.height.equalTo(@36);
               }];
        
        
    }else if ([recordStatus isEqualToString:@"announce"]) {//故障通告
        self.botView.hidden = NO;
        [self.botView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.btn4.mas_centerX);
            make.top.equalTo(self.btn4.mas_bottom).offset(37);
            make.width.equalTo(@44);
            make.height.equalTo(@36);
        }];
    }else if ([recordStatus isEqualToString:@"shooting"]) {//设备排故
        self.botView.hidden = NO;
        [self.botView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.btn5.mas_centerX);
            make.top.equalTo(self.btn5.mas_bottom).offset(37);
            make.width.equalTo(@44);
            make.height.equalTo(@36);
        }];
    }else if ([recordStatus isEqualToString:@"completed"]) {//告警解决

        self.botView.hidden = YES;
       

    }
    
    
    if ([sstatus isEqualToString:@"removed"] || [hangUpStatus isEqualToString:@"YES"]) {//已解除
        self.label1.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label2.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label3.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label4.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.label5.textColor = [UIColor colorWithHexString:@"#004EC4"];
        self.line1.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line2.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line3.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        self.line4.backgroundColor = [UIColor colorWithHexString:@"#E2ECFF"];
        
        [self.btn1 setImage:[UIImage imageNamed:@"告警确认"] forState:UIControlStateNormal];
        [self.btn2 setImage:[UIImage imageNamed:@"应急处理"] forState:UIControlStateNormal];
        [self.btn3 setImage:[UIImage imageNamed:@"故障通告"] forState:UIControlStateNormal];
        [self.btn4 setImage:[UIImage imageNamed:@"设备排故"] forState:UIControlStateNormal];
        [self.btn5 setImage:[UIImage imageNamed:@"告警解决"] forState:UIControlStateNormal];
        self.image2.image = [UIImage imageNamed:@"kg_liucheng_slider_blue"];
        self.image3.image = [UIImage imageNamed:@"kg_liucheng_slider_blue"];
        self.image4.image = [UIImage imageNamed:@"kg_liucheng_slider_blue"];
        self.botView.hidden = YES;
    }
    
    
    
    
}

@end
