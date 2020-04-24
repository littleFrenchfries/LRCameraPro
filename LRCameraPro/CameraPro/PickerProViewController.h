//
//  PickerProViewController.h
//  LRCameraPro
//
//  Created by wangxu on 2020/4/20.
//  Copyright © 2020 wangxu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>
#import "LRAssets.h"

@protocol PickerProViewControllerDelegate <NSObject>

- (void)imagePickerController:(UIImagePickerController *_Nullable)picker didFinishPickingImages:(LRAssets *_Nullable)assets;

@end

NS_ASSUME_NONNULL_BEGIN

@interface PickerProViewController : UIViewController

@property (nonatomic, weak) id<PickerProViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
