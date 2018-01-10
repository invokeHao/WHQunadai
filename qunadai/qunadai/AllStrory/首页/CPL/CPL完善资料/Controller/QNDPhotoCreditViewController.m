//
//  QNDPhotoCreditViewController.m
//  qunadai
//
//  Created by 王浩 on 2017/12/26.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDPhotoCreditViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

#import "QNDCameraView.h"

#import "QNDSaveHoldIdPicApi.h"
#import "CPLUserInfoSubmitApi.h"
#import "QNDCPLUserInfoSubmitApi.h"



@interface QNDPhotoCreditViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate,QNDCameraViewDelegate,YTKChainRequestDelegate>
{
    // 会话
    AVCaptureSession          *_captureSession;
    
    // 输入
    AVCaptureDeviceInput      *_deviceInput;
    
    // 输出
    AVCaptureConnection       *_videoConnection;
    AVCaptureStillImageOutput *_imageOutput;
    
    UIImageView * coverImageV;//遮盖view
    BOOL havePhoto;//拍完照
    UIImage * currentImage;
}
@property(nonatomic,strong) QNDCameraView * cameraView;
@property(nonatomic, strong) AVCaptureDevice *activeCamera;   // 当前输入设备
@property(nonatomic, strong) AVCaptureDevice *inactiveCamera; // 不活跃的设备(这里指前摄像头或后摄像头，不包括外接输入设备)
@property(nonatomic, assign) AVCaptureFlashMode currentflashMode; // 当前闪光灯的模式
@end

@implementation QNDPhotoCreditViewController

- (instancetype)init{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    self.cameraView = [[QNDCameraView alloc] initWithFrame:self.view.bounds];
    self.cameraView.delegate = self;
    [self.view addSubview:self.cameraView];
    
    coverImageV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"CoverMask"]];
    [coverImageV setBounds:CGRectMake(0, 0, 230*ViewWidth/375, 454*ViewHeight/667)];
    [coverImageV setCenter:CGPointMake(ViewWidth/2, ViewHeight/2-64)];
    [self.cameraView.previewView addSubview:coverImageV];
    [self.cameraView.previewView insertSubview:coverImageV atIndex:1];
    
    NSError *error;
    [self setupSession:&error];
    if (!error) {
        [self.cameraView.previewView setCaptureSessionsion:_captureSession];
        [self startCaptureSession];
    }
    else{
        [[WHTool shareInstance]showALterViewWithOneButton:@"好的" andMessage:error.description];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)dealloc{
    NSLog(@"相机界面销毁了");
}

#pragma mark - -输入设备
- (AVCaptureDevice *)cameraWithPosition:(AVCaptureDevicePosition)position{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        if (device.position == position) {
            return device;
        }
    }
    return nil;
}

- (AVCaptureDevice *)activeCamera{
    return _deviceInput.device;
}

