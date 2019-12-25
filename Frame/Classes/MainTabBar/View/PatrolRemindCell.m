//
//  StationRankCell.m
//  Frame
//
//  Created by hibayWill on 2018/3/27.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "PatrolRemindCell.h"
#import "StationItems.h"
#import "FrameBaseRequest.h"



@interface PatrolRemindCell ()
@property (weak, nonatomic) IBOutlet UILabel *stationName;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@end



@implementation PatrolRemindCell
- (void)setStationItem:(StationItems *)StationItem{
    _stationName.font = FontSize(16);
    _stationName.text = StationItem.stationName;
    _dateLabel.font = FontSize(14);
    _dateLabel.text = [FrameBaseRequest getDateByTimesp:StationItem.time dateType:@"YYYY-MM-dd"];
    
    _typeLabel.font = FontSize(14);
    _typeLabel.text = StationItem.type;
    
}

-(float)getCellHeight:(StationItems *)StationItem{
    return StationItem.LabelHeight ;
}


-(int)getNum:(long)row{
    if(row >= 100){
        return 5;
    }else if(row >= 90){
        return 4;
    }else if(row >= 80){
        return 3;
    }else if(row >= 70){
        return 2;
    }else{
        return 1;
    }
}

@end
