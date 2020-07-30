//
//  KG_EquipCardCell.m
//  Frame
//
//  Created by zhangran on 2020/6/16.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_EquipCardCell.h"
#import "KG_EquipCardView.h"
@interface KG_EquipCardCell ()<UIScrollViewDelegate>{
    
    
}
@property (nonatomic, strong) NSMutableArray *dataArray;

@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation KG_EquipCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createSubviewsView];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)createSubviewsView {
    [self initWithController];
}

- (void)initWithController
{
    self.scrollView = [[UIScrollView alloc] init];
    NSLog(@"SCREEN_HEIGHT %f",SCREEN_HEIGHT);
    NSLog(@"HEIGHT_SCREEN %f",HEIGHT_SCREEN);
    self.scrollView.frame = CGRectMake(0, 6, SCREEN_WIDTH, SCREEN_HEIGHT -NAVIGATIONBAR_HEIGHT - 56-6);
    self.scrollView.delegate = self;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = YES;
   
    [self addSubview:self.scrollView];
   
  
    
}

- (void)setDataModel:(KG_XunShiReportDetailModel *)dataModel {
    _dataModel = dataModel;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for(taskDetail *model in self.dataModel.task){
        for(NSDictionary *dic in model.childrens){
//            if (isSafeDictionary(dic) && [[dic allKeys] containsObject:@"childrens"]) {
                for (NSDictionary *dataDic in dic[@"childrens"]) {
                    if([safeString(dataDic[@"levelCode"]) isEqualToString:@"2"] &&
                       [safeString(dataDic[@"cardDisplay"]) boolValue]){
                        [arr addObject:dataDic];
                    }
                }
//            }
            
        }
    }
    if (arr.count>0) {
        [self.dataArray removeAllObjects];
        if (self.curSelDic.count) {
            
            NSArray *idArr = self.curSelDetialDic[@"patrolInfoIdList"];
            for (NSString *ss in idArr) {
                for (NSDictionary *dic in arr) {
                    if ([safeString(dic[@"infoId"]) isEqualToString:ss]
                        ) {
                        [self.dataArray addObjectsFromArray: dic[@"childrens"]];
                    }
                }
            }
           
        }else {
            if (self.listArray.count) {
                NSArray *detailListarr = [self.listArray firstObject][@"equipmentList"];
                if (detailListarr.count) {
                    NSDictionary *detailDic = [detailListarr firstObject];
                    if (detailDic.count) {
                        NSArray *idArr = detailDic[@"patrolInfoIdList"];
                        for (NSString *ss in idArr) {
                            for (NSDictionary *dic in arr) {
                                
                                
                                if ([safeString(dic[@"infoId"]) isEqualToString:safeString(ss)]) {
                                    [self.dataArray addObjectsFromArray: dic[@"childrens"]];
                                }
                            }
                        }
                    }
                    
                    
                    
                }
            }
            
            
        }
//             self.dataArray = [arr firstObject][@"childrens"];
       
       
    }
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.dataArray.count, 0);
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self createSliderView];
    for(int i = 0; i < self.dataArray.count; i++) {
        KG_EquipCardView *viewcon = [[KG_EquipCardView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, self.scrollView.frameHeight)];
        NSDictionary *dic = self.dataArray[i];
        if (isSafeDictionary(dic)) {
            viewcon.cardTotalNum = (int)self.dataArray.count;
            viewcon.cardCurrNum = 1;
            viewcon.dataDic = dic;
            viewcon.taskStatus = self.dataModel.taskStatus;
            NSLog(@"_scrollView.frameHeight %f",self.scrollView.frameHeight);
            [self.scrollView addSubview:viewcon];
        }
        viewcon.moreBlockMethod = ^(NSDictionary * _Nonnull dataDic) {
            if (self.moreBlockMethod) {
                self.moreBlockMethod(dataDic);
            }
        };

    }
}
- (void)selectButton:(NSInteger)index
{
    
 
}

//监听滚动事件判断当前拖动到哪一个了
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / (SCREEN_WIDTH- 32);
    [self selectButton:index];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"cardScrollIndex" object:[NSString stringWithFormat:@"%ld",(long)index+1]];
    
}
- (void)createSliderView {
    
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

@end