- (AVCaptureDevice *)inactiveCamera{
    AVCaptureDevice *device = nil;
    if ([[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1) {
        if ([self activeCamera].position == AVCaptureDevicePositionBack) {
            device = [self cameraWithPosition:AVCaptureDevicePositionFront];
        } else {
            device = [self cameraWithPosition:AVCaptureDevicePositionBack];
        }
    }
    return device;
}

#pragma mark - -相关配置
// 会话
- (void)setupSession:(NSError **)error{
    _captureSession = [[AVCaptureSession alloc]init];
    [_captureSession setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self setupSessionInputs:error];
    [self setupSessionOutputs:error];
}

// 输入
- (void)setupSessionInputs:(NSError **)error{
    // 视频输入
    AVCaptureDevice *videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:error];
    if (videoInput) {
        if ([_captureSession canAddInput:videoInput]){
            [_captureSession addInput:videoInput];
            _deviceInput = videoInput;
        }
    }
}

// 输出
- (void)setupSessionOutputs:(NSError **)error{
    // 静态图片输出
    AVCaptureStillImageOutput *imageOutput = [[AVCaptureStillImageOutput alloc] init];
    imageOutput.outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    if ([_captureSession canAddOutput:imageOutput]) {
        [_captureSession addOutput:imageOutput];
        _imageOutput = imageOutput;
    }
}

#pragma mark - -会话控制
// 开启捕捉
- (void)startCaptureSession{
    if (!_captureSession.isRunning){
        [_captureSession startRunning];
    }
}

// 停止捕捉
- (void)stopCaptureSession{
    if (_captureSession.isRunning){
        [_captureSession stopRunning];
    }
}

#pragma mark - -拍摄照片
-(void)takePictureImage{
    AVCaptureConnection *connection = [_imageOutput connectionWithMediaType:AVMediaTypeVideo];
    id takePictureSuccess = ^(CMSampleBufferRef sampleBuffer,NSError *error){
        if (sampleBuffer == NULL) {
            [[WHTool shareInstance]showALterViewWithOneButton:@"好的" andMessage:error.description];
            return ;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];
        UIImage *image = [[UIImage alloc]initWithData:imageData];
        UIImageView * resultImageV = [[UIImageView alloc]initWithImage:image];
        resultImageV.contentMode = UIViewContentModeScaleAspectFill;
        resultImageV.layer.masksToBounds = YES;
        [resultImageV setFrame:self.cameraView.previewView.bounds];
        currentImage = resultImageV.image;
        WHLog(@"%f,%f",currentImage.size.width,currentImage.size.height);
        [self.cameraView.previewView addSubview:resultImageV];
    };
    [_imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:takePictureSuccess];
}

#pragma mark - -转换前后摄像头
- (void)swicthCameraAction:(QNDCameraView *)cameraView succ:(void (^)(void))succ fail:(void (^)(NSError *))fail{
    id error = [self switchCameras];
    error?!fail?:fail(error):!succ?:succ();
}

- (BOOL)canSwitchCameras{
    return [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count] > 1;
}

- (id)switchCameras{
    if (![self canSwitchCameras]) return nil;
    
    NSError *error;
    AVCaptureDevice *videoDevice = [self inactiveCamera];
    AVCaptureDeviceInput *videoInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    if (videoInput) {
        [_captureSession beginConfiguration];
        [_captureSession removeInput:_deviceInput];
        if ([_captureSession canAddInput:videoInput]) {
            [_captureSession addInput:videoInput];
            _deviceInput = videoInput;
        }
        [_captureSession commitConfiguration];
        
        // 如果后置转前置，系统会自动关闭手电筒，如果之前打开的，需要通知camera更新UI
        if (videoDevice.position == AVCaptureDevicePositionFront) {
            [self.cameraView changeTorch:NO];
        }
        // 前后摄像头的闪光灯不是同步的，所以在转换摄像头后需要重新设置闪光灯
        [self changeFlash:_currentflashMode];
        
        return nil;
    }
    return error;
}

#pragma mark - -聚焦
-(void)focusAction:(QNDCameraView *)cameraView point:(CGPoint)point succ:(void (^)(void))succ fail:(void (^)(NSError *))fail{
    id error = [self focusAtPoint:point];
    error?!fail?:fail(error):!succ?:succ();
}

- (BOOL)cameraSupportsTapToFocus{
    return [[self activeCamera] isFocusPointOfInterestSupported];
}

- (id)focusAtPoint:(CGPoint)point{
    AVCaptureDevice *device = [self activeCamera];
    if ([self cameraSupportsTapToFocus] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]){
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.focusPointOfInterest = point;
            device.focusMode = AVCaptureFocusModeAutoFocus;
            [device unlockForConfiguration];
        }
        return error;
    }
    return nil;
}

#pragma mark - -曝光
-(void)exposAction:(QNDCameraView *)cameraView point:(CGPoint)point succ:(void (^)(void))succ fail:(void (^)(NSError *))fail{
    id error = [self exposeAtPoint:point];
    error?!fail?:fail(error):!succ?:succ();
}

- (BOOL)cameraSupportsTapToExpose{
    return [[self activeCamera] isExposurePointOfInterestSupported];
}

