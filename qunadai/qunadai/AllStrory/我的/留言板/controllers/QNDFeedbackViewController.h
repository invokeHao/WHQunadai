//
//  QNDFeedbackViewController.h
//  qunadai
//
//  Created by wang on 2017/11/8.
//  Copyright © 2017年 Xiamen Xiangzhong Yutong Financial Information Services Co.,Ltd. All rights reserved.
//

typedef enum : NSUInteger {
    QNDNomalFeedbackType,
    QNDCPLFeedbackType,
    CPLProFeedbackType
} QNDFeedbackType;

#import <UIKit/UIKit.h>


@interface QNDFeedbackViewController : UIViewController

-(instancetype)initWithFeedBackType:(QNDFeedbackType)type andProName:(NSString*)name;

@end
