//
//  eTakeCameraViewController.m
//  eCameraLib_Example
//
//  Created by liuyutian on 2019/7/25.
//  Copyright © 2019年 24290265@qq.com. All rights reserved.
//

#import "eTakeCameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMotion/CoreMotion.h>


#define eTakeCamera_BUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]

#define eTakeCamera_BUNDLE [NSBundle bundleWithPath: eTakeCamera_BUNDLE_PATH]

#define eTakeCamera_IMG(img) [UIImage imageWithContentsOfFile:[eTakeCamera_BUNDLE_PATH stringByAppendingPathComponent:(img)]]

#define eTakeCamera_RGB(r, g, b)   [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]




#ifndef eTakeCamera_weakify
#if DEBUG
#if __has_feature(objc_arc)
#define eTakeCamera_weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define eTakeCamera_weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define eTakeCamera_weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define eTakeCamera_weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif

#ifndef eTakeCamera_strongify
#if DEBUG
#if __has_feature(objc_arc)
#define eTakeCamera_strongify(object) autoreleasepool{} __typeof__(object) object = weak##_##object;
#else
#define eTakeCamera_strongify(object) autoreleasepool{} __typeof__(object) object = block##_##object;
#endif
#else
#if __has_feature(objc_arc)
#define eTakeCamera_strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#else
#define eTakeCamera_strongify(object) try{} @finally{} __typeof__(object) object = block##_##object;
#endif
#endif
#endif




@interface eTakeCameraViewController ()<UIAlertViewDelegate>{
    
}
//预览图层，显示相机拍摄到的画面
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong ,readwrite) UIImageView *takedImageView;

//聚焦照片
@property (weak, nonatomic) IBOutlet UIImageView *focusCursorImageView;
//拍色底部图
@property (weak, nonatomic) IBOutlet UIView *bottomView;
//底部图辅色
@property (weak, nonatomic) IBOutlet UIView *topView;
//确定按钮
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
//重新发起按钮
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

//返回页面
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;

//设置移动位置

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneButtonAlignX;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonAlignX;




//拍照录视频相关
//AVCaptureSession对象来执行输入设备和输出设备之间的数据传递
@property (nonatomic, strong) AVCaptureSession *session;
//AVCaptureDeviceInput对象是输入流
@property (nonatomic, strong) AVCaptureDeviceInput *videoInput;
//照片输出流对象
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutPut;
//拍照的照片
@property (nonatomic, strong ,readwrite) UIImage *takedImage;


//设备方向
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, assign) AVCaptureVideoOrientation orientation;


@end

@implementation eTakeCameraViewController


- (void)dealloc
{
    if ([_session isRunning]) {
        [_session stopRunning];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self.session startRunning];
    [self setFocusCursorWithPoint:self.view.center];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.session) {
        [self.session stopRunning];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setupCamera];
    
    //权限跟后台退出
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
        if (!granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请打开相机权限" message:@"设置-隐私-相机" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                alertView.delegate =self;
                [alertView show];
            });
        } else {
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(willResignActive) name:UIApplicationWillResignActiveNotification object:nil];
        }
    }];
}

- (void)willResignActive
{
    if ([self.session isRunning]) {
        if (self.presentationController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.previewLayer.frame = self.view.layer.bounds;
}


#pragma mark - 监控设备方向
- (void)observeDeviceMotion
{
    self.motionManager = [[CMMotionManager alloc] init];
    // 提供设备运动数据到指定的时间间隔
    self.motionManager.deviceMotionUpdateInterval = .5;
    
    if (self.motionManager.deviceMotionAvailable) {  // 确定是否使用任何可用的态度参考帧来决定设备的运动是否可用
        // 启动设备的运动更新，通过给定的队列向给定的处理程序提供数据。
        [self.motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMDeviceMotion *motion, NSError *error) {
            [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    } else {
        self.motionManager = nil;
    }
}

- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion
{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    
    if (fabs(y) >= fabs(x)) {
        if (y >= 0){
            // UIDeviceOrientationPortraitUpsideDown;
            self.orientation = AVCaptureVideoOrientationPortraitUpsideDown;
        } else {
            // UIDeviceOrientationPortrait;
            self.orientation = AVCaptureVideoOrientationPortrait;
        }
    } else {
        if (x >= 0) {
            //视频拍照转向，左右和屏幕转向相反
            // UIDeviceOrientationLandscapeRight;
            self.orientation = AVCaptureVideoOrientationLandscapeLeft;
        } else {
            // UIDeviceOrientationLandscapeLeft;
            self.orientation = AVCaptureVideoOrientationLandscapeRight;
        }
    }
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}




#pragma -mark 设置UI

- (void)setUI
{
    self.bottomView.layer.masksToBounds = YES;
    self.bottomView.layer.cornerRadius = 30.0f;
    self.topView.layer.masksToBounds = YES;
    self.topView.layer.cornerRadius = 21.0f;
}

- (void)setupCamera
{
    self.session = [[AVCaptureSession alloc] init];
    
    //相机画面输入流
    self.videoInput = [AVCaptureDeviceInput deviceInputWithDevice:[self backCamera] error:nil];
    
    //照片输出流
    self.imageOutPut = [[AVCaptureStillImageOutput alloc] init];
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    NSDictionary *dicOutputSetting = [NSDictionary dictionaryWithObject:AVVideoCodecJPEG forKey:AVVideoCodecKey];
    [self.imageOutPut setOutputSettings:dicOutputSetting];
    //将视频及音频输入流添加到session
    if ([self.session canAddInput:self.videoInput]) {
        [self.session addInput:self.videoInput];
    }
    //将输出流添加到session
    if ([self.session canAddOutput:self.imageOutPut]) {
        [self.session addOutput:self.imageOutPut];
    }
    //预览层
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.view.layer setMasksToBounds:YES];
    
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.view.layer insertSublayer:self.previewLayer atIndex:0];
}


- (AVCaptureDevice *)frontCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionFront];
}

