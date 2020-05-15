//
//  FrameScrollListself.m
//  Frame
//
//  Created by zhangran on 2020/3/23.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "FrameScrollListCell.h"

@interface FrameScrollListCell (){
    
    
    
}
@property (retain, nonatomic) IBOutlet UIImageView *iconImage;
@property (retain, nonatomic) IBOutlet UILabel *titleLabel;
//第一个
@property (retain, nonatomic) IBOutlet UILabel *firstTitleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *firstStatusLabel;

//第二个
@property (retain, nonatomic) IBOutlet UILabel *secondTitleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *secondStatusLabel;

//第三个
@property (retain, nonatomic) IBOutlet UILabel *thirdTitleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *thirdStatusLabel;

//第四个
@property (retain, nonatomic) IBOutlet UILabel *fourthTitleLabel;
@property (retain, nonatomic) IBOutlet UIImageView *fourthStatusLabel;


@property (retain, nonatomic) IBOutlet UILabel *firstNumLabel;
@property (retain, nonatomic) IBOutlet UILabel *secondNumLabel;
@property (retain, nonatomic) IBOutlet UILabel *thirdNumLabel;

@property (retain, nonatomic) IBOutlet UILabel *fourthNumLabel;





@end
@implementation FrameScrollListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.firstNumLabel.layer.cornerRadius = 4.f;
    self.firstNumLabel.layer.masksToBounds = YES;
    
    self.secondNumLabel.layer.cornerRadius = 4.f;
    self.secondNumLabel.layer.masksToBounds = YES;
    
    self.thirdNumLabel.layer.cornerRadius = 4.f;
    self.thirdNumLabel.layer.masksToBounds = YES;
    
    self.fourthNumLabel.layer.cornerRadius = 4.f;
    self.fourthNumLabel.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (IBAction)buttonClickedMethod:(id)sender {
}

