//
//  TTK_Camera.m
//  illustCamera
//
//  Created by Kashima Takumi on 2014/02/20.
//  Copyright (c) 2014年 TEAM TAKOYAKI. All rights reserved.
//

#import "TTKCamera.h"
#import "TTKMacro.h"
#import <AVFoundation/AVFoundation.h>
#import "TTKEditImage.h"

@interface TTKCamera ()
@property (strong, nonatomic) UIView *previewView;
@property (strong, nonatomic) AVCaptureSession *session;
@property (strong, nonatomic) AVCaptureDeviceInput *videoInput;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (weak, nonatomic) id <TTKCameraDelegate> delegate;
@end

@implementation TTKCamera

- (id)initWithFrame:(CGRect)frame withDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        
        [self initWithView];
    }
    return self;
}

- (void)initWithView
{
    CGRect rect = self.frame;
    self.previewView = [[UIView alloc] initWithFrame:rect];
    
    self.isSquare = YES;
    
    [self setupAVCapture];
}

- (void)setupAVCapture
{
    // InputとOutputの設定をする
    self.session = [[AVCaptureSession alloc] init];
    // カメラを設定する
    self.videoInput = [self getDeviceInput:kDeviceTypeRearCamera];
    [self.session beginConfiguration];
    
    [self.session addInput:self.videoInput];
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    [self.session addOutput:self.stillImageOutput];

    [self.session commitConfiguration];
    
    
    // PreviewのためのViewを設定する
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    captureVideoPreviewLayer.frame = self.bounds;
    captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    CALayer *previewLayer = self.previewView.layer;
    previewLayer.masksToBounds = YES;
    [previewLayer addSublayer:captureVideoPreviewLayer];

#ifdef DEBUG
    [self.previewView setBackgroundColor:[UIColor redColor]];
#endif
    
    [self addSubview:self.previewView];
}

- (void)start
{
    [self.session startRunning];
}

- (void)stop
{
    [self.session stopRunning];
}

/**
* @brief 撮影する
* 撮影後にdelegateのdidTakePictureが呼ばれる
*/
- (void)take
{
    AVCaptureConnection *videoConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    
    if (videoConnection == nil) {
        return;
    }

    // 画像を撮影した時に非同期で呼ばれる
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection
                                                       completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        
        UIImage *image = [[UIImage alloc] initWithData:imageData];

        CGFloat distImageWidth  = 0;
        CGFloat distImageHeight = 0;
        
        // 最終的な画像の大きさ(比)を設定する
        // 正方形の時
        if (_isSquare) {
            distImageWidth = self.frame.size.width;
            distImageHeight = self.frame.size.width;
        } else {
            distImageWidth = self.frame.size.width;
            distImageHeight = self.frame.size.height;
        }

        // 画像の大きさを取得する
        // 画面とは縦、横が逆のため逆にする
        CGFloat realImageWidth = image.size.width;
        CGFloat realImageHeight = image.size.height;
        
        // 画像の大きさと最終的な画像の大きさの比を取得する
        // 最終的な画像の大きさより写真の方が大きい
        float rate = distImageWidth / realImageWidth;
                    
        // 写真の縦の大きさに比をかけて最終的な画像の大きさに直す
        float imageHeight = realImageHeight * rate;
        
        // 画像の大きさと最終的な画像の大きさの差を取得する
        float h = imageHeight - distImageHeight;
    
        // 画像の方が縦が最終的な画像より大きいため上下を切りとる
        // そのための上下のスペースの大きさ
        float oneSpace = h / 2;

        // スペースを実際の写真の大きさの比をかけて取得する
        float realOneSpace = oneSpace * (1 / rate);
        
        // 切り取る縦の大きさを取得する
        realImageHeight = realImageHeight - realOneSpace * 2;
        
        // 整数にする
        realImageWidth  = floor(realImageWidth);
        realImageHeight = floor(realImageHeight);
        
        // 切り取る領域を取得する
        CGRect cutRect = CGRectMake(0,
                                    realOneSpace,
                                    realImageWidth,
                                    realImageHeight);
        
        // 写真を切り取る
        UIImage *cutImage = [TTKEditImage cutImage:image withRect:cutRect];
        
        // 撮影して切り抜いた画像をデリゲートに渡す
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(didTakePicture:)]) {
                [self.delegate didTakePicture:cutImage];
            }
        }
    }];
}

- (void)setDeviceInputWithType:(DeviceType)type
{
    AVCaptureDeviceInput *deviceInput = [self getDeviceInput:type];
    [self setDeviceInput:deviceInput];
}

- (void)setDeviceInput:(AVCaptureDeviceInput *)deviceInput
{
    NSAssert(deviceInput != nil, @"device input is nil.");
    [self.session beginConfiguration];
    
    [self.session removeInput:self.videoInput];
    self.videoInput = deviceInput;
    [self.session addInput:self.videoInput];
    
    [self.session commitConfiguration];
}

/**
* @brief 指定したタイプのカメラを設定する
* @param type カメラのタイプ
* @return Device input
*/
- (AVCaptureDeviceInput *)getDeviceInput:(DeviceType)type
{
    AVCaptureDevicePosition findPosition;
    switch (type) {
    case kDeviceTypeFrontCamera:
        findPosition = AVCaptureDevicePositionFront;
        break;
    default:
        findPosition = AVCaptureDevicePositionBack;
        break;
    }

    AVCaptureDeviceInput *deviceInput = nil;
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices) {
        if ([device hasMediaType:AVMediaTypeVideo]) {
            NSError *error = nil;
            if (device.position == findPosition) {
                deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
                if (error != nil) {
                    NSLog(@"Error: camera type");
                    return nil;
                }
                break;
            }
        }
    }
    
    if (!deviceInput) {
        AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
        NSError *error = nil;
        deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
        if (error != nil) {
            NSLog(@"Error: camera type");
            return nil;
        }
    }
    return deviceInput;
}
@end
