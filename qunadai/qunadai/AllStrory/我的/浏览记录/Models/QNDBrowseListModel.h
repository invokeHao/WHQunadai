//
//  QNDBrowseListModel.h
//  qunadai
//
//  Created by wang on 2017/9/8.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "productLoanModel.h"

@interface QNDBrowseListModel : NSObject

@property (copy,nonatomic)NSString * browsingTime;

@property (strong,nonatomic)productLoanModel * ProModel;

-(instancetype)initWithDictionary:(NSDictionary*)dic;

-(NSString*)getTheBrowsingStr;

@end
