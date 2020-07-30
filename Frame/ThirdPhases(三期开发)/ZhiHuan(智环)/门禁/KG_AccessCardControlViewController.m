//
//  KG_KongTiaoControlViewController.m
//  Frame
//
//  Created by zhangran on 2020/5/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_AccessCardControlViewController.h"
#import "DoubleSliderView.h"
#import "UIView+Extension.h"
#import "Masonry.h"
#import "BAUISlider.h"
#import "KG_PowerOnView.h"
#import "CircleView.h"
#import "KG_NiControlView.h"

#import "KG_AccessCardAlertView.h"
#import "KG_AccessCardConfirmAlertView.h"
#import "KG_AccessCardInputPassAlertView.h"

@interface KG_AccessCardControlViewController ()

@property (nonatomic ,strong) UIButton *moreBtn ;

@property (nonatomic ,assign) NSInteger currIndex;

@property (nonatomic, strong) KG_NiControlView *niControlView;

@property (nonatomic ,strong) UIImageView *leftIcon;

@property (nonatomic ,strong) UILabel *leftTitle;

@property (nonatomic ,strong) UIButton *openBtn ;
@property (nonatomic ,strong) UIButton *closeBtn ;

@property (nonatomic ,strong) KG_AccessCardAlertView          *alertView;
@property (nonatomic ,strong) KG_AccessCardInputPassAlertView *inputPassAlertView;
@property (nonatomic ,strong) KG_AccessCardConfirmAlertView   *confirmAlertView;

@property (nonatomic ,copy) NSString *passString;
@property (nonatomic ,copy) NSString *secondString;
@end

@implementation KG_AccessCardControlViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.currIndex = 0;
    self.view.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self createView];

}


- (void)createView {
    self.leftIcon = [[UIImageView alloc]init];
    [self.view addSubview:self.leftIcon];
    self.leftIcon.image  = [UIImage imageNamed:@"门禁"];
    [self.leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(18);
        make.width.equalTo(@15);
        make.top.equalTo(self.view.mas_top).offset(21);
        make.height.equalTo(@12);
    }];
    
    self.leftTitle = [[UILabel alloc]init];
    [self.view addSubview:self.leftTitle];
    self.leftTitle.text = @"门禁";
    self.leftTitle.textColor = [UIColor colorWithHexString:@"#24252A"];
    self.leftTitle.font = [UIFont boldSystemFontOfSize:14];
    self.leftTitle.textAlignment = NSTextAlignmentLeft;
    [self.leftTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.leftIcon.mas_right).offset(5);
        make.centerY.equalTo(self.leftIcon.mas_centerY);
        make.height.equalTo(@21);
        make.width.equalTo(@100);
    }];
    
    self.moreBtn = [[UIButton alloc]init];
    [self.view addSubview:self.moreBtn];
    [self.moreBtn addTarget:self action:@selector(moreMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn setTitleColor:[UIColor colorWithHexString:@"#1860B0"] forState:UIControlStateNormal];
    self.moreBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    [self.moreBtn setImage:[UIImage imageNamed:@"blue_jiantou"] forState:UIControlStateNormal];
    [self.moreBtn setTitle:@"事件日志" forState:UIControlStateNormal];
    [self.moreBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 75, 0, 0)];
    [self.moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-16);
        make.height.equalTo(@20);
        make.centerY.equalTo(self.leftTitle.mas_centerY);
        make.width.equalTo(@80);
    }];
    
    
    UIView *lineView = [[UIView alloc]init];
    [self.view addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#EFF0F7"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(19);
        make.right.equalTo(self.view.mas_right).offset(-12);
        make.top.equalTo(self.leftTitle.mas_bottom).offset(15);
        make.height.equalTo(@0.5);
    }];
    
    self.openBtn = [[UIButton alloc]init];
    [self.view addSubview:self.openBtn];
    [self.openBtn setBackgroundImage:[UIImage imageNamed:@"Access_OpenDoor_Icon"] forState:UIControlStateNormal];
    [self.openBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@226);
        make.height.equalTo(@92);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.leftTitle.mas_bottom).offset(50);
    }];
    [self.openBtn addTarget:self action:@selector(openMethod:) forControlEvents:UIControlEventTouchUpInside];
    self.closeBtn = [[UIButton alloc]init];
    [self.view addSubview:self.closeBtn];
    [self.closeBtn setBackgroundImage:[UIImage imageNamed:@"Access_CloseDoor_Icon"] forState:UIControlStateNormal];
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@226);
        make.height.equalTo(@92);
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.openBtn.mas_bottom).offset(30);
    }];
    [self.closeBtn addTarget:self action:@selector(closeMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

//开门
- (void)openMethod:(UIButton *)openBtn {
    [JSHmainWindow addSubview:self.inputPassAlertView];
    self.inputPassAlertView.confirmMehtod = ^(NSString * _Nonnull passStirng) {
        
        self.passString = passStirng;
        [self checkPasswordData];
      
    } ;
    [self.inputPassAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
        make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
        make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
        make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
        
    }];
}
//关门
- (void)closeMethod:(UIButton *)closeBtn {
    
    [JSHmainWindow addSubview:self.confirmAlertView];
    self.confirmAlertView.confirmMehtod = ^{
        [self closeDoorMethod];
    };
    [self.confirmAlertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
        make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
        make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
        make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
        
    }];
    
    
}


