//
//  KG_SparePartsStatisticsFirstCell.m
//  Frame
//
//  Created by zhangran on 2020/11/11.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_SparePartsStatisticsFirstCell.h"
#import "HXCharts.h"
#import "KG_SparePartsStatisticsCollectionViewCell.h"

@interface KG_SparePartsStatisticsFirstCell ()<UICollectionViewDelegate,UICollectionViewDataSource> {
    
    
}

@property (nonatomic ,strong)     UIView       *centerView;

@property (nonatomic ,strong)     HXBarChart   *chartBar;

@property (nonatomic ,assign)     BOOL         isShow;

@property (nonatomic,strong)      UICollectionView *collectionView;

/** 品牌数组 */
@property(nonatomic , strong)     NSArray *dataArray;

@end

@implementation KG_SparePartsStatisticsFirstCell

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
    }
    return self;
}

- (void)createSubviewsView {
    self.centerView = [[UIView alloc]init];
    [self addSubview:self.centerView];
    self.centerView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [self.centerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(0);
        make.top.equalTo(self.mas_top).offset(0);
        make.bottom.equalTo(self.mas_bottom);
        make.right.equalTo(@(SCREEN_WIDTH));
    }];
    
    UIView *bgView = [[UIView alloc]init];
    [self.centerView addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.centerView.mas_left);
        make.top.equalTo(self.centerView.mas_top);
        make.height.equalTo(self.centerView.mas_height);
        make.right.equalTo(self.mas_right);
    }];
    
    UIView *shuView = [[UIView alloc]init];
    [bgView addSubview:shuView];
    shuView.backgroundColor = [UIColor colorWithHexString:@"#2F5ED1"];
    [shuView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(bgView.mas_left).offset(16);
        make.top.equalTo(bgView.mas_top).offset(21);
        make.width.equalTo(@4);
        make.height.equalTo(@15);
    }];
    shuView.layer.cornerRadius = 2.f;
    shuView.layer.masksToBounds = YES;
    
    
    UILabel *titleLabel = [[UILabel alloc]init];
    [bgView addSubview:titleLabel];
    titleLabel.text = [NSString stringWithFormat:@"%@",@"台站备件统计数量"];
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.font = [UIFont my_font:16];
    titleLabel.numberOfLines =1;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(shuView.mas_right).offset(5);
        make.width.equalTo(@220);
        make.height.equalTo(@30);
        make.centerY.equalTo(shuView.mas_centerY);
    }];
    
    
    
    UILabel *promptLabel = [[UILabel alloc]init];
    [bgView addSubview:promptLabel];
    promptLabel.text = [NSString stringWithFormat:@"%@",@"最近使用"];
    promptLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    promptLabel.font = [UIFont systemFontOfSize:12];
    promptLabel.font = [UIFont my_font:12];
    promptLabel.numberOfLines =1;
    promptLabel.textAlignment = NSTextAlignmentLeft;
    [promptLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(bgView.mas_right).offset(-16);
        make.width.equalTo(@58);
        make.height.equalTo(@17);
        make.centerY.equalTo(shuView.mas_centerY);
    }];
    
    UIImageView *promptImage = [[UIImageView alloc]init];
    [bgView addSubview:promptImage];
    promptImage.backgroundColor = [UIColor colorWithHexString:@"#F7A310"];
    [promptImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(promptLabel.mas_left).offset(-2);
        make.width.equalTo(@13);
        make.height.equalTo(@7);
        make.centerY.equalTo(shuView.mas_centerY);
    }];
    
    
    
    UILabel *ciyaoLabel = [[UILabel alloc]init];
    [bgView addSubview:ciyaoLabel];
    ciyaoLabel.text = [NSString stringWithFormat:@"%@",@"未使用"];
    ciyaoLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    ciyaoLabel.font = [UIFont systemFontOfSize:12];
    ciyaoLabel.font = [UIFont my_font:12];
    ciyaoLabel.numberOfLines =1;
    ciyaoLabel.textAlignment = NSTextAlignmentLeft;
    [ciyaoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(promptImage.mas_left).offset(-12);
        make.width.equalTo(@48);
        make.height.equalTo(@17);
        make.centerY.equalTo(shuView.mas_centerY);
    }];
    
    UIImageView *ciyaoImage = [[UIImageView alloc]init];
    [bgView addSubview:ciyaoImage];
    ciyaoImage.backgroundColor = [UIColor colorWithHexString:@"#03C3B6"];
    [ciyaoImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(ciyaoLabel.mas_left).offset(-2);
        make.width.equalTo(@13);
        make.height.equalTo(@7);
        make.centerY.equalTo(shuView.mas_centerY);
    }];
    
    CGFloat width = SCREEN_WIDTH -32;
    CGFloat height = 300;
    
    CGFloat barChartWidth = self.frame.size.width * 0.8;
    CGFloat barChartHeight = self.frame.size.height * 0.4;
    
    CGFloat barChartX = (width - barChartWidth) / 2;
    CGFloat barChartY = (height - barChartHeight) / 2;
    
    
    self.chartBar = [[HXBarChart alloc] initWithFrame:CGRectMake(16, 50, SCREEN_WIDTH -32, 250) withMarkLabelCount:6 withOrientationType:OrientationVertical];
    [self addSubview:self.chartBar ];
    self.chartBar .xlineColor = [UIColor clearColor];
    
    self.chartBar .locations = @[@0.15,@0.85];
    self.chartBar .markTextColor = [UIColor colorWithHexString:@"#9294A0"];
    self.chartBar .markTextFont = [UIFont systemFontOfSize:14];
    self.chartBar .xlineColor = [UIColor clearColor];
    ///不需要滑动可不设置
    self.chartBar .contentValue = 12 * 45;
    self.chartBar .barWidth = 25;
    self.chartBar .margin = 20;
    
    [self initCollevtionView];
    
}

