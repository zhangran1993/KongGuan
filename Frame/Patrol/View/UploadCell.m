//
//  UploadCell.m
//  Frame
//
//  Created by Apple on 2018/12/14.
//  Copyright © 2018 hibaysoft. All rights reserved.
//

#import "UploadCell.h"

@implementation UploadCell{
    uploadModel * upm;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


//构造方法
-(UITableViewCell *)uploadCellWithTableView:(UITableView *)tableView
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UploadCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UploadCell"];
    }
    //对Cell要做的设置
    
    UIImageView *deleteImg = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Patrol_img_delete"]];
    deleteImg.frame = CGRectMake(FrameWidth(100), FrameWidth(10), FrameWidth(30), FrameWidth(30));
    [deleteImg addGestureRecognizer:[[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(deleteCell:) ]];
    [deleteImg setUserInteractionEnabled:YES];
    [cell addSubview:deleteImg];
    
    cell.transform = CGAffineTransformMakeRotation(M_PI/2);
    return cell;
}
-(void)deleteCell:(UITapGestureRecognizer *)sender{
    /*
     UITapGestureRecognizer *tapRecognizer = (UITapGestureRecognizer *)sender;
    // 获取'edit按钮'所在的cell
    UITableViewCell *cell = (UITableViewCell *)[[tapRecognizer.view superview] superview];
    // 获取cell的indexPath
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    // 打印 --- test
    NSLog(@"点击的是第%d行",indexPath.row + 1);
    if([self.delegate respondsToSelector:@selector(deleteClick:)]) {
        [self.delegate deleteClick:indexPath.row];
    }
     */
}


-(void)setViewStateReaded:(int)aid{
    
}
//setter方法
-(void)setUploadModel:(uploadModel *)tg
{
    upm = tg;
    //图片
    _addImgView.image = upm.image;
   
}
- (void)dealloc {
    [_addImgView release];
    [super dealloc];
}
@end
