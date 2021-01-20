//
//  Preview.h
//  SimpleDemo
//
//  Created by Netsdk on 15/4/22.
//
//

#ifndef SimpleDemo_Preview_h
#define SimpleDemo_Preview_h

#if TARGET_IPHONE_SIMULATOR

#else
#import "SimpleDemoViewController.h"
#endif

#define MAX_VIEW_NUM    4

int startPreview(int iUserID, int iStartChan, UIView *pView, int iIndex);
void stopPreview(int iIndex);


#endif
