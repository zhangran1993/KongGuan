//
//  TechnicalManualTableViewCell.m
//  Frame
//
//  Created by centling on 2018/12/4.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "TechnicalManualTableViewCell.h"
#import "technicalManualListModel.h"
#import "UIColor+Extension.h"
@interface TechnicalManualTableViewCell()
@property (retain, nonatomic) IBOutlet UILabel *fileName;

@end
@implementation TechnicalManualTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor = [UIColor colorWithHexString:@"F0F6FA"];
    self.fileName.textColor = [UIColor colorWithHexString:@"555756"];
    self.fileName.font = FontSize(16);
    
    // Initialization code
}

- (void)setTechnicalManualListModel:(technicalManualListModel *)technicalManualListModel {
    _technicalManualListModel = technicalManualListModel;
     _fileName.text = technicalManualListModel.name;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [_fileName release];
    [super dealloc];
}
@end
