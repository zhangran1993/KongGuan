//
//  RecordTableViewCell.h
//  Frame
//
//  Created by centling on 2018/12/11.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurriculumVitaeModel.h"
#import "AtcAttachmentRecordsModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface RecordTableViewCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *contentLabel;
@property (retain, nonatomic) IBOutlet UIView *lineView;

@property (nonatomic, strong) NSString *curriculumVitaeString;
@property (nonatomic, strong)CurriculumVitaeModel *curriculumVitaeModel;
@end

NS_ASSUME_NONNULL_END
