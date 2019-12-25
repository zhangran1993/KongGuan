//
//  UIImageView+GIF.h
//  WSLPictureBrowser
//
//  Created by hibayWill on 2018/6/14.
//  Copyright © 2018年 hibayWill. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface UIImageView (GIF)


- (void)showGifImageWithData:(NSData *)data;

- (void)showGifImageWithURL:(NSURL *)url;

@end
