//
//  LRAsset.h
//  LRCameraPro
//
//  Created by wangxu on 2020/4/22.
//  Copyright © 2020 wangxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
NS_ASSUME_NONNULL_BEGIN

@interface LRAsset : NSObject

@property (nonatomic, strong)NSDictionary *info;

@property (nonatomic, strong) NSData *metaData;

@property (nonatomic, strong) CLLocation *location;

@end

NS_ASSUME_NONNULL_END
