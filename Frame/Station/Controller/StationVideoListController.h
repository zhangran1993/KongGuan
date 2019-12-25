//
//  StationVideoListController.h
//  Frame
//
//  Created by hibayWill on 2018/3/30.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+CBPopup.h"

@interface StationVideoListController : UIViewController{
    double htmlHeight;
    double allHeight;
    int countnum;
}
@property (strong,nonatomic) NSString* station_code;/**< 类型 */
@property (strong,nonatomic) NSString* station_name;
@property  int sid;


@end
