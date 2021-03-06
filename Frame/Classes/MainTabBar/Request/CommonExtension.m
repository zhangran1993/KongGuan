//
//  CommonExtension
//  Frame
//
//  Created by Hibaysoft on 17/7/4.
//  Copyright (c) 2018年 Hibaysoft. All rights reserved.
//

#import "CommonExtension.h"
#import <MJExtension.h>
#import <SVProgressHUD.h>
#import <JSONKit.h>
#import "NSString+MD5.h"
#import <QuartzCore/QuartzCore.h> 
#import "UIColor+Extension.h"
@implementation CommonExtension


+ (BOOL)isEmptyWithString:(NSString *)string
{
    if ([CommonExtension isBlankString:string]) {
        return YES;
    }
    if (string.length == 0 || [string isEqualToString:@""] || string == nil || string == NULL || [string isEqual:[NSNull null]])
    {
        return YES;
    }
    return NO;
}

+ (NSString *)returnWithString:(NSString *)string
{
    if ([CommonExtension isBlankString:string]) {
        return @"";
    }
    if (string.length == 0 || [string isEqualToString:@""] || string == nil || string == NULL || [string isEqual:[NSNull null]])
    {
        return @"";
    }
    return string;
}

+(NSString *)convertToJsonData:(NSMutableArray *)dict

{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString = @"";
    
    if (!jsonData) {
        
        NSLog(@"error%@",error);
        
    }else{
        
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
    }
    
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    
    NSRange range = {0,jsonString.length};
    
    //去掉字符串中的空格
    
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    
    //去掉字符串中的换行符
    
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}
+ (void)logout{
    //清除信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:@"newsSet"];
    [userDefaults removeObjectForKey:@"station_code"];
    [userDefaults removeObjectForKey:@"customerId"];
    [userDefaults removeObjectForKey:@"email"];
    [userDefaults removeObjectForKey:@"mobile"];
    [userDefaults removeObjectForKey:@"tel"];
    [userDefaults removeObjectForKey:@"enabled"];
    [userDefaults removeObjectForKey:@"expert"];
    [userDefaults removeObjectForKey:@"hang"];
    [userDefaults removeObjectForKey:@"icon"];
    [userDefaults removeObjectForKey:@"id"];
    [userDefaults removeObjectForKey:@"name"];
    [userDefaults removeObjectForKey:@"orgId"];
    [userDefaults removeObjectForKey:@"orgName"];
    [userDefaults removeObjectForKey:@"role"];
    [userDefaults removeObjectForKey:@"userAccount"];
    [userDefaults removeObjectForKey:@"password"];
    
}
+ (void)showviewLoadView{
    
    [UIView animateWithDuration:13 animations:^{
        
        //showview.alpha=0;
        
    }completion:^(BOOL finished) {
        
       // [bgView removeFromSuperview];
        
    }];
    
    
}


/**
 根据title判断view

 @param ParentView view
 */
