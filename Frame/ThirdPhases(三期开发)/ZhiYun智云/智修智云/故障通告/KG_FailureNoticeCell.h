//
//  KG_FailureNoticeCell.h
//  Frame
//
//  Created by zhangran on 2020/10/21.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_FailureNoticeCell : UITableViewCell

@property (nonatomic,strong) NSDictionary  *dataDic ;

@property (nonatomic,strong) NSArray       *listArray ;


@property (nonatomic,strong) void(^bottomButtonBlock)(BOOL isshouqi);



@property (nonatomic,strong) void(^pushToNextStep)(NSDictionary *dataDic);
@end

NS_ASSUME_NONNULL_END
