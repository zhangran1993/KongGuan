////  SimpleDemoViewController.h//  SimpleDemo////  Created by apple on 11-4-2.//  Copyright __MyCompanyName__ 2011. All rights reserved.//#import <UIKit/UIKit.h>#import "DeviceInfo.h"#define RTP@interface SimpleDemoViewController : UIViewController {		UIView                  *m_playView;    UIView                  *m_multiView;		int                     m_lUserID;	int                     m_lRealPlayID;    int                     m_lPlaybackID;    bool                    m_bPreview;    }@property (nonatomic, retain) IBOutlet UIView	    *m_playView;@property (nonatomic, retain) id m_playThreadID;@property int m_lUserID;@property int m_lRealPlayID;@property int m_lPlaybackID;@property bool m_bPreview;@property bool m_bRecord;@property bool m_bPTZL;@property bool m_bVoiceTalk;@property bool m_bStopPlayback;@property bool m_bSwiftFlag;@property (strong,nonatomic) NSString* ip;/**< ip */@property (strong,nonatomic) NSString* name;/**< ip */@property (strong,nonatomic) NSString* password;/**< ip */@property (strong,nonatomic) NSString* port;/**< ip */@property int channelId;- (bool) loginNormalDevice;@end