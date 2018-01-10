//
//  QNDCameraView.m
//  qunadai
//
//  Created by 王浩 on 2017/12/26.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import "QNDCameraView.h"
@interface QNDCameraView()
@property(nonatomic, strong) UIView *topView;      // 上面的bar
@property(nonatomic, strong) UIView *bottomView;   // 下面的bar
@property(nonatomic, strong) UIView *focusView;    // 聚焦动画view
@property(nonatomic, strong) UIView *exposureView; // 曝光动画view
@property(nonatomic, strong) QNDVideoPreview *previewView;

@property(nonatomic, strong) UIButton *torchBtn; //手电筒
@property(nonatomic, strong) UIButton *flashBtn; //闪光灯

@end

@implementation QNDCameraView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

-(UIView *)topView{
    if (_topView == nil) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, 44)];
        _topView.backgroundColor = [UIColor whiteColor];
    }
    return _topView;
}

-(UIView *)bottomView{
    if (_bottomView == nil) {
        _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height-100, self.width, 100)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

-(UIView *)focusView{
    if (_focusView == nil) {
        _focusView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 80.0f)];
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.layer.borderColor = defultYellowlabelColor.CGColor;
        _focusView.layer.borderWidth = 1.0f;
        _focusView.hidden = YES;
    }
    return _focusView;
}

-(UIView *)exposureView{
    if (_exposureView == nil) {
        _exposureView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 80.0f, 80.0f)];
        _exposureView.backgroundColor = [UIColor clearColor];
        _exposureView.layer.borderColor = defultYellowlabelColor.CGColor;
        _exposureView.layer.borderWidth = 1.0f;
        _exposureView.hidden = YES;
    }
    return _exposureView;
}

-(void)setupUI{
    self.previewView = [[QNDVideoPreview alloc]initWithFrame:CGRectMake(0, 64, self.width, self.height-64-100)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.previewView addGestureRecognizer:tap];
    [self.previewView addGestureRecognizer:doubleTap];
    [tap requireGestureRecognizerToFail:doubleTap];
    
    [self addSubview:self.previewView];
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    [self.previewView addSubview:self.focusView];
    [self.previewView addSubview:self.exposureView];
    
    // 拍照
    UIButton*photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [photoButton setImage:[UIImage imageNamed:@"photo_Oval"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
    [photoButton setBounds:CGRectMake(0, 0, 66, 66)];
    photoButton.center = CGPointMake(ViewWidth/2, _bottomView.height/2);
    [self.bottomView addSubview:photoButton];
    _photoButton = photoButton;
    
    // 取消
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:[UIImage imageNamed:@"photo_back"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBounds:CGRectMake(0, 0, 30, 30)];
    [cancelButton setContentMode:UIViewContentModeScaleAspectFit];
    cancelButton.center = CGPointMake(35, _bottomView.height/2);
    cancelButton.hidden = YES;
    _rePhotoButton = cancelButton;
    [self.bottomView addSubview:cancelButton];
    
    // 转换前后摄像头
    UIButton *switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [switchCameraButton setImage:[UIImage imageNamed:@"photo_icon_circulation"] forState:UIControlStateNormal];
    [switchCameraButton addTarget:self action:@selector(switchCameraClick:) forControlEvents:UIControlEventTouchUpInside];
    [switchCameraButton setFrame:CGRectMake(ViewWidth-32, 11+20, 22, 22)];
    [switchCameraButton setContentMode:UIViewContentModeScaleAspectFit];
    [self.topView addSubview:switchCameraButton];
    
    UILabel * tipsLabel = [[UILabel alloc]init];
    tipsLabel.font = QNDFont(12.0);
    tipsLabel.textColor = ThemeColor;
    tipsLabel.text = @"请切换至前置摄像头，手持身份证后拍摄照片上传。";
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [tipsLabel sizeToFit];
    tipsLabel.center = CGPointMake(ViewWidth/2, 22+20);
    [self.topView addSubview:tipsLabel];
//
//    // 补光
//    UIButton *lightButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [lightButton setTitle:@"补光" forState:UIControlStateNormal];
//    [lightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [lightButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
//    [lightButton addTarget:self action:@selector(torchClick:) forControlEvents:UIControlEventTouchUpInside];
//    [lightButton sizeToFit];
//    lightButton.center = CGPointMake(lightButton.width/2 + switchCameraButton.width+10, _topView.height/2);
//    [self.topView addSubview:lightButton];
//    _torchBtn = lightButton;
//    
//    // 闪光灯
//    UIButton *flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [flashButton setTitle:@"闪光灯" forState:UIControlStateNormal];
//    [flashButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [flashButton setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
//    [flashButton addTarget:self action:@selector(flashClick:) forControlEvents:UIControlEventTouchUpInside];
//    [flashButton sizeToFit];
//    flashButton.center = CGPointMake(flashButton.width/2 + lightButton.width+10, _topView.height/2);
//    [self.topView addSubview:flashButton];
//    _flashBtn = flashButton;
//    
//    // 重置对焦、曝光
//    UIButton *focusAndExposureButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [focusAndExposureButton setTitle:@"自动聚焦/曝光" forState:UIControlStateNormal];
//    [focusAndExposureButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [focusAndExposureButton addTarget:self action:@selector(focusAndExposureClick:) forControlEvents:UIControlEventTouchUpInside];
//    [focusAndExposureButton sizeToFit];
//    focusAndExposureButton.center = CGPointMake(focusAndExposureButton.width/2 + flashButton.width+10, _topView.height/2);
//    [self.topView addSubview:focusAndExposureButton];
}

-(void)changeTorch:(BOOL)on{
    _torchBtn.selected = on;
}

-(void)changeFlash:(BOOL)on{
    _flashBtn.selected = on;
}

// 聚焦
-(void)tapAction:(UIGestureRecognizer *)tap{
    if ([_delegate respondsToSelector:@selector(focusAction:point:succ:fail:)]) {
        CGPoint point = [tap locationInView:self.previewView];
        [self runFocusAnimation:self.focusView point:point];
        [_delegate focusAction:self point:[self.previewView captureDevicePointForPoint:point] succ:nil fail:^(NSError *error) {
            [[WHTool shareInstance] showALterViewWithOneButton:@"确定" andMessage:error.description];
        }];
    }
}

// 曝光
-(void)doubleTapAction:(UIGestureRecognizer *)tap{
    if ([_delegate respondsToSelector:@selector(exposAction:point:succ:fail:)]) {
        CGPoint point = [tap locationInView:self.previewView];
        [self runFocusAnimation:self.exposureView point:point];
        [_delegate exposAction:self point:[self.previewView captureDevicePointForPoint:point] succ:nil fail:^(NSError *error) {
            [[WHTool shareInstance] showALterViewWithOneButton:@"确定" andMessage:error.description];
        }];
    }
}

// 拍照
-(void)takePicture:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(takePhotoAction:)]) {
        [_delegate takePhotoAction:self];
    }
}

