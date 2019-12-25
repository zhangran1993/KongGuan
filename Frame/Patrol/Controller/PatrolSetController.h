//
//  PatrolSetController.h
//  Frame
//
//  Created by hibayWill on 2018/3/29.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PatrolSetDelegate <NSObject>
@optional
-(void)deleteClick:(int) indexPathRow;//点击删除
@end

@interface PatrolSetController : UIViewController
{

    
}
@property (nonatomic,copy) NSString * stationName;
@property (nonatomic,copy) NSString * stationCode;
@property (nonatomic,copy) NSString * specialCode;
@property (nonatomic,copy) NSString * status;

@property (nonatomic,copy) NSString * type_code;
@property (nonatomic,copy) NSString * id;
@property (nonatomic,copy) NSString * patrolRecordId;
@end