- (void)dealloc {
  
    [super dealloc];
}
- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    if ([dataDic count] == 0) {
        return;
    }
    self.titleLabel.text = [NSString stringWithFormat:@"%@",self.dataDic[@"station"][@"name"]];
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString: [NSString stringWithFormat:@"%@%@",WebHost,self.dataDic[@"station"][@"picture"]]] placeholderImage:[UIImage imageNamed:@"station_indexbg"] ];
    NSDictionary *dic = [dataDic objectForKey:@"equipmentStatus"];


    if([dic[@"status"] isEqualToString:@"0"] ||[dic count] ==0){
        //正常
        self.firstStatusLabel.image = [UIImage imageNamed:@"level_normal"];
    }else if([dic[@"status"] isEqualToString:@"3"] ){
        //正常
        self.firstStatusLabel.image = [UIImage imageNamed:@"level_normal"];
    }else{
        int isNullm = isNullm( dic[@"num"]);
        NSString *equipNum = isNullm == 1?dic[@"num"]:@"0";
        self.firstNumLabel.text = [NSString stringWithFormat:@"%@",equipNum];
        self.firstNumLabel.backgroundColor = [self getTextColor:dic[@"level"]];
        if (isNullm >0) {
            self.firstNumLabel.hidden = NO;
        }else {
            self.firstNumLabel.hidden = YES;
        }
        self.firstStatusLabel.image = [UIImage imageNamed:[self getLevelImage:dic[@"level"]]];
    }

    


    dic = [dataDic objectForKey:@"powerStatus"];


    if([dic[@"status"] isEqualToString:@"0"] ||[dic count] ==0){
        //正常
        self.secondStatusLabel.image = [UIImage imageNamed:@"level_normal"];
    }else if([dic[@"status"] isEqualToString:@"3"] ){
        //正常
        self.secondStatusLabel.image = [UIImage imageNamed:@"level_normal"];
    }else{
        int isNullm = isNullm( dic[@"num"]);
        NSString *equipNum = isNullm == 1?dic[@"num"]:@"0";
        self.secondNumLabel.text = [NSString stringWithFormat:@"%@",equipNum];
        self.secondNumLabel.backgroundColor = [self getTextColor:dic[@"level"]];
        if (isNullm >0) {
            self.secondNumLabel.hidden = NO;
        }else {
            self.secondNumLabel.hidden = YES;
        }
        self.secondStatusLabel.image = [UIImage imageNamed:[self getLevelImage:dic[@"level"]]];
    }



    dic = [dataDic objectForKey:@"environmentStatus"];


    if([dic[@"status"] isEqualToString:@"0"] ||[dic count] ==0){
        //正常
        self.thirdStatusLabel.image = [UIImage imageNamed:@"level_normal"];
    }else if([dic[@"status"] isEqualToString:@"3"] ){
        //正常
        self.thirdStatusLabel.image = [UIImage imageNamed:@"level_normal"];
    }else{
        int isNullm = isNullm( dic[@"num"]);
        NSString *equipNum = isNullm == 1?dic[@"num"]:@"0";
        self.thirdNumLabel.text = [NSString stringWithFormat:@"%@",equipNum];
        self.thirdNumLabel.backgroundColor = [self getTextColor:dic[@"level"]];
        if (isNullm >0) {
            self.thirdNumLabel.hidden = NO;
        }else {
            self.thirdNumLabel.hidden = YES;
        }
        self.thirdStatusLabel.image = [UIImage imageNamed:[self getLevelImage:dic[@"level"]]];
    }



    dic = [dataDic objectForKey:@"securityStatus"];


    if([dic[@"status"] isEqualToString:@"0"] ||[dic count] ==0){
        //正常
        self.fourthStatusLabel.image = [UIImage imageNamed:@"level_normal"];
    }else if([dic[@"status"] isEqualToString:@"3"] ){
        //正常
        self.fourthStatusLabel.image = [UIImage imageNamed:@"level_normal"];
    }else{
        int isNullm = isNullm( dic[@"num"]);
        NSString *equipNum = isNullm == 1?dic[@"num"]:@"0";
        self.fourthNumLabel.text = [NSString stringWithFormat:@"%@",equipNum];
        self.fourthNumLabel.backgroundColor = [self getTextColor:dic[@"level"]];
        if (isNullm >0) {
            self.fourthNumLabel.hidden = NO;
        }else {
            self.fourthNumLabel.hidden = YES;
        }
        self.fourthStatusLabel.image = [UIImage imageNamed:[self getLevelImage:dic[@"level"]]];
    }

    
    
}


- (NSString *)getLevelImage:(NSString *)level {
    NSString *levelString = @"level_normal";
    
    if ([level isEqualToString:@"0"]) {
        levelString = @"level_normal";
    }else if ([level isEqualToString:@"4"]) {
        levelString = @"level_prompt";
    }else if ([level isEqualToString:@"3"]) {
        levelString = @"level_ciyao";
    }else if ([level isEqualToString:@"2"]) {
        levelString = @"level_important";
    }else if ([level isEqualToString:@"1"]) {
        levelString = @"level_jinji";
    }
    
    //紧急
    return levelString;
}


- (UIColor *)getTextColor:(NSString *)level {
    UIColor *textColor = [UIColor colorWithHexString:@"FFFFFF"];
    
    if ([level isEqualToString:@"0"]) {
        textColor = [UIColor colorWithHexString:@"FFFFFF"];
    }else if ([level isEqualToString:@"4"]) {
        textColor = [UIColor colorWithHexString:@"2986F1"];
    }else if ([level isEqualToString:@"3"]) {
        textColor = [UIColor colorWithHexString:@"FFA800"];
    }else if ([level isEqualToString:@"2"]) {
        textColor = [UIColor colorWithHexString:@"FC7D0E"];
    }else if ([level isEqualToString:@"1"]) {
        textColor = [UIColor colorWithHexString:@"F62546"];
    }
    
    //紧急
    return textColor;
}
@end
