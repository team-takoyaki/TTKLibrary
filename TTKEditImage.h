//
//  TTK_Stamp.h
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/22.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTKEditImage : NSObject

/**
* @brief Viewから画像を取得する
* @param view 画像を取得したいView
* @param scale スケール
* @return 取得した画像
*/
+ (UIImage *)getImageFromView:(UIView *)view withScale:(float)scale;

/**
* @brief 画像を指定した座標で切り抜く
* @param image 対象の画像
* @param rect 切り抜く座標
* @return 切り抜いた画像
*/
+ (UIImage *)cutImage:(UIImage *)image withRect:(CGRect)rect;

/**
* @brief 画像を回転させる
* @param image 対象の画像
* @param angle 角度
* @return 回転させた画像
*/
+ (UIImage *)rotateImage:(UIImage *)image withAngle:(int)angle;

/**
* @brief 画像を反転させる
* @param image 対象の画像
* @return 反転させた画像
*/
+ (UIImage *)reverseImage:(UIImage *)image;

@end
