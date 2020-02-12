#import "UILabel+changeFont.h"
//
//@implementation UILabel (changeFont)

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setGlobalFont) name:@"font" object:nil];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setGlobalFont) name:@"font" object:nil];
}

- (void)setGlobalFont
{
//    if ([self isKindOfClass:NSClassFromString(@"UITextFieldLabel")]) {
//        return;
//    }
//    if ([self isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
//        return;
//    }
//    self.font = [UIFont systemFontOfSize:30];
//    self.backgroundColor = [UIColor redColor];
}

@end