static const NSString *CameraAdjustingExposureContext;
- (id)exposeAtPoint:(CGPoint)point{
    AVCaptureDevice *device = [self activeCamera];
    if ([self cameraSupportsTapToExpose] && [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.exposurePointOfInterest = point;
            device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
            if ([device isExposureModeSupported:AVCaptureExposureModeLocked]) {
                [device addObserver:self forKeyPath:@"adjustingExposure" options:NSKeyValueObservingOptionNew context:&CameraAdjustingExposureContext];
            }
            [device unlockForConfiguration];
        }
        return error;
    }
    return nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    if (context == &CameraAdjustingExposureContext) {
        AVCaptureDevice *device = (AVCaptureDevice *)object;
        if (!device.isAdjustingExposure && [device isExposureModeSupported:AVCaptureExposureModeLocked]) {
            [object removeObserver:self forKeyPath:@"adjustingExposure" context:&CameraAdjustingExposureContext];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error;
                if ([device lockForConfiguration:&error]) {
                    device.exposureMode = AVCaptureExposureModeLocked;
                    [device unlockForConfiguration];
                } else {
                    [[WHTool shareInstance]showALterViewWithOneButton:@"好的" andMessage:error.description];
                }
            });
        }
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - -自动聚焦、曝光
-(void)autoFocusAndExposureAction:(QNDCameraView *)cameraView succ:(void (^)(void))succ fail:(void (^)(NSError *))fail{
    id error = [self resetFocusAndExposureModes];
    error?!fail?:fail(error):!succ?:succ();
}

- (id)resetFocusAndExposureModes{
    AVCaptureDevice *device = [self activeCamera];
    AVCaptureExposureMode exposureMode = AVCaptureExposureModeContinuousAutoExposure;
    AVCaptureFocusMode focusMode = AVCaptureFocusModeContinuousAutoFocus;
    BOOL canResetFocus = [device isFocusPointOfInterestSupported] && [device isFocusModeSupported:focusMode];
    BOOL canResetExposure = [device isExposurePointOfInterestSupported] && [device isExposureModeSupported:exposureMode];
    CGPoint centerPoint = CGPointMake(0.5f, 0.5f);
    NSError *error;
    if ([device lockForConfiguration:&error]) {
        if (canResetFocus) {
            device.focusMode = focusMode;
            device.focusPointOfInterest = centerPoint;
        }
        if (canResetExposure) {
            device.exposureMode = exposureMode;
            device.exposurePointOfInterest = centerPoint;
        }
        [device unlockForConfiguration];
    }
    return error;
}

#pragma mark - -闪光灯
-(void)flashLightAction:(QNDCameraView *)cameraView succ:(void (^)(void))succ fail:(void (^)(NSError *))fail{
    id error = [self changeFlash:[self flashMode] == AVCaptureFlashModeOn?AVCaptureFlashModeOff:AVCaptureFlashModeOn];
    error?!fail?:fail(error):!succ?:succ();
}

- (BOOL)cameraHasFlash{
    return [[self activeCamera] hasFlash];
}

- (AVCaptureFlashMode)flashMode{
    return [[self activeCamera] flashMode];
}

- (id)changeFlash:(AVCaptureFlashMode)flashMode{
    if (![self cameraHasFlash]) {
        NSDictionary *desc = @{NSLocalizedDescriptionKey:@"不支持闪光灯"};
        NSError *error = [NSError errorWithDomain:@"com.cc.camera" code:401 userInfo:desc];
        return error;
    }
    // 如果手电筒打开，先关闭手电筒
    if ([self torchMode] == AVCaptureTorchModeOn) {
        [self setTorchMode:AVCaptureTorchModeOff];
    }
    return [self setFlashMode:flashMode];
}

- (id)setFlashMode:(AVCaptureFlashMode)flashMode{
    AVCaptureDevice *device = [self activeCamera];
    if ([device isFlashModeSupported:flashMode]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.flashMode = flashMode;
            [device unlockForConfiguration];
            _currentflashMode = flashMode;
        }
        return error;
    }
    return nil;
}

