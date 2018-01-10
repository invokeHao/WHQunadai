//
//  QNDCameraView.h
//  qunadai
//
//  Created by 王浩 on 2017/12/26.
//  Copyright © 2017年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QNDVideoPreview.h"

@class QNDCameraView;
@protocol QNDCameraViewDelegate <NSObject>
@optional;

/// 转换摄像头
-(void)swicthCameraAction:(QNDCameraView *)cameraView succ:(void(^)(void))succ fail:(void(^)(NSError *error))fail;
/// 闪光灯
-(void)flashLightAction:(QNDCameraView *)cameraView succ:(void(^)(void))succ fail:(void(^)(NSError *error))fail;
/// 补光
-(void)torchLightAction:(QNDCameraView *)cameraView succ:(void(^)(void))succ fail:(void(^)(NSError *error))fail;
/// 聚焦
-(void)focusAction:(QNDCameraView *)cameraView point:(CGPoint)point succ:(void(^)(void))succ fail:(void(^)(NSError *error))fail;
/// 曝光
-(void)exposAction:(QNDCameraView *)cameraView point:(CGPoint)point succ:(void(^)(void))succ fail:(void(^)(NSError *error))fail;
/// 自动聚焦曝光
-(void)autoFocusAndExposureAction:(QNDCameraView *)cameraView succ:(void(^)(void))succ fail:(void(^)(NSError *error))fail;

/// 取消
-(void)cancelAction:(QNDCameraView *)cameraView;
/// 拍照
-(void)takePhotoAction:(QNDCameraView *)cameraView;

@end

@interface QNDCameraView : UIView

@property(nonatomic, weak) id <QNDCameraViewDelegate> delegate;

@property(nonatomic, strong, readonly) QNDVideoPreview *previewView;

@property (nonatomic,strong) UIButton *photoButton; //拍照按钮

@property (nonatomic,strong) UIButton * rePhotoButton;//重拍按钮

-(void)changeTorch:(BOOL)on;

-(void)changeFlash:(BOOL)on;

@end
