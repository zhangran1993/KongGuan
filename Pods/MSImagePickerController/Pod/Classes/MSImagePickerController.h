//
//  MSImagePickerController.h
//  Example
//
//  Created by morenotepad on 17/12/14.
//  Copyright (c) 2015年 zxm. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSImagePickerControllerDelegate;

@interface MSImagePickerController : UIImagePickerController

@property (nonatomic, readonly, copy)    NSArray * _Nullable images;
@property (nonatomic, readwrite, assign) NSInteger maxImageCount;
@property (nonatomic, readwrite, assign) NSString* _Nullable doneButtonTitle;
@property (nonatomic, nullable, weak)    id<MSImagePickerControllerDelegate> msDelegate;

@end

@protocol MSImagePickerControllerDelegate<NSObject>

@optional
- (void)imagePickerControllerDidFinish   :(MSImagePickerController *_Nullable)picker;
- (void)imagePickerControllerDidCancel   :(MSImagePickerController *_Nullable)picker;
- (void)imagePickerControllerOverMaxCount:(MSImagePickerController *_Nullable)picker;
- (BOOL)imagePickerController:(MSImagePickerController *_Nullable)picker shouldSelectImage:(UIImage *_Nullable)image;

@end
