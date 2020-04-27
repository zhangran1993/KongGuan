//
//  KG_RoomInfoView.h
//  Frame
//
//  Created by zhangran on 2020/4/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_RoomInfoView : UIView
@property(nonatomic, strong) NSArray *powArray;

@property(nonatomic, copy)void (^didsel)(int index);

@property(nonatomic, strong) NSDictionary *roomInfo;
@property (nonatomic, assign) int selIndex;
@end

NS_ASSUME_NONNULL_END
