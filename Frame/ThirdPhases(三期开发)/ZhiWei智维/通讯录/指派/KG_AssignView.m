//
//  KG_AssignView.m
//  Frame
//
//  Created by zhangran on 2020/9/8.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_AssignView.h"

@interface KG_AssignView (){
    
}

@property (nonatomic, strong)  UIButton           *bgBtn ;

@property (nonatomic, strong)  UIView             *centerView;

@property (nonatomic, strong)  UILabel             *nameLabel;

@end

@implementation KG_AssignView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initData];
        [self setupDataSubviews];
    }
    return self;
}
//初始化数据
- (void)initData {
    
}

//创建视图
-(void)setupDataSubviews
{
    //按钮背景 点击消失
    self.bgBtn = [[UIButton alloc]init];
    [self addSubview:self.bgBtn];
    [self.bgBtn setBackgroundColor:[UIColor colorWithHexString:@"#000000"]];
    self.bgBtn.alpha = 0.46;
    [self.bgBtn addTarget:self action:@selector(buttonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.centerView = [[UIView alloc] init];
    self.centerView.frame = CGRectMake(52.5,209,270,242);
    self.centerView.backgroundColor = [UIColor whiteColor];
    self.centerView.layer.cornerRadius = 12;
    self.centerView.layer.masksToBounds = YES;
    [self addSubview:self.centerView];
    
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.mas_top).offset((SCREEN_HEIGHT -151)/2);
        make.left.equalTo(self.mas_left).offset((SCREEN_WIDTH - 270)/2);
        
        make.width.equalTo(@270);
        make.height.equalTo(@151);
    }];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [self.centerView addSubview:titleLabel];
    titleLabel.text = @"请选择被指派人员";
    titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightBold];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.numberOfLines = 1;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerView.mas_centerX);
        make.top.equalTo(self.centerView.mas_top);
        make.width.equalTo(@200);
        make.height.equalTo(@52);
    }];
    
    
    
    
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
    [self.centerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.mas_bottom).offset(-44);
        make.height.equalTo(@1);
        make.width.equalTo(@270);
        make.left.equalTo(self.centerView.mas_left);
        make.right.equalTo(self.centerView.mas_right);
    }];
    
    UIImageView *rightImage = [[UIImageView alloc]init];
    [self.centerView addSubview:rightImage];
    rightImage.image = [UIImage imageNamed:@"kg_assign_rightIcon"];
    [rightImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView.mas_right).offset(-17);
        make.height.width.equalTo(@14);
        make.bottom.equalTo(lineView.mas_top).offset(-26);
    }];
    
    UIImageView *addImage = [[UIImageView alloc]init];
    [self.centerView addSubview:addImage];
    addImage.image = [UIImage imageNamed:@"kg_assign_addIcon"];
    [addImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(rightImage.mas_left).offset(-3);
        make.height.width.equalTo(@18);
        make.centerY.equalTo(rightImage.mas_centerY);
    }];
    
    UIButton *addBtn = [[UIButton alloc]init];
    [self.centerView addSubview:addBtn];
    [addBtn setTitle:@"" forState:UIControlStateNormal];
    [addBtn setBackgroundColor:[UIColor clearColor]];
    [addBtn addTarget:self action:@selector(addContact:) forControlEvents:UIControlEventTouchUpInside];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView.mas_right).offset(-20);
        make.width.equalTo(@100);
        make.centerY.equalTo(rightImage.mas_centerY);
        make.height.equalTo(@60);
    }];
    
    
    self.nameLabel = [[UILabel alloc]init];
    [self.centerView addSubview:self.nameLabel];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"#626470"];
    self.nameLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.numberOfLines = 1;
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left).offset(20.5);
        make.width.equalTo(@200);
        make.height.equalTo(@30);
        make.centerY.equalTo(addBtn.mas_centerY);
    }];
    
    self.nameLabel.text = @"执行负责人：";
    
    
    UIButton *cancelBtn = [[UIButton alloc]init];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.centerView addSubview:cancelBtn];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:17];
    [cancelBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelMethod:) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left);
        make.top.equalTo(lineView.mas_bottom);
        make.width.equalTo(@135);
        make.height.equalTo(@43);
    }];
    
    
    UIButton *confirmBtn = [[UIButton alloc]init];
    [self.centerView addSubview:confirmBtn];
    [confirmBtn setTitle:@"指派" forState:UIControlStateNormal];
    [confirmBtn setTitleColor:[UIColor colorWithHexString:@"#004EC4"] forState:UIControlStateNormal];
    [confirmBtn addTarget:self action:@selector(confirmMethod:) forControlEvents:UIControlEventTouchUpInside];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.centerView.mas_right);
        make.top.equalTo(lineView.mas_bottom);
        make.width.equalTo(@135);
        make.height.equalTo(@43);
    }];
    UIView *botLine = [[UIView alloc]init];
    botLine.backgroundColor = [UIColor colorWithHexString:@"#E6E8ED"];
    [self.centerView addSubview:botLine];
    [botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.centerView.mas_centerX);
        make.bottom.equalTo(self.centerView.mas_bottom);
        make.width.equalTo(@1);
        make.height.equalTo(@43);
    }];
  
}

//添加联系人
- (void)addContact:(UIButton *)button {
  
   [[NSNotificationCenter defaultCenter] postNotificationName:@"pushToAddressBook" object:self];
}

//取消
- (void)cancelMethod:(UIButton *)button {
    [self removeFromSuperview];
   
}
//确定
- (void)confirmMethod:(UIButton *)button {
    
    if(self.name.length == 0) {
        [FrameBaseRequest showMessage:@"请选择执行负责人"];
        return;
    }
    
    if (self.confirmBlockMethod) {
        self.confirmBlockMethod(self.dataDic,self.name,self.nameID);
    }
    [self removeFromSuperview];
}

- (void)buttonClickMethod:(UIButton *)btn {
    [self removeFromSuperview];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    
}

- (void)setName:(NSString *)name {
    _name = name;
    self.nameLabel.text = [NSString stringWithFormat:@"执行负责人:%@",safeString(name)];
    
}

- (void)setNameID:(NSString *)nameID {
    _nameID = nameID;
}
@end
