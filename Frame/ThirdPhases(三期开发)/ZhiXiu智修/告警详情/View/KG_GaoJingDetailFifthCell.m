//
//  KG_GaoJingDetailFifthCell.m
//  Frame
//
//  Created by zhangran on 2020/5/20.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_GaoJingDetailFifthCell.h"
@interface KG_GaoJingDetailFifthCell (){
    
}
@property (nonatomic,strong)UILabel *detailLabel;
@end

@implementation KG_GaoJingDetailFifthCell

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
    UILabel *titleLabel = [[UILabel alloc]init];
    [self addSubview:titleLabel];
    titleLabel.text = @"处理描述";
    titleLabel.textColor = [UIColor colorWithHexString:@"#24252A"];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    titleLabel.font = [UIFont my_font:16];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(self.mas_top).offset(13);
        make.width.equalTo(@120);
        make.height.equalTo(@22);
    }];
    
    UIButton *fixBtn = [[UIButton alloc]init];
    [self addSubview:fixBtn];
    [fixBtn setTitle:@"修改" forState:UIControlStateNormal];
    [fixBtn setBackgroundColor:[UIColor clearColor]];
    fixBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [fixBtn setTitleColor:[UIColor colorWithHexString:@"#1860B0"] forState:UIControlStateNormal];
    [fixBtn setImage:[UIImage imageNamed:@"watchvideo_right"] forState:UIControlStateNormal];
    [fixBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 66, 0, 0)];
    [fixBtn addTarget:self action:@selector(fixMethod:) forControlEvents:UIControlEventTouchUpInside];
    [fixBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-16);
        make.width.equalTo(@80);
        make.height.equalTo(@20);
        make.top.equalTo(self.mas_top).offset(14);
    }];
    
    self.detailLabel = [[UILabel alloc]init];
    [self addSubview:self.detailLabel];
    self.detailLabel.text = @"处理描述";
    self.detailLabel.textColor = [UIColor colorWithHexString:@"#7C7E86"];
    self.detailLabel.textAlignment = NSTextAlignmentLeft;
    self.detailLabel.font = [UIFont systemFontOfSize:14];
    self.detailLabel.font = [UIFont my_font:14];
    self.detailLabel.numberOfLines = 2;
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(16);
        make.top.equalTo(titleLabel.mas_bottom).offset(13);
        make.right.equalTo(self.mas_right).offset(-15);
        make.height.equalTo(@42);
    }];
    
}

- (void)fixMethod:(UIButton *)button {
    
    if (self.fixMethod) {
        self.fixMethod();
    }
}

- (void)setModel:(KG_GaoJingDetailModel *)model {
    _model = model;
    NSDictionary *dic = model.info;
    self.detailLabel.text = safeString(dic[@"recordDescription"]);
}

- (void)setRecordDescription:(NSString *)recordDescription {
    _recordDescription = recordDescription;
    self.detailLabel.text = safeString(recordDescription);
}
@end
