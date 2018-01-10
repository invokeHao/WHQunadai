//
//  requirementApi.h
//  qunadai
//
//  Created by wang on 17/4/13.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface requirementApi : YTKRequest

//四要素GetApi
-(instancetype)initWithToken:(NSString*)access_token;

@end
