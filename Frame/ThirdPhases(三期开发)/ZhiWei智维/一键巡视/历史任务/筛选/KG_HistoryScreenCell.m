//
//  KG_NewScreenCell.m
//  Frame
//
//  Created by zhangran on 2020/8/18.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_HistoryScreenCell.h"


@implementation KG_HistoryScreenCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initView];
    }
    return self;
}

- (void)initView {
    
    self.btn = [[UIButton alloc]init];
    [self addSubview:self.btn];
   
    [self.btn setTitle:@"" forState:UIControlStateNormal];
    [self.btn setTitleColor:[UIColor colorWithHexString:@"#7C7E86"] forState:UIControlStateNormal];
    [self.btn setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    self.btn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.btn.layer.cornerRadius =4 ;
    self.btn.layer.masksToBounds = YES;
    self.btn.layer.borderColor = [[UIColor colorWithHexString:@"#F2F2F2"] CGColor];
    self.btn.layer.borderWidth = 1;
    self.btn.titleLabel.numberOfLines = 2;
//    [self.btn addTarget:self action:@selector(confirmMethod:) forControlEvents:UIControlEventTouchUpInside];
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom);
    }];
    
}

//- (void)confirmMethod:(UIButton *)btn {
//    
//    
//}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    [self.btn setTitle:safeString(dataDic[@"name"]) forState:UIControlStateNormal];
    if ([safeString(dataDic[@"name"]) isEqualToString:@"设备"]) {
        [self.btn setTitle:@"空管设备" forState:UIControlStateNormal];
    }
    
    if ([safeString(dataDic[@"name"]) isEqualToString:safeString(self.equipTypeStr)]) {
        [self.btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.btn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    }else {
        [self.btn setTitleColor:[UIColor colorWithHexString:@"#7C7E86"] forState:UIControlStateNormal];
        [self.btn setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    }
    
}

- (void)setStr:(NSString *)str {
    _str = str;
    [self.btn setTitle:str forState:UIControlStateNormal];
    if ([str isEqualToString:safeString(self.alarmStatusStr)] ||
        [str isEqualToString:safeString(self.alarmLevelStr)]) {
        [self.btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.btn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    }else {
        [self.btn setTitleColor:[UIColor colorWithHexString:@"#7C7E86"] forState:UIControlStateNormal];
        [self.btn setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    }
}

- (void)setRoomDic:(NSDictionary *)roomDic {
    _roomDic = roomDic;
    [self.btn setTitle:safeString(roomDic[@"alias"]) forState:UIControlStateNormal];
    if ([safeString(roomDic[@"alias"]) isEqualToString:safeString(self.roomStr)]) {
        [self.btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.btn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    }else {
        [self.btn setTitleColor:[UIColor colorWithHexString:@"#7C7E86"] forState:UIControlStateNormal];
        [self.btn setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    }
}

- (void)setRoomStr:(NSString *)roomStr {
    _roomStr =roomStr;
}

- (void)setEquipTypeStr:(NSString *)equipTypeStr {
    _equipTypeStr = equipTypeStr;
}

- (void)setAlarmLevelStr:(NSString *)alarmLevelStr {
    _alarmLevelStr = alarmLevelStr;
}

- (void)setAlarmStatusStr:(NSString *)alarmStatusStr {
    _alarmStatusStr = alarmStatusStr;
}
- (void)setTaskTotalStr:(NSString *)taskTotalStr {
    _taskTotalStr = taskTotalStr;
    [self.btn setTitle:safeString(taskTotalStr) forState:UIControlStateNormal];
    if ([safeString(taskTotalStr) isEqualToString:safeString(self.taskStr)]) {
        [self.btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.btn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    }else {
        [self.btn setTitleColor:[UIColor colorWithHexString:@"#7C7E86"] forState:UIControlStateNormal];
        [self.btn setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    }
    
}
- (void)setTaskStr:(NSString *)taskStr {
    _taskStr = taskStr;
    
}

- (void)setTaskStatusStr:(NSString *)taskStatusStr {
    _taskStatusStr = taskStatusStr;
    
}

- (void)setTaskStatusTotalStr:(NSString *)taskStatusTotalStr {
    _taskStatusTotalStr = taskStatusTotalStr;
    [self.btn setTitle:safeString(taskStatusTotalStr) forState:UIControlStateNormal];
    if ([safeString(taskStatusTotalStr) isEqualToString:safeString(self.taskStatusStr)]) {
        [self.btn setTitleColor:[UIColor colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [self.btn setBackgroundColor:[UIColor colorWithHexString:@"#2F5ED1"]];
    }else {
        [self.btn setTitleColor:[UIColor colorWithHexString:@"#7C7E86"] forState:UIControlStateNormal];
        [self.btn setBackgroundColor:[UIColor colorWithHexString:@"#FFFFFF"]];
    }
}

@end
