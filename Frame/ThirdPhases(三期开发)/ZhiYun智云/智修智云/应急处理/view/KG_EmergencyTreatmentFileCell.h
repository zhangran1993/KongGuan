//
//  KG_EmergencyTreatmentFirstCell.h
//  Frame
//
//  Created by zhangran on 2020/10/29.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KG_EmergencyTreatmentFileCell : UITableViewCell

@property (nonatomic, strong) NSArray *topArray;

@property (nonatomic, strong) void (^zhanKaiMethod)(BOOL iszhankai);

@property (nonatomic, assign)   BOOL                    isZhanKai;


@property (nonatomic, strong) void (^pushToNextStep)(NSDictionary *dataDic);

@end

NS_ASSUME_NONNULL_END
