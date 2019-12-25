//
//  StationMachineDetailController.h
//  Frame
//
//  Created by hibayWill on 2018/3/30.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StationMachineDetailController : UIViewController{
    double htmlHeight;
    double allHeight;
    int countnum;
}
//@property UIViewController* from;/**< 类型 */
@property  int sid;

@property (assign, nonatomic) NSString* station_code;
@property (assign, nonatomic) NSString* category;
@property (assign, nonatomic) NSString* engine_room_code;
@property (copy, nonatomic) NSDictionary * machineDetail;

@end
