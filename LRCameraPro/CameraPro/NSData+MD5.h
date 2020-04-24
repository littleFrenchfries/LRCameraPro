//
//  NSData+MD5.h
//  LRCameraPro
//
//  Created by wangxu on 2020/4/22.
//  Copyright © 2020 wangxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>
NS_ASSUME_NONNULL_BEGIN

@interface NSData (MD5)

- (NSString *)getMD5Data;

@end

NS_ASSUME_NONNULL_END