#pragma mark - -手电筒
-(void)torchLightAction:(QNDCameraView *)cameraView succ:(void (^)(void))succ fail:(void (^)(NSError *))fail{
    id error =  [self changeTorch:[self torchMode] == AVCaptureTorchModeOn?AVCaptureTorchModeOff:AVCaptureTorchModeOn];
    error?!fail?:fail(error):!succ?:succ();
}

- (BOOL)cameraHasTorch {
    return [[self activeCamera] hasTorch];
}

- (AVCaptureTorchMode)torchMode {
    return [[self activeCamera] torchMode];
}

- (id)changeTorch:(AVCaptureTorchMode)torchMode{
    if (![self cameraHasTorch]) {
        NSDictionary *desc = @{NSLocalizedDescriptionKey:@"不支持手电筒"};
        NSError *error = [NSError errorWithDomain:@"com.cc.camera" code:403 userInfo:desc];
        return error;
    }
    // 如果闪光灯打开，先关闭闪光灯
    if ([self flashMode] == AVCaptureFlashModeOn) {
        [self setFlashMode:AVCaptureFlashModeOff];
    }
    return [self setTorchMode:torchMode];
}

- (id)setTorchMode:(AVCaptureTorchMode)torchMode{
    AVCaptureDevice *device = [self activeCamera];
    if ([device isTorchModeSupported:torchMode]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            device.torchMode = torchMode;
            [device unlockForConfiguration];
        }
        return error;
    }
    return nil;
}

#pragma mark - -其它事件
// 取消拍照
- (void)cancelAction:(QNDCameraView *)cameraView{
    havePhoto = NO;
    self.cameraView.rePhotoButton.hidden = !havePhoto;
    [self.cameraView.photoButton setImage:[UIImage imageNamed:@"photo_Oval"] forState:UIControlStateNormal];
    UIImageView * imageV = [self.cameraView.previewView.subviews lastObject];
    [imageV removeFromSuperview];
}

// 转换拍摄类型
-(void)didChangeTypeAction:(QNDCameraView *)cameraView type:(NSInteger)type{
    
}
// 拍照
- (void)takePhotoAction:(QNDCameraView *)cameraView{
    if (havePhoto) {
        //上传图片
        [self postTheImage:currentImage];
    }else{
        havePhoto = YES;
        //处理UI
        [self.cameraView.photoButton setImage:[UIImage imageNamed:@"photo-circle-check"] forState:UIControlStateNormal];
        self.cameraView.rePhotoButton.hidden = !havePhoto;
    }

    UIView * backView = [[UIView alloc]initWithFrame:self.view.bounds];
    backView.backgroundColor = black31TitleColor;
    [self.view addSubview:backView];
    [self.view bringSubviewToFront:backView];
    
    [UIView animateWithDuration:0.5f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        backView.alpha = 0.0;
    } completion:^(BOOL complete) {
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [backView removeFromSuperview];
        });
    }];
    [self takePictureImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 上传数据

-(void)postTheImage:(UIImage *)image{
    [[WHLoading ShareInstance]showImageHUD:self.view];
    QNDSaveHoldIdPicApi * imageApi = [[QNDSaveHoldIdPicApi alloc]initWithimage:image];
    [[WHTool shareInstance] GetDataFromApi:imageApi andCallBcak:^(NSDictionary *dic) {
        
    }];
    //向我们自己提供信息
    QNDCPLUserInfoSubmitApi * qndApi = [[QNDCPLUserInfoSubmitApi alloc]initWithModel:self.model];
    [[WHTool shareInstance] GetDataFromApi:qndApi andCallBcak:^(NSDictionary *dic) {
        [TalkingData trackEvent:@"补充信息" label:@"补充信息"];
    }];
    CPLUserInfoSubmitApi * submitApi = [[CPLUserInfoSubmitApi alloc]initWithModel:self.model];
    [submitApi startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSDictionary * sourceDic = [request responseJSONObject];
        if ([sourceDic[@"status_code"] integerValue] == 200) {
            [[WHLoading ShareInstance]hidenHud];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
        WHLog(@"%@",request.responseJSONObject);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [self.view makeToast:[request responseJSONObject][@"message"]];
        WHLog(@"%@",request.error);
    }];
}


@end
