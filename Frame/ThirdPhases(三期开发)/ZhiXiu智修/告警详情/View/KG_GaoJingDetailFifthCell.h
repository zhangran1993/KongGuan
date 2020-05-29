//
//  KG_GaoJingDetailFifthCell.h
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KG_GaoJingDetailModel.h"


@interface KG_GaoJingDetailFifthCell : UITableViewCell
@property (nonatomic,strong) KG_GaoJingDetailModel *model;
@property (nonatomic,strong) NSString * recordDescription;
@property(nonatomic ,strong) void(^fixMethod)();
@end


