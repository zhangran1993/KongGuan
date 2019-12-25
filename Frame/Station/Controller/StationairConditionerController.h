//
//  StationairConditionerController.h
//  Frame
//
//  Created by hibayWill on 2018/5/14.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+CBPopup.h"

@interface StationairConditionerController : UIViewController{
    double allHeight;
    int countnum;
}
@property (strong,nonatomic) NSString* engine_room_code;/**机房编码 */
@property (strong,nonatomic) NSString* engine_room_name;
@property  int clickNum;


@end
