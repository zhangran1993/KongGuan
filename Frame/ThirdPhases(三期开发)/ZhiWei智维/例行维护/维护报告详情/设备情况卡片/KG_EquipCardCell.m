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

@property (nonatomic, assign) BOOL     isFirstCard;

@property (nonatomic, strong) NSMutableArray *cardHeightArray;
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
        self.contentView.backgroundColor = self.backgroundColor;
        [self createSubviewsView];
        self.cardHeightArray = [NSMutableArray arrayWithCapacity:0];
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
    self.scrollView.bounces =NO;
    [self addSubview:self.scrollView];
   
}

- (void)setDataModel:(KG_XunShiReportDetailModel *)dataModel {
    _dataModel = dataModel;
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for(taskDetail *model in self.dataModel.task){
        for(NSDictionary *dic in model.childrens){
                for (NSDictionary *dataDic in dic[@"childrens"]) {
                    if([safeString(dataDic[@"levelCode"]) isEqualToString:@"2"] &&
                       [safeString(dataDic[@"cardDisplay"]) boolValue]){
                        [arr addObject:dataDic];
                    }
                }
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
    }
    
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*self.dataArray.count, 0);
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self createSliderView];
    
    
    [self.cardHeightArray removeAllObjects];
    for(int i = 0; i < self.dataArray.count; i++) {
        NSDictionary *dic = self.dataArray[i];
        [self.cardHeightArray addObject:[NSNumber numberWithInt:[self calcuelateHeight:dic]]];
        int h = [self calcuelateHeight:dic];
        if (!self.isFirstCard) {
            self.isFirstCard = YES;
             [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCardHeight" object:[NSNumber numberWithInt:h +80]];
        }
        KG_EquipCardView *viewcon = [[KG_EquipCardView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, h)];
       
       
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

//计算高度数组
- (int)calcuelateHeight:(NSDictionary *)dic {
    
    int height = 0;
    
    NSString *str = safeString(dic[@"operationalGuidelines"]);
    CGRect fontRect = [str boundingRectWithSize:CGSizeMake(SCREEN_WIDTH - 64, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:14] forKey:NSFontAttributeName] context:nil];
    NSLog(@"%f",fontRect.size.height);
    height += (fontRect.size.height +24 +62);
    
    NSString *str1 =  safeString(dic[@"remark"]);
    if (str1.length == 0) {
        height += 0;
    }else {
        height += 40 +42;
    }
    
    //先判断是四级还是五级 模板，取值
    int levelMax = [dic[@"levelMax"] intValue];
    if (levelMax == 4) {
        NSArray *arr = dic[@"childrens"];
        
        height += arr.count *45;
        
    }else if (levelMax == 5) {
      
        NSArray *modelArr = dic[@"childrens"];
        if (modelArr.count) {
            for (NSDictionary *fourDic in modelArr) {
                if (isSafeDictionary(fourDic[@"atcSpecialTag"])) {
                    NSDictionary *specDic = fourDic[@"atcSpecialTag"];
                    if (safeString(specDic[@"specialTagCode"]).length >0) {
                        height += (45 +57);
                        
                    }else {
                        height +=45;
                    }
                }else {
                    height +=45;
                }
            }
        }else {
            height +=45;
        }
    }

    return height +45 + 45 + 20;
}

- (void)selectButton:(NSInteger)index
{
    CGRect frame = self.scrollView.frame;
    frame.size.height = [self.cardHeightArray[index] intValue];
    self.scrollView.frame = frame;
    //让卡片高度自适应
    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshCardHeight" object:[NSNumber numberWithInt:[self.cardHeightArray[index] intValue] +80]];
//    self.scrollView.frame = CGRectMake(0, 6, SCREEN_WIDTH, SCREEN_HEIGHT -NAVIGATIONBAR_HEIGHT - 56-6);
 
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
