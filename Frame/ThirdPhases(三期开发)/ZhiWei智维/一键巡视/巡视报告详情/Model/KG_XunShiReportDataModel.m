//
//  KG_XunShiReportDataModel.m
//  Frame
//
//  Created by zhangran on 2020/6/11.
//  Copyright © 2020 hibaysoft. All rights reserved.
//

#import "KG_XunShiReportDataModel.h"

@implementation firstData
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"childrens" : [secondData class]};
}
@end
@implementation secondData
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"childrens" : [thirdData class]};
}
@end
@implementation thirdData
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"childrens" : [fourthData class]};
}
@end
@implementation fourthData
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"childrens" : [fifthData class]};
}
@end
@implementation fifthData

@end

@implementation task
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"childrens" : [firstData class]};
}


@end
@implementation KG_XunShiReportDataModel
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"task" : [task class]};
}
@end
