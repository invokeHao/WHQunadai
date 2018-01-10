//
//  requirementPostApi.h
//  qunadai
//
//  Created by wang on 17/4/13.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface requirementPostApi : YTKRequest

//四要素PostApi
-(instancetype)initName:(NSString*)name andBankNum:(NSString*)num andMobileNum:(NSString*)mobile andIdNum:(NSString*)idNum;

@end
