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

/**
* @brief セピアフィルタ
* @param image フィルタをかける画像
* @param intensity フィルタをどれくらいかけるか (デフォルト値: 1.0, 範囲: 0.0〜1.0)
* @return フィルタがかかった画像
*/
+ (UIImage *)imageFilterSepia:(UIImage *)image withIntensity:(CGFloat)intensity
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *ciFilter = [CIFilter filterWithName:@"CISepiaTone"
                                    keysAndValues:kCIInputImageKey, ciImage,
                                    @"inputIntensity", [NSNumber numberWithFloat:intensity],
                                    nil];

    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];
    UIImage *filterImage = [UIImage imageWithCGImage:cgImage scale:1.0f orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    return filterImage;
}

/**
* @brief グレースケールフィルタ
* @param image フィルタをかける画像
* @param itensity フィルタをどれくらいかけるか (デフォルト値: 1.0, 範囲: 0.0〜1.0)
* @param rate 単色の割合
* @return フィルタがかかった画像
*/
+ (UIImage *)imageFilterGrayScale:(UIImage *)image withIntensity:(CGFloat)intensity singleColorRate:(CGFloat)rate
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *ciFilter = [CIFilter filterWithName:@"CIColorMonochrome"
                                    keysAndValues:kCIInputImageKey, ciImage,
                                    @"inputColor", [CIColor colorWithRed:rate green:rate blue:rate],
                                    @"inputIntensity", [NSNumber numberWithFloat:intensity],
                                    nil];
    
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];
    UIImage *filterImage = [UIImage imageWithCGImage:cgImage scale:1.0f orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    return filterImage;
}

/**
* @brief 色調整フィルタ
* @param image フィルタをかける画像
* @param s 彩度 (デフォルト値: 1.0f, 範囲: 0.0〜3.0)
* @param b 輝度 (デフォルト値: 0.0f, 範囲: -1.0〜1.0)
* @param c コントラスト (デフォルト値: 1.0f, 範囲: 0.25〜4.0)
* @return フィルタがかかった画像
*/
+ (UIImage *)imageFilterColorAdjustment:(UIImage *)image withSaturation:(CGFloat)s
                                                             brightness:(CGFloat)b
                                                               contrast:(CGFloat)c
{
    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *ciFilter = [CIFilter filterWithName:@"CIColorControls"
                                    keysAndValues:kCIInputImageKey, ciImage,
                                    @"inputSaturation", [NSNumber numberWithFloat:s],
                                    @"inputBrightness", [NSNumber numberWithFloat:b],
                                    @"inputContrast", [NSNumber numberWithFloat:c],
                                    nil];
    
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];
    UIImage *filterImage = [UIImage imageWithCGImage:cgImage scale:1.0f orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    return filterImage;
}

/**
* @brief トーンカーブフィルタ
* @param image   フィルタをかける画像
* @param vectors トーンカーブのポイント (CIVectorが5つ入った配列)
* @return フィルタがかかった画像
*/
+ (UIImage *)imageFilterToneCurve:(UIImage *)image withVectors:(NSArray *)vectors
{
    CIVector *vec0 = (CIVector *)[vectors objectAtIndex:0];
    CIVector *vec1 = (CIVector *)[vectors objectAtIndex:1];
    CIVector *vec2 = (CIVector *)[vectors objectAtIndex:2];
    CIVector *vec3 = (CIVector *)[vectors objectAtIndex:3];
    CIVector *vec4 = (CIVector *)[vectors objectAtIndex:4];

    CIImage *ciImage = [[CIImage alloc] initWithImage:image];
    CIFilter *ciFilter = [CIFilter filterWithName:@"CIToneCurve"
                                    keysAndValues:kCIInputImageKey, ciImage,
                                    @"inputPoint0", vec0,
                                    @"inputPoint1", vec1,
                                    @"inputPoint2", vec2,
                                    @"inputPoint3", vec3,
                                    @"inputPoint4", vec4,
                                    nil];
    
    CIContext *ciContext = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [ciContext createCGImage:[ciFilter outputImage] fromRect:[[ciFilter outputImage] extent]];
    UIImage *filterImage = [UIImage imageWithCGImage:cgImage scale:1.0f orientation:UIImageOrientationUp];
    CGImageRelease(cgImage);
    return filterImage;
}

@end