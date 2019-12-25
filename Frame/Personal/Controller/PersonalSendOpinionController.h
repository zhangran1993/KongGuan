//
//  PersonalSendOpinionController.h
//  Frame
//
//  Created by hibayWill on 2018/3/17.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalSendOpinionController : UIViewController<UIImagePickerControllerDelegate,UITextFieldDelegate, UINavigationControllerDelegate>{
}
@property int fid;
@property int submitNum;
@property (strong,nonatomic)NSString* thisdesc;
@property(nonatomic,copy)NSMutableArray *imgArray;
@property (nonatomic,copy) NSArray* imageurls;
//@property NSString* verif;/**< 验证码 */



@end
