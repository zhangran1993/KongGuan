//
//  RecordTableViewCell.m
//  Frame
//
//  Created by centling on 2018/12/11.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "RecordTableViewCell.h"
#import "UIColor+Extension.h"
@implementation RecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lineView.backgroundColor = [UIColor colorWithHexString:@"F0F6FA"];
    self.nameLabel.textColor = [UIColor colorWithHexString:@"252525"];
    self.nameLabel.font = FontSize(16);
    self.contentLabel.textColor = [UIColor colorWithHexString:@"555756"];
    self.contentLabel.font = FontSize(16);
}

- (void)setCurriculumVitaeString:(NSString *)curriculumVitaeString {
    _curriculumVitaeString = curriculumVitaeString;
}

- (void)setCurriculumVitaeModel:(CurriculumVitaeModel *)curriculumVitaeModel {
    _curriculumVitaeModel = curriculumVitaeModel;
    AtcAttachmentRecordsModel *mdoel = curriculumVitaeModel.atcAttachmentRecords;
    NSLog(@"aaaaaaaaa%@:::%@",_curriculumVitaeString,curriculumVitaeModel.name);
    NSLog(@"aaaaaaaaa%@:::%@",_curriculumVitaeString,mdoel.content);
    self.nameLabel.text = [CommonExtension returnWithString:curriculumVitaeModel.name];
    self.contentLabel.attributedText = [self changeTextColor:mdoel.content alteredText:_curriculumVitaeString];
}


- (NSMutableAttributedString *)changeTextColor:(NSString *)allText alteredText:(NSString *)alteredText {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:allText];
    NSRange range = [[str string] rangeOfString:alteredText];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:range];
    return str;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor colorWithHexString:kCellHighlightColor];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (void)dealloc {
    [_nameLabel release];
    [_contentLabel release];
    [_lineView release];
    [super dealloc];
}
@end
