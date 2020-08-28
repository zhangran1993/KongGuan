//
//  KG_EquipCardFourthCell.m
//  Frame
//
//  Created by zhangran on 2020/7/16.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipCardFourthCell.h"

@interface KG_EquipCardFourthCell (){
    
}
@property (nonatomic, strong) UIView         *sliderBgView;
@property (nonatomic, strong) UIView         *sliderView;
@property (nonatomic, strong) UIScrollView   *scrollView;
@property (nonatomic, strong) UILabel        *numLabel;
@property (nonatomic, strong) UILabel        *totalNumLabel;

@end

@implementation KG_EquipCardFourthCell

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
        self.backgroundColor =[UIColor colorWithHexString:@"#F6F7F9"];
        [self createSubviewsView];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cardScrollIndex:) name:@"cardScrollIndex" object:nil];
       
    }
    return self;
}

- (void)createSubviewsView {
    
    self.sliderBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 7, SCREEN_WIDTH, 26)];
    [self addSubview:self.sliderBgView];
    self.sliderBgView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    
    float sliderV_X = SCREEN_WIDTH/2-60;
    float sliderVX =  sliderV_X;
    UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(sliderVX, 10, 6, 6)];
    
    sliderV.layer.cornerRadius = 3;
    sliderV.backgroundColor = [UIColor colorWithHexString:@"#005DC4"];
    [self.sliderBgView insertSubview:sliderV atIndex:1];
    _sliderView=sliderV;
    if (self.totalNum > 0) {
        for (int i = 0; i <self.totalNum; i++) {
            //滑块
            float sliderV_X =SCREEN_WIDTH /2-60+ i*10;
            //float sliderVX = WIDTH_SCREEN - FrameWidth(sliderV_X);
            
            float sliderX = sliderV_X;//WIDTH_SCREEN - FrameWidth(i*18+30);
            UIView *sliderV=[[UIView alloc]initWithFrame:CGRectMake(sliderX,  10, 6, 6)];
            sliderV.layer.cornerRadius = 3;
            sliderV.alpha= 0.19;
            sliderV.backgroundColor = [UIColor colorWithHexString:@"#005DC4"];
            [self.sliderBgView insertSubview:sliderV atIndex:0];
            
        }
    }
    
    
    self.totalNumLabel = [[UILabel alloc]init];
    [self.sliderBgView addSubview:self.totalNumLabel];
    self.totalNumLabel.textColor = [UIColor colorWithHexString:@"#D0CFCF"];
    self.totalNumLabel.numberOfLines = 1;
    self.totalNumLabel.textAlignment = NSTextAlignmentLeft;
    self.totalNumLabel.font = [UIFont systemFontOfSize:14];
    [self.totalNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-5);
        make.width.equalTo(@20);
        make.height.equalTo(@13);
        make.centerY.equalTo(self.sliderBgView.mas_centerY);
    }];
    
    self.numLabel = [[UILabel alloc]init];
    [self.sliderBgView addSubview:self.numLabel];
    self.numLabel.textColor = [UIColor colorWithHexString:@"#3860B8"];
    self.numLabel.numberOfLines = 1;
    self.numLabel.textAlignment = NSTextAlignmentRight;
    self.totalNumLabel.font = [UIFont systemFontOfSize:16];
    [self.numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.totalNumLabel.mas_left);
        make.width.equalTo(@40);
        make.height.equalTo(@13);
        make.centerY.equalTo(self.sliderBgView.mas_centerY);
    }];

}
//sign) int selIndex;
//
//@property (nonatomic ,assign) int totalNum;

- (void)setTotalNum:(int)totalNum {
    _totalNum = totalNum;
    self.totalNumLabel.text = [NSString stringWithFormat:@"/%d",totalNum];
    
    [self.sliderBgView removeFromSuperview];
    self.sliderBgView = nil;
    [self createSubviewsView];
}

- (void)setSelIndex:(int)selIndex {
    _selIndex = selIndex;
    self.numLabel.text = [NSString stringWithFormat:@"%d",self.selIndex];
    self.totalNumLabel.text = [NSString stringWithFormat:@"/%d",self.totalNum];
       
}
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
   
    
}
////选择某个标题
//- (void)setSelIndex:(int)selIndex {
//
//    
//
//}
-(void)dealloc
{
    [super dealloc];
    //第一种方法.这里可以移除该控制器下的所有通知
    //移除当前所有通知
    NSLog(@"移除了所有的通知");
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

//实现方法
-(void)cardScrollIndex:(NSNotification *)notification{
    NSLog(@"接收 不带参数的消息");
    NSString *str = notification.object;
    
    self.numLabel.text = [NSString stringWithFormat:@"%@",str];
    
    [UIView animateWithDuration:0.3 animations:^{
        if ([str floatValue] >0) {
            float sliderV_X = SCREEN_WIDTH/2-60 + ( [str floatValue]-1)*10;
            //float sliderVX = WIDTH_SCREEN - FrameWidth(sliderV_X);
            
            float sliderX =  sliderV_X;//WIDTH_SCREEN - FrameWidth(i*18+30);
            _sliderView.frame = CGRectMake(sliderX,10, 6, 6);
            //NSLog(@"selectButton  %f",sliderX);
            [self.sliderBgView insertSubview:_sliderView atIndex:10];
            
            self.numLabel.text = [NSString stringWithFormat:@"%@",str];
            self.totalNumLabel.text = [NSString stringWithFormat:@"/%d",self.totalNum];
        }else {
            float sliderV_X = SCREEN_WIDTH/2-60 + ( [str floatValue])*10;
            //float sliderVX = WIDTH_SCREEN - FrameWidth(sliderV_X);
            
            float sliderX =  sliderV_X;//WIDTH_SCREEN - FrameWidth(i*18+30);
            _sliderView.frame = CGRectMake(sliderX,10, 6, 6);
            //NSLog(@"selectButton  %f",sliderX);
            [self.sliderBgView insertSubview:_sliderView atIndex:10];
            
            self.numLabel.text = [NSString stringWithFormat:@"%@",str];
            self.totalNumLabel.text = [NSString stringWithFormat:@"/%d",self.totalNum];
        }
        
    }];
}
@end
