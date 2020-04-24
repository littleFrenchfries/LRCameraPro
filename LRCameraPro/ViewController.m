//
//  ViewController.m
//  LRCameraPro
//
//  Created by wangxu on 2020/4/20.
//  Copyright © 2020 wangxu. All rights reserved.
//

#import "ViewController.h"
#import "PickerProViewController.h"
@interface ViewController ()<PickerProViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
}

- (IBAction)goPicker:(id)sender {
    PickerProViewController *VC = [[PickerProViewController alloc]init];
    VC.delegate = self;
    [self presentViewController:VC  animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImages:(LRAssets *)assets {
    NSLog(@"%@",assets.assets);
}

@end
