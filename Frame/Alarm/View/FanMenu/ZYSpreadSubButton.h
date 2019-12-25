//
//  SpreadSubButton.h
//  SpreadButton
//
//  Created by centling on 18/12/4.
//  Copyright © hibaysoft. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ButtonClickBlock)(int index, UIButton *sender);

@interface ZYSpreadSubButton : UIButton

@property (copy, nonatomic) ButtonClickBlock buttonClickBlock;

- (instancetype)initWithBackgroundImage:(UIImage *)backgroundImage highlightImage:(UIImage *)highlightImage clickedBlock:(ButtonClickBlock)buttonClickBlock;


@end
