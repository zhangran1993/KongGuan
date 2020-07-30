//
//  KG_XunShiResultView.m
//  Frame
//
//  Created by zhangran on 2020/4/27.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiResultView.h"

@interface KG_XunShiResultView ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>{

}

@property (nonatomic ,strong) UITextView *textView ;
    
@property (nonatomic ,strong) UITableView      *tableView;
@property (nonatomic ,strong) NSMutableArray   *dataArray;

@end
@implementation KG_XunShiResultView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createView];
    }
        
    return  self;
}

- (void)createView {
    [self addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.height.equalTo(@124);
    }];
    [self.tableView reloadData];
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.scrollEnabled = NO;
        UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 6)];
        _tableView.tableHeaderView = headView;
        headView.backgroundColor = [UIColor colorWithHexString:@"#F6F7F9"];
    }
    return _tableView;
}
- (NSMutableArray *)dataArray
{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    
    //    return self.dataArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.taskDescription.length == 0) {
//        cell.textLabel.text = @"一切情况正常";
        cell.textLabel.text = @"--";
    }else {
        cell.textLabel.text = safeString(self.taskDescription);
    }
    if([UserManager shareUserManager].isChangeTask ) {
        cell.textLabel.hidden = YES;
        self.textView = [[UITextView alloc]init];
        self.textView.backgroundColor = [UIColor colorWithHexString:@"#F8F9FA"];
        self.textView.layer.cornerRadius = 6;
        self.textView.returnKeyType = UIReturnKeyDone;
        self.textView.text = @"请输入巡视结果";
        if (safeString(self.taskDescription).length) {
            self.textView.text = safeString(self.taskDescription);
        }
        self.textView.textColor = [UIColor colorWithHexString:@"#24252A"];
        self.textView.layer.masksToBounds = YES;
        self.textView.font = [UIFont systemFontOfSize:14];
        self.textView.delegate = self;
        self.textView.textContainerInset = UIEdgeInsetsMake(15, 15, 5, 15);
        [cell addSubview:self.textView];
        [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(cell.mas_left).offset(16);
            make.right.equalTo(cell.mas_right).offset(-16);
            make.top.equalTo(cell.mas_top).offset(5);
            make.height.equalTo(@70);
        }];
    }else {
        [self.textView removeFromSuperview];
        self.textView = nil;
        cell.textLabel.hidden = NO;
    }
    
    cell.textLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    
    
    return cell;
}
//将要进入编辑模式[开始编辑]
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入巡视结果"] ||[textView.text isEqualToString:@"请输入巡视结果"]) {
        
        textView.text = @"";
    }
    return YES;
   
}
//当textView的内容发生改变的时候调用
- (void)textViewDidChange:(UITextView *)textView {
    
    if (self.textStringChangeBlock) {
        self.textStringChangeBlock(textView.text);
    }
    
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        //在这里做你响应return键的代码
        [textView resignFirstResponder];
        
        return NO; //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
    }
    return YES;
    
}
    

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return  80;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *shuImage = [[UIImageView alloc]init];
    [headView addSubview:shuImage];
    shuImage.image = [UIImage imageNamed:@"shu_image"];
    [shuImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@3);
        make.height.equalTo(@15);
        make.left.equalTo(headView.mas_left).offset(16);
        make.centerY.equalTo(headView.mas_centerY);
    }];
    
    UILabel *headTitle = [[UILabel alloc]initWithFrame:CGRectMake(32.5, 0, 200, 44)];
    [headView addSubview:headTitle];
    headTitle.text = @"巡视结果";
    headTitle.textAlignment = NSTextAlignmentLeft;
    headTitle.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    headTitle.textColor = [UIColor colorWithHexString:@"#24252A"];
    headTitle.numberOfLines = 1;
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(16, 43.5, SCREEN_WIDTH - 32, 0.5)];
    lineView.backgroundColor  = [UIColor colorWithHexString:@"#EFF0F7"];
    [headView addSubview:lineView];
    
    return headView;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
   
    return footView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 44.f;
}
- (void)setTaskDescription:(NSString *)taskDescription {
    _taskDescription = taskDescription;
    [self.tableView reloadData];
    
}

@end
