//
//  PatrolHistoryCell.m
//  Frame
//
//  Created by hibayWill on 2018/3/27.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PatrolHistoryCell.h"
#import "Patroltems.h"
#import "FrameBaseRequest.h"
#import "UIColor+Extension.h"


@interface PatrolHistoryCell ()
@property (weak, nonatomic) IBOutlet UILabel *stationName;
@property (weak, nonatomic) IBOutlet UILabel *PatrolName;
@property (weak, nonatomic) IBOutlet UILabel *dateName;


@end



@implementation PatrolHistoryCell


- (void)setPatroltem:(Patroltems *)Patroltem{
    _stationName.text = Patroltem.stationName ;
    _stationName.font = FontSize(18);
    _PatrolName.text = Patroltem.typeName ;
    _PatrolName.font = FontSize(15);
    _dateName.text = [FrameBaseRequest getDateByTimesp: Patroltem.patrolTime dateType:@"YYYY-MM-dd"]   ;//Patroltem.createTime
    _dateName.font = FontSize(14);
    
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:@"F5FBFF"];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

@end
