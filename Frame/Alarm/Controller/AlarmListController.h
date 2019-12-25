//
//  AlarmListController.h
//  Frame
//
//  Created by hibayWill on 2018/4/4.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+CBPopup.h"

@interface AlarmListController : UIViewController{
    
}

@property (assign, nonatomic) NSString* station_code;
@property (assign, nonatomic) NSString* station_name;
@property (assign, nonatomic) NSString* engine_room_code;
@property (assign, nonatomic) NSString* group;
@property (assign, nonatomic) NSString* level;
@property (assign, nonatomic) NSString* status;
@property (assign, nonatomic) NSString* confirme_status;
@property (assign, nonatomic) NSString* start_time;
@property (assign, nonatomic) NSString* end_time;
@property (assign, nonatomic) NSString* hangup_status;

@end
