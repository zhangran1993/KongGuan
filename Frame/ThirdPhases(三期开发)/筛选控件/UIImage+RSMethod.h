//
//  UIImage+RSMethod.h
//  ylh-app-primary-ios
//
//  Created by 王青森 on 2019/4/3.
//  Copyright © 2019 巨商汇. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (RSMethod)

+ (UIImage *)imageByScalingAndCroppingForSize:(CGSize)targetSize image:(UIImage *)image;
+ (UIImage *)stretchImage:(UIImage *)image left:(NSInteger)left top:(NSInteger)top;
+ (UIImage *)drawLineByImageView:(UIImageView *)imageView;
+ (UIImage *)imageColorfulToWhite:(UIImage *)image;
+ (UIImage *)convertViewToImage:(UIView *)view;
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
+ (UIImage *)fixOrientation:(UIImage *)aImage;
+ (UIImage *)compressImageSize:(UIImage *)image toByte:(NSUInteger)maxLength;
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 生成二维码

 @param url 二维码链接
 @return 二维码图片
 */
+ (UIImage *)createQRCodeWithUrl:(NSString *)url size:(CGFloat)size;

@end

NS_ASSUME_NONNULL_END