-(void)addTouchViewParent:(UIView *)ParentView {
    UIButton *patrolViewButton = [[UIButton alloc] initWithFrame:ParentView.bounds];
    [patrolViewButton setBackgroundImage:[CommonExtension createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [patrolViewButton addTarget:self action:@selector(routinePatrol) forControlEvents:UIControlEventTouchUpInside];
    [patrolViewButton setBackgroundImage:[CommonExtension createImageWithColor:[UIColor colorWithHexString:kCellHighlightColor]] forState:UIControlStateHighlighted];
    [ParentView addSubview:patrolViewButton];
}



/**
 根据tag判断view

 @param ParentView view
 */
- (void)addTouchViewParentTagClass:(UIView *)ParentView {
    UIButton *patrolViewButton = [[UIButton alloc] initWithFrame:ParentView.bounds];
    //[patrolViewButton setBackgroundImage:[CommonExtension createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [patrolViewButton addTarget:self action:@selector(routinePatrolTag) forControlEvents:UIControlEventTouchUpInside];
    [patrolViewButton setBackgroundImage:[CommonExtension createImageWithColor:[UIColor colorWithHexString:kCellHighlightColor]] forState:UIControlStateHighlighted];
    [ParentView addSubview:patrolViewButton];
}

- (void)routinePatrol {
    if ([self.delegate respondsToSelector:@selector(ParentViewTitle:)]) {
        [self.delegate ParentViewTitle:_parentViewTitle];
    }
}

- (void)routinePatrolTag {
    if ([self.delegate respondsToSelector:@selector(ParentViewTag:)]) {
        [self.delegate ParentViewTag:_parentViewTag];
    }
}



-(void)setParentViewTitle:(NSString *)parentViewTitle {
    _parentViewTitle = parentViewTitle;
}

-(void)setParentViewTag:(NSInteger)parentViewTag {
    _parentViewTag = parentViewTag;
}

+(void)addLevelBtn:(UIButton *)btn level:(NSString *)level{
    NSInteger thisLevel = [level integerValue];
    UIColor *thisColor = FrameColor(120, 203, 161);//正常
    switch (thisLevel) {
        case 0:
            thisColor = FrameColor(120, 203, 161);//
            break;
        case 1:
            thisColor = FrameColor(255, 106, 106);//
            break;
        case 2:
            thisColor = FrameColor(255, 140, 0);//
            break;
        case 3:
            thisColor = FrameColor(240, 210, 4);//
            break;
        case 4:
            thisColor = FrameColor(173, 255, 47);//
            break;
        default:
            break;
    }
    [btn setTitle:[NSString stringWithFormat:@"%@级",level ] forState:UIControlStateNormal];
    btn.titleLabel.textColor = [UIColor whiteColor];
    [btn setBackgroundColor:thisColor];
    
}

+ (void)addTViewParent:(UIView *)ParentView textView:(FSTextView *)textView text:(NSString*)text placeholder:(NSString *)placeholder maxLength:(int)maxLength{
    
    
    // FSTextView
    textView = [FSTextView textView];
    textView.font = FontSize(16);
    textView.placeholder = placeholder;
    textView.canPerformAction = NO;
    [ParentView addSubview:textView];
    textView.text = text;
    // 限制输入最大字符数.
    textView.maxLength = maxLength;
    // 添加输入改变Block回调.
    [textView addTextDidChangeHandler:^(FSTextView *textView) {
        NSLog(@"addTextDidChangeHandler");
    }];
    // 添加到达最大限制Block回调.
    [textView addTextLengthDidMaxHandler:^(FSTextView *textView) {
        NSLog(@"addTextLengthDidMaxHandler");
    }];
    // constraint
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [ParentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[textView]|" options:kNilOptions metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
    [ParentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[textView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(textView)]];
    
}


+ (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}


+(NSString *)getDateByTimesp:(double)date dateType:(NSString *)dateType{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:dateType];// HH:mm:ss@"YYYY-MM-dd"
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:date/1000];
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    //NSLog(@"confromTimespStr =  %@::%f",confromTimespStr,date);
    return confromTimespStr;
}
+(void)showMessage:(NSString*)message {
    UIWindow* window = [UIApplication sharedApplication].keyWindow;
    UIView *showview = [[UIView alloc] initWithFrame:CGRectMake(1,1,1,1)] ;
    showview.backgroundColor= [UIColor blackColor];
    showview.alpha=1.0f;
    
    showview.layer.cornerRadius=5.0f;
    
    showview.layer.masksToBounds=YES;
    
    [window addSubview:showview];
    
    UILabel*label = [[UILabel alloc]init];
    CGSize LabelSize =[message sizeWithAttributes:@{NSFontAttributeName: FontSize(17)}];
    //CGSize LabelSize = [message sizeWithFont:FontSize(17) constrainedToSize:CGSizeMake(290,9000)];
    
    label.frame=CGRectMake(10,10, LabelSize.width, LabelSize.height);
    
    label.text= message;
    
    label.textColor= [UIColor whiteColor];
    
    label.textAlignment=1;
    
    label.backgroundColor= [UIColor clearColor];
    
    label.font= FontBSize(15);
    
    [showview addSubview:label];
    
    showview.frame=CGRectMake(([UIScreen mainScreen].bounds.size.width- LabelSize.width-20)/2, [UIScreen mainScreen].bounds.size.height-100, LabelSize.width+20, LabelSize.height+20);
    
    [UIView animateWithDuration:3 animations:^{
        
        showview.alpha=0;
        
    }completion:^(BOOL finished) {
        
        [showview removeFromSuperview];
        
    }];
    
}

+ (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL containsEmoji = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0,
                                                   [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring,
                                         NSRange substringRange,
                                         NSRange enclosingRange,
                                         BOOL *stop)
     {
         const unichar hs = [substring characterAtIndex:0];
         // surrogate pair
         if (0xd800 <= hs &&
             hs <= 0xdbff)
         {
             if (substring.length > 1)
             {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc &&
                     uc <= 0x1f9c0)
                 {
                     containsEmoji = YES;
                 }
             }
         }
         else if (substring.length > 1)
         {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3 ||
                 ls == 0xfe0f ||
                 ls == 0xd83c)
             {
                 containsEmoji = YES;
             }
         }
         else
         {
             // non surrogate
             if (0x2100 <= hs &&
                 hs <= 0x27ff)
             {
                 containsEmoji = YES;
             }
             else if (0x2B05 <= hs &&
                      hs <= 0x2b07)
             {
                 containsEmoji = YES;
             }
             else if (0x2934 <= hs &&
                      hs <= 0x2935)
             {
                 containsEmoji = YES;
             }
             else if (0x3297 <= hs &&
                      hs <= 0x3299)
             {
                 containsEmoji = YES;
             }
             else if (hs == 0xa9 ||
                      hs == 0xae ||
                      hs == 0x303d ||
                      hs == 0x3030 ||
                      hs == 0x2b55 ||
                      hs == 0x2b1c ||
                      hs == 0x2b1b ||
                      hs == 0x2b50)
             {
                 containsEmoji = YES;
             }
         }
         
         if (containsEmoji)
         {
             *stop = YES;
         }
     }];
    
    return containsEmoji;
}


/**
 *  组合请求参数
 *
 *  @param dict 外部参数字典
 *
 *  @return 返回组合参数
 */
+ (NSMutableDictionary *)requestParams:(NSDictionary *)dict
{
    //
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    return params;
}

//创建颜色图片
+ (UIImage*)createImageWithColor: (UIColor*) color{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+(int)isFirstLauch{
    
    NSString *  version = [[NSUserDefaults standardUserDefaults] objectForKey:AppVersion];
    if(!version){
        version =@"0";
    }
    int newNum =  [version intValue];
    newNum ++;
    //版本升级或首次登录
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",newNum] forKey:AppVersion];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    return newNum;
}

//判断字符串是否为空
+ (BOOL)isBlankString:(NSString *)string{
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    return NO;
}

+ (float)heightForString:(NSString *)value fontSize:(UIFont*)fontSize andWidth:(float)width {
    if ([CommonExtension isBlankString:value]) {
        return 0;
    }
    NSDictionary *font = @{NSFontAttributeName:fontSize};
    CGSize size = [value boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:font context:nil].size;
    return size.height;
}

@end
