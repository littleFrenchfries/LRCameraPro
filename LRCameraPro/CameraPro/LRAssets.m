//
//  LRAssets.m
//  LRCameraPro
//
//  Created by wangxu on 2020/4/22.
//  Copyright © 2020 wangxu. All rights reserved.
//

#import "LRAssets.h"

@implementation LRAssets

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.assets = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)addLRAsset:(LRAsset *)asset {
    [self.assets addObject:asset];
}

- (void)removeLRAsset:(LRAsset *)asset {
    [self.assets removeObject:asset];
}

- (NSUInteger)count {
   return self.assets.count;
}

- (void)removeLastLRAsset {
    [self.assets removeLastObject];
}

@end
