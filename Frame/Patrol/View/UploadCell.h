//
//  UploadCell.h
//  Frame
//
//  Created by Apple on 2018/12/14.
//  Copyright © 2018 hibaysoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "uploadModel.h"
#import "PatrolSetController.h"
NS_ASSUME_NONNULL_BEGIN
@interface UploadCell : UITableViewCell <PatrolSetDelegate>
@property (nonatomic, strong) IBOutlet UIImageView * addImgView;
@property(assign,nonatomic)id <PatrolSetDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
