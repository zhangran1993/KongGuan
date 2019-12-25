//
//  StationRankCell.m
//  Frame
//
//  Created by hibayWill on 2018/3/27.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "WarnCell.h"
#import "StationItems.h"
#import "FrameBaseRequest.h"



@interface WarnCell ()
@property (weak, nonatomic) IBOutlet UILabel *stationName;
@property (weak, nonatomic) IBOutlet UIImageView *stationrank;
@end



@implementation WarnCell


- (void)setStationItem:(StationItems *)StationItem{
//    _stationName.font = FontSize(15);
//    _stationName.text = StationItem.content;
    if (StationItem.content.count > 0) {
        
        NSDictionary *dict = StationItem.content[0];
        NSString *contentStr = dict[StationItem.type];
        NSArray *stationList = dict[@"stationList"];
        contentStr = [NSString stringWithFormat:@"%@，请注意检查相关设备",contentStr];
        for (int i = 0; i < stationList.count; i++) {
            contentStr = [NSString stringWithFormat:@"%@ \n%@",contentStr,stationList[i]];
        }
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 5.0f; // 设置行间距
        paragraphStyle.alignment = NSTextAlignmentJustified; //设置两端对齐显示
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
//        _stationName.attributedText = attributedStr;
    }
    
    
//    [_stationName setFrameHeight:StationItem.LabelHeight];
    
    int level = 1;//[self getNum:StationItem.points];
    [_stationrank setImage:[UIImage imageNamed:[NSString stringWithFormat:@"station_rank%d",level]]];
}

-(float)getCellHeight:(StationItems *)StationItem{
    return StationItem.LabelHeight + 10;
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
