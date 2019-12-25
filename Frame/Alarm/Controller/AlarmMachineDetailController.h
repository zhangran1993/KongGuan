//
//  AlarmMachineDetailController.h
//  Frame
//
//  Created by hibayWill on 2018/4/8.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmMachineDetailController : UIViewController{
    double htmlHeight;
    double allHeight;
    int countnum;
    
}


@property (assign, nonatomic) NSDictionary* machineInfo;
@property (assign, nonatomic) NSString* id;
@property (assign, nonatomic) NSString* code;
@property (assign, nonatomic) NSString* status;
@property (assign, nonatomic) NSString* model;

@end
