//
//  TTK_Macro.h
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/21.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#define LOG(args...) \
NSLog([[NSString stringWithFormat:@"%s ", __func__]  stringByAppendingFormat:args], nil)

#define GET_WINSIZE [[UIScreen mainScreen] bounds].size