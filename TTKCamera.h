//
//  TTK_Camera.h
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/20.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TTKCameraDelegate;

@interface TTKCamera : UIView
typedef enum : NSInteger {
    kDeviceTypeRearCamera,
    kDeviceTypeFrontCamera
} DeviceType;

// 写真を正方形に撮影するかどうか
@property (nonatomic, readwrite) BOOL isSquare;

- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate;

/**
* @brief プレビューをスタート
*/
- (void)start;

/**
* @brief プレビューを止める
*/
- (void)stop;

/**
* @brief 撮影する
* 撮影後にdelegateのdidTakePictureが呼ばれる
*/
- (void)take;

/**
* @brief デバイスのinputを設定する
* @param type 設定するデバイスのタイプ
*/
- (void)setDeviceInputWithType:(DeviceType)type;

@end

#pragma mark -


/**
* @brief 撮影の時に呼ばれるデリゲート
*/
@protocol TTKCameraDelegate <NSObject>

@optional
/**
 * @brief 撮影した後に呼ばれる
 * @param image 撮影した画像
 */
- (void)didTakePicture:(UIImage *)image;

@end