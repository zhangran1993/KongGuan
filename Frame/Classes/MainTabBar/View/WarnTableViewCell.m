//
//  WarnTableViewCell.m
//  Frame
//
//  Created by An An on 2019/11/1.
//  Copyright © 2019 hibaysoft. All rights reserved.
//

#import "WarnTableViewCell.h"
#import "StationItems.h"
#import "FrameBaseRequest.h"


@interface WarnTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *stationName;
@property (weak, nonatomic) IBOutlet UIImageView *stationrank;
@end
@implementation WarnTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setStationItem:(StationItems *)StationItem{
    if (StationItem.content.count > 0) {
        
        NSDictionary *dict = StationItem.content[0];
        NSString *contentStr;
        if ([StationItem.type isEqualToString:@"weather"]) {
            contentStr = @"雷电";
        } else {
            contentStr = @"设备预警";
        }
        NSArray *stationList = dict[@"stationList"];
        contentStr = [NSString stringWithFormat:@"%@，请注意检查相关设备:",contentStr];
        for (int i = 0; i < stationList.count; i++) {
            contentStr = [NSString stringWithFormat:@"%@ \n%@",contentStr,stationList[i]];
        }
        
        NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.lineSpacing = 4.0f; // 设置行间距
        paragraphStyle.alignment = NSTextAlignmentJustified; //设置两端对齐显示
        [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedStr.length)];
        _stationName.attributedText = attributedStr;
    }
    int level = 1;
    [_stationrank setImage:[UIImage imageNamed:[NSString stringWithFormat:@"station_rank%d",level]]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
