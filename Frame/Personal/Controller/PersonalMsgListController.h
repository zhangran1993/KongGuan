//
//  PersonalMsgListController.h
//  Frame
//
//  Created by hibayWill on 2018/3/31.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalMsgListController : UIViewController{
    double htmlHeight;
    double allHeight;
    int countnum;
}
//@property UIViewController* from;/**< 类型 */
@property  int sid;
@property (strong,nonatomic)NSString* thistitle;
@property (strong,nonatomic)NSString* from;


@end
