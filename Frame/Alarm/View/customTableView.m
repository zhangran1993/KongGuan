//
//  customTableView.m
//  Frame
//
//  Created by centling on 2018/12/7.
//  Copyright © 2018年 hibaysoft. All rights reserved.
//

#import "customTableView.h"
#import "UIColor+Extension.h"
#import "UIView+LX_Frame.h"
#import "CustomTableViewCell.h"
static NSString *CustomTableViewCellID = @"CustomTableViewCellID";
@interface customTableView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
@end

@implementation customTableView

-(instancetype)init{
    self=[super init];
    if (self) {
        self.frame=CGRectMake(0,0,WIDTH_SCREEN,HEIGHT_SCREEN);
        self.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.55f];
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self hide];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _customManufactureArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CustomTableViewCellID];
    cell.nameLabel.text = _customManufactureArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self hide];
    if ([self.delegate respondsToSelector:@selector(customTableViewClickCell:)]) {
        [self.delegate customTableViewClickCell:_customManufactureArray[indexPath.row]];
    }
}



- (void)InitializationListView:(NSArray *)customManufactureArray {
    _customManufactureArray = customManufactureArray;
    CGFloat height = (HEIGHT_SCREEN/12) - 15;
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(50, self.center.y-(height/2), WIDTH_SCREEN - 100, height)];
    backView.backgroundColor = [UIColor whiteColor];
    backView.layer.cornerRadius = 10;
    backView.layer.masksToBounds = YES;
    [self addSubview:backView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, backView.lx_width, backView.lx_height) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = height;
    self.tableView.separatorStyle =NO;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CustomTableViewCell class]) bundle:nil] forCellReuseIdentifier:CustomTableViewCellID];
    [backView addSubview:self.tableView];
}



//弹框显示
-(void)show{
    [UIView animateWithDuration:0.3 animations:^{
        UIWindow * window=[UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
    } completion:^(BOOL finished) {
    }];
}

//弹框隐藏
-(void)hide {
    [UIView animateWithDuration:0.3 animations:^{
        [self removeFromSuperview];
    } completion:^(BOOL finished) {
    }];
}

@end