- (void)moreMethod:(UIButton *)button {
    
    if (self.controlLog) {
        self.controlLog(self.dataDic);
    }
    
}





- (KG_NiControlView *)niControlView {
    
    if (!_niControlView) {
        _niControlView = [[KG_NiControlView alloc]init];
        [JSHmainWindow addSubview:self.niControlView];
        [self.niControlView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
            make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
        }];
        
    }
    return _niControlView;
    
}


- (void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    
  
    
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
  
    self.leftIcon.image = [UIImage imageNamed:[CommonExtension getDeviceIcon:safeString(_dataDic[@"category"])]];
    
  

}

- (void)animationAlert:(UIView *)view

{

    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];

    popAnimation.duration = 0.4;

    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],

                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],

                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],

                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];

    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];

    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],

                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],

                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];

    [view.layer addAnimation:popAnimation forKey:nil];

    

}


- (KG_AccessCardAlertView *)alertView {
    
    if (!_alertView) {
        _alertView = [[KG_AccessCardAlertView alloc]init];
        
    }
    return _alertView;
}

- (KG_AccessCardInputPassAlertView *)inputPassAlertView {
    
    if (!_inputPassAlertView) {
        _inputPassAlertView = [[KG_AccessCardInputPassAlertView alloc]init];
        
    }
    return _inputPassAlertView;
}

- (KG_AccessCardConfirmAlertView *)confirmAlertView {
    
    if (!_confirmAlertView) {
        _confirmAlertView = [[KG_AccessCardConfirmAlertView alloc]init];
        
    }
    return _confirmAlertView;
}

//门禁开门
- (void)goToOpenDoorMethod {
    [self openData];
  
}
//门禁关门
- (void)closeDoorMethod {
    [self closeData];
}


//检查密码校验
- (void)checkPasswordData {
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:@"/intelligent/DoorEvent/verify"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"stationCode"] = self.currentStationDic[@"stationCode"];
    
    params[@"stationCode"] = safeString(self.dataDic[@"stationCode"]);
    params[@"equipmentCode"] = safeString(self.dataDic[@"code"]);
    params[@"password"] = safeString(self.passString);
    [FrameBaseRequest postWithUrl:FrameRequestURL param:params success:^(id result) {
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code != 0){
            
            return ;
        }
        
        NSLog(@"resultresult %@",result);
        NSString *s = safeString(result[@"value"]);
        if ([s isEqualToString:@"Wrong"]) {
            [FrameBaseRequest showMessage:@"密码校验失败"];
            return;
        }
        [JSHmainWindow addSubview:self.alertView];
        self.alertView.confirmMehtod = ^(NSString * _Nonnull passStirng) {
            self.secondString = passStirng;
            [self goToOpenDoorMethod];
        };
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo([UIApplication sharedApplication].keyWindow.mas_left);
            make.right.equalTo([UIApplication sharedApplication].keyWindow.mas_right);
            make.top.equalTo([UIApplication sharedApplication].keyWindow.mas_top);
            make.bottom.equalTo([UIApplication sharedApplication].keyWindow.mas_bottom);
            
        }];
       
    }  failure:^(NSError *error) {
        NSLog(@"请求失败 原因：%@",error);
      
        [FrameBaseRequest showMessage:@"网络链接失败"];
        return ;
    } ];
    
}
//
//门禁密码校验接口：
//请求地址：/
//请求方式：POST
//请求内容：AtcBackwardControl对象，即：
//{
//    "stationCode": "XXX",               //台站编码
//"equipmentCode": "XXX",            //设备编码
//"password": "XXX"                  //密码
//}
//请求返回：
//如：
//{
//          "stationCode": "DDDHT",
//"equipmentCode": "DDDHT-SXYJFDoor",
//"password": "admin"
//}


