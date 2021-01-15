//
//  Preview.h
//  SimpleDemo
//
//  Created by Netsdk on 15/4/22.
//
//海康威视 SDK禁用了iOS 模拟器调试，需要修改配置打包文件 现在是

#ifndef SimpleDemo_Preview_h
#define SimpleDemo_Preview_h
#import "SimpleDemoViewController.h"

#define MAX_VIEW_NUM    4

int startPreview(int iUserID, int iStartChan, UIView *pView, int iIndex);
void stopPreview(int iIndex);


#endif
