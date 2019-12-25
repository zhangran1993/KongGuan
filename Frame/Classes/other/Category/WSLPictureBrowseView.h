//
//  WSLPictureBrowseView.h
//  WSLPictureBrowser
//
//  Created by hibayWill on 2018/6/28.
//  Copyright © 2018年 hibayWill. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WSLPhotoZoom.h"

@interface WSLPictureBrowseView : UIView

//图片URL
@property (nonatomic, strong)  NSMutableArray * urlArray;

//本地图片路径
@property (nonatomic, strong) NSMutableArray * pathArray;

//本地图片名字 如 1.gif 或者 1.jpeg ...
@property (nonatomic, strong) NSMutableArray * nameArray;
//图片对象 ...
@property (nonatomic, strong) NSMutableArray * imgArray;

//图片对象
@property (nonatomic, weak) id pictureObject;

@property (nonatomic, weak) id viewController;

@property (nonatomic , strong) WSLPhotoZoom * currentPhotoZoom;

@property (nonatomic , assign) NSInteger index;

@property (nonatomic, copy) NSData * currentImageData;

@end
