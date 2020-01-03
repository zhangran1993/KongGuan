//
//  CluseterAnnotationView.h
//  Frame
//
//  Created by zhangran on 2019/12/30.
//  Copyright © 2019 hibaysoft. All rights reserved.
//
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKAnnotationView.h>

NS_ASSUME_NONNULL_BEGIN

@interface CluseterAnnotationView : BMKAnnotationView
/**
 * 创建方法
 *
 *  @param mapView 地图
 *
 *  @return 大头针
*/
+ (instancetype)annotationViewWithMap:(BMKMapView *)mapView;
@end

NS_ASSUME_NONNULL_END
