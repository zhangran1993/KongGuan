//
//  KG_KongTiaoDetailViewController.h
//  Frame
//
//  Created by zhangran on 2020/4/15.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KG_KongTiaoDetailViewController : UIViewController{
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

@property (nonatomic ,copy) void (^moreAction)();

@end
