//
//  UserAvatarModifyApi.h
//  qunadai
//
//  Created by wang on 2017/4/19.
//  Copyright © 2017年 shanghai GeYu Info Tech Co,.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserAvatarModifyApi : QNDRequest

//修改用户头像Api
-(instancetype)initWithimage:(UIImage *)avatarImage;

@end
