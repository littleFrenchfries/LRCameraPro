//
//  LRAssets.h
//  LRCameraPro
//
//  Created by wangxu on 2020/4/22.
//  Copyright © 2020 wangxu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LRAsset.h"
NS_ASSUME_NONNULL_BEGIN

@interface LRAssets : NSObject

@property (nonatomic, strong)NSMutableArray<LRAsset *> *assets;
- (NSUInteger)count;
- (void)addLRAsset:(LRAsset *)asset;
- (void)removeLRAsset:(LRAsset *)asset;
- (void)removeLastLRAsset;


@end

NS_ASSUME_NONNULL_END
