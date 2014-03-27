//
//  TTK_Stamp.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/22.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "TTKEditImage.h"

// フィルタを使う時にCoreImage.frameworkが必要になる
#import <CoreImage/CoreImage.h>

@interface TTKEditImage()
@end

@implementation TTKEditImage

/**
* @brief Viewから画像を取得する
* @param view 画像を取得したいView
* @return 取得した画像
*/
+ (UIImage *)getImageFromView:(UIView *)view withScale:(float)scale
{
    CGSize size = view.frame.size;
    CALayer *layer = view.layer;
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/**
* @brief 画像を指定した座標で切り抜く
* @param image 対象の画像
* @param rect 切り抜く座標
* @return 切り抜いた画像
*/
+ (UIImage *)cutImage:(UIImage *)image withRect:(CGRect)rect
{
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;

    // 描画するためのキャンバスを生成する
    UIGraphicsBeginImageContext(CGSizeMake(rect.size.width, rect.size.height));
    
    // 画像を描画する
    [image drawInRect:CGRectMake(-rect.origin.x, -rect.origin.y, imageWidth, imageHeight)];
    
    // 描画した画像を取得する
    UIImage *cutImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
 
    return cutImage;
}

/**
* @brief 画像を回転させる
* @param image 対象の画像
* @param angle 角度
* @return 回転させた画像
*/
+ (UIImage *)rotateImage:(UIImage *)image withAngle:(int)angle
{
    CGContextRef context;
    
    // TODO: 複雑な角度には対応する
    switch (angle) {
        case 90:
            UIGraphicsBeginImageContext(CGSizeMake(image.size.height, image.size.width));
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, image.size.height, image.size.width);
            CGContextScaleCTM(context, 1, -1);
            CGContextRotateCTM(context, M_PI_2);
            break;
        case 180:
            UIGraphicsBeginImageContext(CGSizeMake(image.size.width, image.size.height));
            context = UIGraphicsGetCurrentContext();
            CGContextTranslateCTM(context, image.size.width, 0);
            CGContextScaleCTM(context, 1, -1);
            CGContextRotateCTM(context, -M_PI);
            break;
        case 270:
            UIGraphicsBeginImageContext(CGSizeMake(image.size.height, image.size.width));
            context = UIGraphicsGetCurrentContext();
            CGContextScaleCTM(context, 1, -1);
            CGContextRotateCTM(context, -M_PI_2);
            break;
        default:
            return image;
            break;
    }
    
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    UIImage* rotateImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return rotateImage;
}

/**
* @brief 画像を反転させる
* @param image 対象の画像
* @return 反転させた画像
*/
+ (UIImage *)reverseImage:(UIImage *)image
{
    // TODO: 何で左右に反転してるの？
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, image.size.width, image.size.height);
    CGContextScaleCTM(context, -1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0, 0, image.size.width, image.size.height), image.CGImage);
    UIImage *reverseImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return reverseImage;
}

@end