//
//门禁反向控制接口：
//请求地址：
///intelligent/DoorEvent/control/{stationCode}/{equipmentCode}/{value}/{interval}
//其中，stationCode是台站编码
//      equipmentCode是设备编码
//      value是on/off，开门取值on，关门取值off
//      interval是开门时长：
//当value是on时，为开门时长。
//当value是off时，默认填充0即可。
//请求方式：GET
//请求返回：
//如：
//http://140.249.55.11:8089/intelligent/DoorEvent/control/DDDHT/DDDHT-SXYJFDoor/on/5
//         调试设备：
//http://192.168.100.173:8089/intelligent/DoorEvent/control/S1/HGLDoorDevice/on/10
//返回：
//   成功返回：
//{
//    "errCode": 0,
//    "errMsg": "",
//    "value": {
//        "result": "Send Success"   //直接返回发送成功
////因为耗时，后台会另起线程进行处理，前台不必注重控制的结果
////远程控制的结果会在日志中呈现
//    }
//}
//进行操作
- (void)openData {
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/DoorEvent/control/%@/%@/%@/%@",safeString(self.dataDic[@"stationCode"]),safeString(self.dataDic[@"code"]),@"on",safeString(self.secondString)]];
//    [MBProgressHUD showMessage:@"" toView:self.view];
    [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
        [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
        NSDictionary *valueDic = result[@"value"];
        if ([safeString(valueDic[@"result"]) isEqualToString:@"Send Success"]) {
            [FrameBaseRequest showMessage:@"操作成功"];
        }else {
            [FrameBaseRequest showMessage:@"操作失败"];
        }
        NSLog(@"完成");
        
        NSLog(@"");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSLog(@"完成");
         [MBProgressHUD hideHUD];
    }];
    
}
- (void)closeData {
    NSString *  FrameRequestURL = [WebNewHost stringByAppendingString:[NSString stringWithFormat:@"/intelligent/DoorEvent/control/%@/%@/%@/%@",safeString(self.dataDic[@"stationCode"]),safeString(self.dataDic[@"code"]),@"off",@"0"]];
//     [MBProgressHUD showMessage:@"" toView:self.view];
    [FrameBaseRequest getDataWithUrl:FrameRequestURL param:nil success:^(id result) {
         [MBProgressHUD hideHUD];
        NSInteger code = [[result objectForKey:@"errCode"] intValue];
        if(code  <= -1){
            [FrameBaseRequest showMessage:result[@"errMsg"]];
            return ;
        }
     
        NSLog(@"完成");
        NSDictionary *valueDic = result[@"value"];
        if ([safeString(valueDic[@"result"]) isEqualToString:@"Send Success"]) {
            [FrameBaseRequest showMessage:@"操作成功"];
        }else {
            [FrameBaseRequest showMessage:@"操作失败"];
        }
        NSLog(@"");
    } failure:^(NSURLSessionDataTask *error)  {
        FrameLog(@"请求失败，返回数据 : %@",error);
        NSLog(@"完成");
         [MBProgressHUD hideHUD];
        
    }];
    
}

@end
