//
//  AlarmDetailController.h
//  Frame
//
//  Created by hibayWill on 2018/4/4.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlarmItems.h"

@interface AlarmDetailController : UIViewController{
    double htmlHeight;
    double allHeight;
    int countnum;
}
//@property UIViewController* from;/**< 类型 */
@property (assign, nonatomic) NSString* station_code;
@property (assign, nonatomic) NSString* id;
@property (assign, nonatomic) NSString* engine_room_code;
@property (assign, nonatomic) NSString* group;
@property (assign, nonatomic) NSString* level;
@property (strong, nonatomic) NSString* reStatus;
@property (strong, nonatomic) NSString* chooseStatus;
@property (strong, nonatomic) NSString* alarmStatus;
@property (strong, nonatomic) NSString* confirme_status;
@property (strong, nonatomic) NSString* hangupStatus;

@property (strong, nonatomic) NSString* start_time;
@property (strong, nonatomic) NSString* end_time;
@property (strong, nonatomic) AlarmItems * alarmInfo;


@end
