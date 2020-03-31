//
//  StationRankCell.m
//  Frame
//
//  Created by hibayWill on 2018/3/27.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "StationRankCell.h"
#import "StationItems.h"
#import "FrameBaseRequest.h"



@interface StationRankCell ()
@property (weak, nonatomic) IBOutlet UILabel *stationName;
@property (weak, nonatomic) IBOutlet UIImageView *stationrank;
@property (weak, nonatomic) IBOutlet UILabel *rankNum;


@end



@implementation StationRankCell


- (void)setStationItem:(StationItems *)StationItem{
    float point = [StationItem.points floatValue];
    int level = [self getNum:StationItem.points];
    _stationName.text = [NSString stringWithFormat:@"%@",StationItem.stationName] ;
    [_stationrank setImage:[UIImage imageNamed:[NSString stringWithFormat:@"station_rank%d",level]]];
    float rowNum = [StationItem.points floatValue];
    
    if(0 <= rowNum&& rowNum <= 69){
        [_stationrank setImage:[UIImage imageNamed:@"star_red"]];
    }else if(70 <= rowNum&& rowNum <80){
        [_stationrank setImage:[UIImage imageNamed:@"star_orange"]];
    }else if(80 <= rowNum&& rowNum <= 89){
        [_stationrank setImage:[UIImage imageNamed:@"star_yellowgreen"]];
    }else if(90 <= rowNum&& rowNum <= 100){
        [_stationrank setImage:[UIImage imageNamed:@"star_green"]];
    }
   
    _rankNum.text = [NSString stringWithFormat:@"%.1f分",point] ;
    
    _rankNum.textColor = [self getColor:StationItem.points];
    
}


-(int)getNum:(NSString *)row{
    float rowNum = [row floatValue];
    if(0 <= rowNum&& rowNum <= 69){
        return 1;
    }else if(70 <= rowNum&& rowNum <80){
        return 3;
    }else if(80 <= rowNum&& rowNum <= 89){
        return 4;
    }else if(90 <= rowNum&& rowNum <= 100){
        return 5;
    }
    return 0;
    /*
    if(rowNum >= 100){
        return 5;
    }else if(rowNum >= 90){
        return 4;
    }else if(rowNum >= 80){
        return 3;
    }else if(rowNum >= 70){
        return 2;
    }else{
        return 1;
    }
     */
}

-(UIColor *)getColor:(NSString *)row{
    float rowNum = [row floatValue];
    
    if(0 <= rowNum&& rowNum <= 69){
        return [UIColor colorWithHexString:@"#FB394C"];
    }else if(70 <= rowNum&& rowNum <80){
        return [UIColor colorWithHexString:@"#FFA800"];
    }else if(80 <= rowNum&& rowNum <= 89){
        return [UIColor colorWithHexString:@"#99E14D"];
    }else if(90 <= rowNum&& rowNum <= 100){
        return [UIColor colorWithHexString:@"#08CEB2"];
    }
    return listGrayColor;
    /*
    
    if(rowNum >= 100){
        return FrameColor(0, 250, 150);
    }else if(rowNum >= 90){
        return FrameColor(144,238,144);
    }else if(rowNum >= 80){
        return FrameColor(255,215,0);
    }else if(rowNum >= 70){
        return FrameColor(255, 140, 0);
    }else{
        return FrameColor(255, 0, 0);
    }
     */
}

@end
