//
//  QNDSaveHoldIdPicApi.h
//  qunadai
//
//  Created by 王浩 on 2018/1/3.
//  Copyright © 2018年 Shijiazhuang HengNi Investment Management Co., Ltd. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

@interface QNDSaveHoldIdPicApi : YTKRequest

//上传手持身份证照片
-(instancetype)initWithimage:(UIImage *)IdImage;

@end
