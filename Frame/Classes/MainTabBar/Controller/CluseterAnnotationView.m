//
//  CluseterAnnotationView.m
//  Frame
//
//  Created by zhangran on 2019/12/30.
//  Copyright © 2019 hibaysoft. All rights reserved.
//

#import "CluseterAnnotationView.h"
#import "CluserAnnotation.h"
@implementation CluseterAnnotationView
- (instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
  if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
      
  }
  return self;
}
+ (instancetype)annotationViewWithMap:(BMKMapView *)mapView{
  static NSString *identifier = @"anno";
  // 从缓存池中取
    CluseterAnnotationView *annoView = (CluseterAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
  // 如果缓存池中没有, 创建一个新的
  if (annoView == nil) {
    annoView = [[CluseterAnnotationView alloc] initWithAnnotation:nil reuseIdentifier:identifier];
  }
  return annoView;
}
- (void)setAnnotation:(CluserAnnotation *)annotation{
  [super setAnnotation:annotation];
  //设置图标
  self.image = [UIImage imageNamed:@"icon_green"];
}
#pragma mark -BMKMapViewDelegate
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    // 对用户当前的位置的大头针特殊处理
    if ([annotation isKindOfClass:[CluserAnnotation class]] == NO) {
    return nil;
 }
  // 创建大头针
  CluseterAnnotationView *annoView = [CluseterAnnotationView annotationViewWithMap:mapView];
  // 设置模型
  annoView.annotation = annotation;

  // 返回大头针
  return annoView;
}



@end
