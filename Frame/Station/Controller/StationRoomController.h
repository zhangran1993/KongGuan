//
//  StationRoomController.h
//  Frame
//
//  Created by hibayWill on 2018/3/30.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+CBPopup.h"

@interface StationRoomController : UIViewController{
    double htmlHeight;
    double allHeight;
    int countnum;
}
//@property UIViewController* from;/**< 类型 */
@property  int sid;
@property (assign, nonatomic) NSString* room_code;
@property (assign, nonatomic) NSString* room_name;
@property (assign, nonatomic) NSString* imageUrl;

@property (assign, nonatomic) NSString* station_code;
@property (assign, nonatomic) NSString* station_name;

@end