// 取消
-(void)cancel:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(cancelAction:)]) {
        [_delegate cancelAction:self];
    }
}
// 转换前后摄像头
-(void)switchCameraClick:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(swicthCameraAction:succ:fail:)]) {
        [_delegate swicthCameraAction:self succ:nil fail:^(NSError *error) {
            [[WHTool shareInstance] showALterViewWithOneButton:@"确定" andMessage:error.description];
        }];
    }
}

// 手电筒
-(void)torchClick:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(torchLightAction:succ:fail:)]) {
        [_delegate torchLightAction:self succ:^{
            _flashBtn.selected = NO;
            _torchBtn.selected = !_torchBtn.selected;
        } fail:^(NSError *error) {
            [[WHTool shareInstance] showALterViewWithOneButton:@"确定" andMessage:error.description];
        }];
    }
}

// 闪光灯
-(void)flashClick:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(flashLightAction:succ:fail:)]) {
        [_delegate flashLightAction:self succ:^{
            _flashBtn.selected = !_flashBtn.selected;
            _torchBtn.selected = NO;
        } fail:^(NSError *error) {
            [[WHTool shareInstance] showALterViewWithOneButton:@"确定" andMessage:error.description];
        }];
    }
}

// 自动聚焦和曝光
-(void)focusAndExposureClick:(UIButton *)btn{
    if ([_delegate respondsToSelector:@selector(autoFocusAndExposureAction:succ:fail:)]) {
        [_delegate autoFocusAndExposureAction:self succ:^{
            [self makeCenterToast:@"自动聚焦曝光设置成功"];
        } fail:^(NSError *error) {
            [[WHTool shareInstance] showALterViewWithOneButton:@"确定" andMessage:error.description];
        }];
    }
}

#pragma mark - Private methods
// 聚焦、曝光动画
-(void)runFocusAnimation:(UIView *)view point:(CGPoint)point{
    view.center = point;
    view.hidden = NO;
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        view.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
    } completion:^(BOOL complete) {
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            view.hidden = YES;
            view.transform = CGAffineTransformIdentity;
        });
    }];
}

// 自动聚焦、曝光动画
- (void)runResetAnimation {
    self.focusView.center = CGPointMake(self.previewView.width/2, self.previewView.height/2);
    self.exposureView.center = CGPointMake(self.previewView.width/2, self.previewView.height/2);;
    self.exposureView.transform = CGAffineTransformMakeScale(1.2f, 1.2f);
    self.focusView.hidden = NO;
    self.focusView.hidden = NO;
    [UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.focusView.layer.transform = CATransform3DMakeScale(0.5, 0.5, 1.0);
        self.exposureView.layer.transform = CATransform3DMakeScale(0.7, 0.7, 1.0);
    } completion:^(BOOL complete) {
        double delayInSeconds = 0.5f;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            self.focusView.hidden = YES;
            self.exposureView.hidden = YES;
            self.focusView.transform = CGAffineTransformIdentity;
            self.exposureView.transform = CGAffineTransformIdentity;
        });
    }];
}

@end