- (AVCaptureDevice *)backCamera {
    return [self cameraWithPosition:AVCaptureDevicePositionBack];
}

- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition) position {
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if ([device position] == position) {
            return device;
        }
    }
    return nil;
}


- (void)takPicture
{
    [self showCancelDoneBtn];
    
    AVCaptureConnection * videoConnection = [self.imageOutPut connectionWithMediaType:AVMediaTypeVideo];
    videoConnection.videoOrientation = self.orientation;

    if (!_takedImageView) {
        _takedImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        _takedImageView.backgroundColor = [UIColor blackColor];
        _takedImageView.hidden = YES;
        _takedImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.view addSubview:_takedImageView];
        [self.view sendSubviewToBack:_takedImageView];
        
    }
    @eTakeCamera_weakify(self);
    [self.imageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        @eTakeCamera_strongify(self);
        if (imageDataSampleBuffer == NULL) {
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage * image = [UIImage imageWithData:imageData];
        self.takedImage = image;
        self.takedImageView.hidden = NO;
        self.takedImageView.image = image;
        [self.session stopRunning];
    }];
}

#pragma -mark UITapGestureRecognizerAction
//拍照手势
- (IBAction)takPicAction:(UITapGestureRecognizer *)sender {
    [self takPicture];
}
//设置焦点
- (IBAction)adjustFocusPoint:(UITapGestureRecognizer *)sender {
    
    if (!self.session.isRunning) return;
    
    CGPoint point = [sender locationInView:self.view];

    [self setFocusCursorWithPoint:point];
}
#pragma -mark 按钮点击事件

- (IBAction)doneButtonAction:(UIButton *)sender {
    [self PhotographsCompleted];
}
- (IBAction)cancelButtonAction:(UIButton *)sender {
    [self resetUI];
    [self.session startRunning];
    [self setFocusCursorWithPoint:self.view.center];
    if (self.takedImage != nil) {
        [UIView animateWithDuration:1 animations:^{
            self.takedImageView.alpha = 0;
        } completion:^(BOOL finished) {
            self.takedImageView.hidden = YES;
            self.takedImageView.alpha = 1;
        }];
    }
}

- (IBAction)dismissButtonAction:(UIButton *)sender {
    if (self.presentationController) {
         [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
   
}

- (void)PhotographsCompleted
{
    if (self.presentationController) {
        [self dismissViewControllerAnimated:YES completion:^{
            if (self.doneBlock) {
                self.doneBlock(self.takedImage);
            }
        }];
    }else{
        if (self.doneBlock) {
            self.doneBlock(self.takedImage);
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

//设置聚焦光标位置
- (void)setFocusCursorWithPoint:(CGPoint)point
{
    self.focusCursorImageView.center = point;
    self.focusCursorImageView.alpha = 1;
    self.focusCursorImageView.hidden = NO;
    self.focusCursorImageView.transform = CGAffineTransformMakeScale(1.1, 1.1);
    [UIView animateWithDuration:0.5 animations:^{
        self.focusCursorImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursorImageView.hidden =YES;
        self.focusCursorImageView.alpha=0;
    }];
    
    //将UI坐标转化为摄像头坐标
    CGPoint cameraPoint = [self.previewLayer captureDevicePointOfInterestForPoint:point];
    [self focusWithMode:AVCaptureFocusModeAutoFocus exposureMode:AVCaptureExposureModeAutoExpose atPoint:cameraPoint];
}

//设置聚焦点
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposureMode:(AVCaptureExposureMode)exposureMode atPoint:(CGPoint)point
{
    AVCaptureDevice * captureDevice = [self.videoInput device];
    NSError * error;
    //注意改变设备属性前一定要首先调用lockForConfiguration:调用完之后使用unlockForConfiguration方法解锁
    if (![captureDevice lockForConfiguration:&error]) {
        return;
    }
    //聚焦模式
    if ([captureDevice isFocusModeSupported:focusMode]) {
        [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    //聚焦点
    if ([captureDevice isFocusPointOfInterestSupported]) {
        [captureDevice setFocusPointOfInterest:point];
    }
    //曝光模式
    if ([captureDevice isExposureModeSupported:exposureMode]) {
        [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
    }
    //曝光点
    if ([captureDevice isExposurePointOfInterestSupported]) {
        [captureDevice setExposurePointOfInterest:point];
    }
    [captureDevice unlockForConfiguration];
}




#pragma mark - 动画
- (void)showCancelDoneBtn
{
    self.dismissButton.hidden = YES;
    self.bottomView.hidden = YES;
    self.cancelButton.hidden = NO;
    self.doneButton.hidden = NO;
    [UIView animateWithDuration:.1 animations:^{
        self.cancelButtonAlignX.constant = eTakeCamera_ViewWidth/2-90;
        self.doneButtonAlignX.constant = -(eTakeCamera_ViewWidth/2-90);
    }];
}

- (void)resetUI
{
    self.dismissButton.hidden = NO;
    self.bottomView.hidden = NO;
    self.cancelButton.hidden = YES;
    self.doneButton.hidden = YES;
    self.cancelButtonAlignX.constant = 0;
    self.doneButtonAlignX.constant = 0;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }else{
        if (self.presentationController) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    }
}
@end
