//
//  FilePreviewViewController.h
//  Frame
//
//  Created by centling on 2018/12/5.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "BasicViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FilePreviewViewController : BasicViewController
@property (nonatomic, retain)NSString *fileURLString;
@property (nonatomic, strong)NSString *fileName;
@property (nonatomic, strong)NSString *url;
@end

NS_ASSUME_NONNULL_END