#pragma mark 设置16进制颜色
- (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha{
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}

- (void)setCurrSelDic:(NSDictionary *)currSelDic {
    _currSelDic = currSelDic;
    
    
}


- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    
    
    NSArray *listArray= dataDic[@"yArr"];
  
    if (listArray.count >0 &&!self.isShow) {
        self.isShow = YES;
        NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
        
        for (NSDictionary *dataDic in listArray) {
            NSArray *arr = dataDic[@"detail"];
            for (NSDictionary *dic in arr) {
                 [titleArray addObject:safeString(dic[@"categoryName"])];
            }
           
        }
        
        self.chartBar.titleArray = titleArray;
        
        NSMutableArray *numArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dataDic in listArray) {
            NSArray *arr = dataDic[@"detail"];
            for (NSDictionary *dic in arr) {
                 [numArray addObject:safeString(dic[@"num"])];
            }
            
        }
        self.chartBar.valueArray = numArray;
        
        NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dataDic in listArray) {
            NSArray *arr = dataDic[@"detail"];
            for (NSDictionary *dic in arr) {
                BOOL inUse = dic[@"inUse"];
                if (inUse) {
                    NSArray *color = @[[self colorWithHexString:@"#F7A310" alpha:1],[self colorWithHexString:@"#F7A310" alpha:1]];
                    [colorArray addObject:color];
                }else {
                    NSArray *color = @[[self colorWithHexString:@"#03C3B6" alpha:1],[self colorWithHexString:@"#03C3B6" alpha:1]];
                    [colorArray addObject:color];
                    
                }
            }
           
        }
        self.chartBar.colorArray = colorArray ;
        [self.chartBar drawChart];
    }
}

- (void)setListArray:(NSArray *)listArray {
    _listArray = listArray;
    self.dataArray = listArray;
    [self.collectionView reloadData];

}


//初始化collectionview
- (void)initCollevtionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 28;
    flowLayout.minimumInteritemSpacing = 20;
    flowLayout.itemSize = CGSizeMake(55, 28);//每一个cell的大小
//    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);//四周的边距
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 40, 0, 40);
    self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:flowLayout];
    [self.centerView addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.centerView.mas_bottom).offset(-20);
        make.left.equalTo(self.centerView.mas_left);
       
        make.right.equalTo(self.centerView.mas_right);
        make.height.equalTo(@40);
    }];
    self.collectionView.layer.cornerRadius = 10.f;
    self.collectionView.layer.masksToBounds = YES;
    [self.collectionView registerClass:[KG_SparePartsStatisticsCollectionViewCell class] forCellWithReuseIdentifier:@"KG_SparePartsStatisticsCollectionViewCell"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.scrollEnabled = NO;
    self.collectionView.backgroundColor = [UIColor colorWithHexString:@"#FFFFFF"];
   
    
}
#pragma mark ---- collectionView 数据源方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView == self.collectionView) {
        KG_SparePartsStatisticsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"KG_SparePartsStatisticsCollectionViewCell" forIndexPath:indexPath];
        
        NSDictionary *dataDic = self.dataArray[indexPath.row];
        cell.currSelDic = self.currSelDic;
        cell.dataDic = dataDic;
       
        return cell;
    }
    return nil;
    
    
}

#pragma mark  定义每个UICollectionViewCell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return  CGSizeMake(55,28);
    
}

#pragma mark - collectionView代理方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dataDic = self.dataArray[indexPath.row];
    self.currSelDic = dataDic;
    [self.collectionView reloadData];
}

@end
