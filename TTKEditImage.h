//
//  TTK_Stamp.h
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/22.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TTKEditImage : NSObject

/**********************************************
* 画像加工関連
**********************************************/

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

/**********************************************
* フィルタ関連
**********************************************/

/**
* @brief セピアフィルタ
* @param image フィルタをかける画像
* @param intensity フィルタをどれくらいかけるか (デフォルト値: 1.0, 範囲: 0.0〜1.0)
* @return フィルタがかかった画像
*/
+ (UIImage *)imageFilterSepia:(UIImage *)image withIntensity:(CGFloat)intensity;

/**
* @brief グレースケールフィルタ
* @param image フィルタをかける画像
* @return フィルタがかかった画像
*/
+ (UIImage *)imageFilterGrayScale:(UIImage *)image withIntensity:(CGFloat)intensity;

/**
* @brief 色調整フィルタ
* @param image フィルタをかける画像
* @param s 彩度 (デフォルト値: 1.0, 範囲: 0.0〜3.0)
* @param b 輝度 (デフォルト値: 0.0, 範囲: -1.0〜1.0)
* @param c コントラスト (デフォルト値: 1.0, 範囲: 0.25〜4.0)
* @return フィルタがかかった画像
*/
+ (UIImage *)imageFilterColorAdjustment:(UIImage *)image withSaturation:(CGFloat)s
                                                             Brightness:(CGFloat)b
                                                               Contrast:(CGFloat)c;

/**
* @brief トーンカーブフィルタ
* @param image   フィルタをかける画像
* @param vectors トーンカーブのポイント (CIVectorが5つ入った配列)
* @return フィルタがかかった画像
*/
+ (UIImage *)imageFilterToneCurve:(UIImage *)image withVectors:(NSArray *)vectors;

@end
