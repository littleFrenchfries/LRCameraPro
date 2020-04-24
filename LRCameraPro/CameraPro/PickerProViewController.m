//
//  PickerProViewController.m
//  LRCameraPro
//
//  Created by wangxu on 2020/4/20.
//  Copyright © 2020 wangxu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "PickerProViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "sys/utsname.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "NSData+MD5.h"
#import "LRAssets.h"

//#define SafeAreaBottomHeight (isIPhoneX ? 34 : 0)
//#define SafeAreaTopHeight (isIPhoneX ? 24 : 0)

//适配
#define autoSizeScaleX (SHScreenW/375.0)

#define autoSizeScaleY (SHScreenH/667.0)

//屏幕宽度
#define SHScreenW [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define SHScreenH [UIScreen mainScreen].bounds.size.height

@interface PickerProViewController ()<UINavigationControllerDelegate ,UIImagePickerControllerDelegate, CLLocationManagerDelegate>

@property (nonatomic,strong ) CLLocationManager *locationManager;

@property (nonatomic, strong) UIImagePickerController *imagePickerController;

@property (nonatomic, strong) UIView *toolView;

@property (nonatomic, strong) UIView *cameraTopView;

@property (nonatomic, strong) UIView *cameraBottomView;

@property (nonatomic, strong) UIView *showPhotoView;

@property (nonatomic, strong) UIImageView *photoImage;

@property (nonatomic, strong) UIView *showPhotoBottomView;

@property (nonatomic, strong)LRAssets *assets;

@property (nonatomic, strong)CLLocation *location;

@end

@implementation PickerProViewController

- (CLLocation *)location {
    if (!_location) {
        _location = [[CLLocation alloc]init];
    }
    return _location;
}

- (void)locatemap{
    if ([CLLocationManager locationServicesEnabled]) {
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
        [_locationManager requestAlwaysAuthorization];
        [_locationManager requestWhenInUseAuthorization];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = 5.0;
        [_locationManager startUpdatingLocation];
    }
}
#pragma mark - 定位失败
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设置中打开定位" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"打开定位" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication]openURL:settingURL];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:cancel];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - 定位成功
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    [_locationManager stopUpdatingLocation];
    CLLocation *currentLocation = [locations lastObject];
    self.location = currentLocation;
//    CLGeocoder *geoCoder = [[CLGeocoder alloc]init];
//    //地理反编码 可以根据坐标(经纬度)确定位置信息(街道 门牌等)
//    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
//        if (placemarks.count >0) {
//            CLPlacemark *placeMark = placemarks[0];
//            NSLog(@"当前国家 - %@",placeMark.country);//当前国家
//            NSLog(@"当前城市 - %@",placeMark.locality);//当前城市
//            NSLog(@"当前位置 - %@",placeMark.subLocality);//当前位置
//            NSLog(@"当前街道 - %@",placeMark.thoroughfare);//当前街道
//            NSLog(@"具体地址 - %@",placeMark.name);//具体地址
//            NSLog(@" - %@",placeMark.subThoroughfare);//
//            NSLog(@" - %@",placeMark.administrativeArea);//
//            NSLog(@" - %@",placeMark.subAdministrativeArea);//
//            NSLog(@" - %@",placeMark.postalCode);//
//            NSLog(@" - %@",placeMark.ISOcountryCode);//
//            NSLog(@" - %@",placeMark.inlandWater);//
//            NSLog(@" - %@",placeMark.ocean);//
//            NSLog(@" - %@",placeMark.areasOfInterest);//
//            NSLog(@" - %@",placeMark.postalAddress);//
//            NSLog(@" - %@",placeMark.addressDictionary);//
//        }
//    }];
}


- (UIView *)showPhotoView {
    if (!_showPhotoView) {
        _showPhotoView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _showPhotoView.backgroundColor = [UIColor blackColor];
        [_showPhotoView addSubview:self.photoImage];
        [_showPhotoView addSubview:self.showPhotoBottomView];
        [NSLayoutConstraint activateConstraints:@[
            [self.showPhotoBottomView.bottomAnchor constraintEqualToAnchor:_showPhotoView.bottomAnchor constant:0],
            [self.showPhotoBottomView.leadingAnchor constraintEqualToAnchor:_showPhotoView.leadingAnchor constant:0],
            [self.showPhotoBottomView.trailingAnchor constraintEqualToAnchor:_showPhotoView.trailingAnchor constant:0],
            [self.showPhotoBottomView.heightAnchor constraintEqualToConstant:SHScreenH/6.0],
        ]];
    }
    return _showPhotoView;
}

- (UIView *)showPhotoBottomView {
    if (!_showPhotoBottomView) {
        _showPhotoBottomView = [[UIView alloc]init];
        _showPhotoBottomView.translatesAutoresizingMaskIntoConstraints = false;
        CGFloat width = 50;
        CGFloat margin = 20;
        CGFloat x = (SHScreenW - width) / 3;
        //取消
        UIButton *cancalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancalBtn.frame = CGRectMake(0, 0, x, SHScreenH/12.0);
        [cancalBtn setTitle:@"重拍" forState:UIControlStateNormal];
        [cancalBtn addTarget:self action:@selector(chongPai) forControlEvents:UIControlEventTouchUpInside];
        [_showPhotoBottomView addSubview:cancalBtn];
        
        // 完成
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(SHScreenW - 2 * margin - width*2, 0, width*2, SHScreenH/12.0);
        [doneBtn setTitle:@"使用照片" forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(shiYongZhaoPian) forControlEvents:UIControlEventTouchUpInside];
        [_showPhotoBottomView addSubview:doneBtn];
    }
    return _showPhotoBottomView;
}

- (void)chongPai {
    [self.assets removeLastLRAsset];
    self.photoImage.image = nil;
    [self.showPhotoView removeFromSuperview];
}

- (void)shiYongZhaoPian {
    self.photoImage.image = nil;
    [self.showPhotoView removeFromSuperview];
}


- (UIImageView *)photoImage {
    if (!_photoImage) {
        _photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.cameraTopHeight, SHScreenW, SHScreenW / 480 * 640)];
    }
    return _photoImage;
}

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        _imagePickerController = [[UIImagePickerController alloc]init];
        _imagePickerController.allowsEditing = NO;
        _imagePickerController.delegate = self;
        _imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
//        _imagePickerController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        _imagePickerController.showsCameraControls = NO;
        //将拍照视图向下平移100
        _imagePickerController.cameraViewTransform = CGAffineTransformMakeTranslation(0, self.cameraTopHeight);
        self.imagePickerController.cameraOverlayView = self.toolView;
    }
    return _imagePickerController;
}


- (UIView *)toolView {
    if (!_toolView) {
        _toolView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SHScreenW, SHScreenH)];
        [_toolView addSubview:self.cameraTopView];
        [_toolView addSubview:self.cameraBottomView];
        [NSLayoutConstraint activateConstraints:@[
            [self.cameraBottomView.bottomAnchor constraintEqualToAnchor:_toolView.bottomAnchor constant:0],
            [self.cameraBottomView.leadingAnchor constraintEqualToAnchor:_toolView.leadingAnchor constant:0],
            [self.cameraBottomView.trailingAnchor constraintEqualToAnchor:_toolView.trailingAnchor constant:0],
            [self.cameraBottomView.heightAnchor constraintEqualToConstant:SHScreenH/6.0],
        ]];
    }
    return _toolView;
}

- (UIView *)cameraTopView {
    if (!_cameraTopView) {
        _cameraTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SHScreenW, self.cameraTopHeight)];
        CGFloat width = 50;
        CGFloat margin = 20;
        // 头部View
        UIButton *deviceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deviceBtn setImage:[UIImage imageNamed:@"xiang.png"] forState:UIControlStateNormal];
        deviceBtn.backgroundColor = [UIColor clearColor];
        deviceBtn.frame = CGRectMake(SHScreenW - margin - width, 0, 80, self.cameraTopHeight);
        [_cameraTopView addSubview:deviceBtn];
        [deviceBtn addTarget:self action:@selector(changeCameraDevice:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *flashBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [flashBtn setImage:[UIImage imageNamed:@"shanguangdeng2.png"] forState:UIControlStateNormal];
        flashBtn.backgroundColor = [UIColor clearColor];
        flashBtn.frame = CGRectMake(10, 0, 80, self.cameraTopHeight);
        [flashBtn addTarget:self action:@selector(flashCameraDevice:) forControlEvents:UIControlEventTouchUpInside];
        [flashBtn setTitle:@"自动" forState:UIControlStateNormal];
        [_cameraTopView addSubview:flashBtn];
    }
    return _cameraTopView;
}

- (void)changeCameraDevice:(id)sender {
    if (self.imagePickerController.cameraDevice == UIImagePickerControllerCameraDeviceFront) {
        self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceRear;
    }else {
        self.imagePickerController.cameraDevice = UIImagePickerControllerCameraDeviceFront;
    }
    
}

- (void)flashCameraDevice:(UIButton *)sender  {
    if (self.imagePickerController.cameraFlashMode == UIImagePickerControllerCameraFlashModeOff) {
        self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOn;
         [sender setTitle:@"打开" forState:UIControlStateNormal];
    } else if (self.imagePickerController.cameraFlashMode == UIImagePickerControllerCameraFlashModeOn) {
        self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        [sender setTitle:@"自动" forState:UIControlStateNormal];
    }else {
        self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeOff;
        [sender setTitle:@"关闭" forState:UIControlStateNormal];
    }
    
}


- (UIView *)cameraBottomView {
    if (!_cameraBottomView) {
        _cameraBottomView = [[UIView alloc]init];
        _cameraBottomView.translatesAutoresizingMaskIntoConstraints = false;
        CGFloat width = 50;
        CGFloat margin = 20;
        CGFloat x = (SHScreenW - width) / 3;
           //取消
        UIButton *cancalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cancalBtn.frame = CGRectMake(0, 0, x, SHScreenH/12.0);
        [cancalBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancalBtn addTarget:self action:@selector(cancelCamera) forControlEvents:UIControlEventTouchUpInside];
        [_cameraBottomView addSubview:cancalBtn];
        //拍照
        UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        cameraBtn.frame = CGRectMake(x+margin, margin / 4, x, SHScreenH/12.0 - margin / 2);
        cameraBtn.showsTouchWhenHighlighted = YES;
        cameraBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [cameraBtn setImage:[UIImage imageNamed:@"paizhao.png"] forState:UIControlStateNormal];
        [cameraBtn addTarget:self action:@selector(savePhoto) forControlEvents:UIControlEventTouchUpInside];
        [_cameraBottomView addSubview:cameraBtn];
           // 完成
        UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.frame = CGRectMake(SHScreenW - 2 * margin - width, 0, width, SHScreenH/12.0);
        [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
        [_cameraBottomView addSubview:doneBtn];
    }
    return _cameraBottomView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self locatemap];
        self.modalPresentationStyle = UIModalPresentationFullScreen;
        self.imagePickerController.cameraFlashMode = UIImagePickerControllerCameraFlashModeAuto;
        self.assets = [[LRAssets alloc]init];
        [self.view addSubview:self.imagePickerController.view];
    }
    return self;
}

-(void)cancelCamera{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)savePhoto{
    [self.imagePickerController takePicture];
    [self.view addSubview:self.showPhotoView];
}

- (void)doneAction {
    if (self.delegate) {
        [self.delegate imagePickerController:self.imagePickerController didFinishPickingImages:self.assets];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}



- (CGFloat)cameraTopHeight {
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString * deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    //iPhone
    if ([deviceString isEqualToString:@"iPhone1,1"])    return 46; /*return @"iPhone 1G";*/
    if ([deviceString isEqualToString:@"iPhone1,2"])    return 46;/*return @"iPhone 3G";*/
    if ([deviceString isEqualToString:@"iPhone2,1"])    return 46;/*return @"iPhone 3GS";*/
    if ([deviceString isEqualToString:@"iPhone3,1"])    return 46;/*return @"iPhone 4";*/
    if ([deviceString isEqualToString:@"iPhone3,2"])    return 46;/*return @"Verizon iPhone 4";*/
    if ([deviceString isEqualToString:@"iPhone4,1"])    return 46;/*return @"iPhone 4S";*/
    if ([deviceString isEqualToString:@"iPhone5,1"])    return 46;/*return @"iPhone 5";*/
    if ([deviceString isEqualToString:@"iPhone5,2"])    return 46;/*return @"iPhone 5";*/
    if ([deviceString isEqualToString:@"iPhone5,3"])    return 46;/*return @"iPhone 5C";*/
    if ([deviceString isEqualToString:@"iPhone5,4"])    return 46;/*return @"iPhone 5C";*/
    if ([deviceString isEqualToString:@"iPhone6,1"])    return 46;/*return @"iPhone 5S";*/
    if ([deviceString isEqualToString:@"iPhone6,2"])    return 46;/*return @"iPhone 5S";*/
    if ([deviceString isEqualToString:@"iPhone7,1"])    return 76;/*return @"iPhone 6 Plus";*/
    if ([deviceString isEqualToString:@"iPhone7,2"])    return 46;/*return @"iPhone 6";*/
    if ([deviceString isEqualToString:@"iPhone8,1"])    return 46;/*return @"iPhone 6s";*/
    if ([deviceString isEqualToString:@"iPhone8,2"])    return 76;/*return @"iPhone 6s Plus";*/
    if ([deviceString isEqualToString:@"iPhone8,4"])    return 46;/*return @"iPhone SE";*/
    if ([deviceString isEqualToString:@"iPhone9,1"])    return 46;/*return @"iPhone 7";*/
    if ([deviceString isEqualToString:@"iPhone9,2"])    return 76;/*return @"iPhone 7 Plus";*/
    if ([deviceString isEqualToString:@"iPhone10,1"])   return 46;/*return @"iPhone 8";*/
    if ([deviceString isEqualToString:@"iPhone10,4"])   return 46;/*return @"iPhone 8";*/
    if ([deviceString isEqualToString:@"iPhone10,2"])   return 76;/*return @"iPhone 8 Plus";*/
    if ([deviceString isEqualToString:@"iPhone10,5"])   return 76;/*return @"iPhone 8 Plus";*/
    if ([deviceString isEqualToString:@"iPhone10,3"])   return 76;/*return @"iPhone X";*/
    if ([deviceString isEqualToString:@"iPhone10,6"])   return 76;/*return @"iPhone X";*/
    if ([deviceString isEqualToString:@"iPhone11,8"])   return 76;/*return @"iPhone XR";*/
    if ([deviceString isEqualToString:@"iPhone11,2"])   return 76;/*return @"iPhone XS";*/
    if ([deviceString isEqualToString:@"iPhone11,4"])   return 120;/*return @"iPhone XS Max";*/
    if ([deviceString isEqualToString:@"iPhone11,6"])   return 120;/*return @"iPhone XS Max";*/
    if ([deviceString isEqualToString:@"iPhone12,1"])   return 76;/*return @"iPhone 11";*/
    if ([deviceString isEqualToString:@"iPhone12,3"])   return 76;/*return @"iPhone 11 Pro";*/
    if ([deviceString isEqualToString:@"iPhone12,5"])   return 120;/*return @"iPhone 11 Pro Max";*/
    return 46;
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    LRAsset *lrAsset = [[LRAsset alloc]init];
    NSData *imageData = [info objectForKey:UIImagePickerControllerMediaMetadata];
    lrAsset.metaData = imageData;
    lrAsset.info = info;
    lrAsset.location = self.location;
//    if (@available(iOS 11.0, *)) {
//        PHAsset *asset = [info objectForKey:UIImagePickerControllerPHAsset];
//        CLLocation *location = asset.location;
//        lrAsset.phAsset = asset;
//        lrAsset.location = location;
//        PHImageRequestOptions *options = [[PHImageRequestOptions alloc]init];
//        options.networkAccessAllowed = YES;
//        // Mark: 允许从iCloud云中下载图片
//        [options setNetworkAccessAllowed:true];
//        [PHCachingImageManager.defaultManager requestImageForAsset:asset targetSize:self.photoImage.bounds.size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//            self.photoImage.image = result;
//        }];
//    } else {
//        NSURL*imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
//        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//        [library assetForURL:imageURL resultBlock:^(ALAsset *asset) {
//            CLLocation *location =  [asset valueForProperty:ALAssetPropertyLocation];
//            lrAsset.location = location;
//            lrAsset.alAsset = asset;
////            ALAssetRepresentation* representation = [asset defaultRepresentation];
////            self.photoImage.image = [UIImage imageWithCGImage:[asset thumbnail]];
    self.photoImage.image =  [info valueForKey:UIImagePickerControllerOriginalImage];
//            //获取资源图片的高清图
//        } failureBlock:^(NSError *error) {
//            NSLog(@"%@",error);
//        }];
//    }
    [self.assets addLRAsset:lrAsset];
    [self.view addSubview:self.showPhotoView];
}
// CGImageRef iOffscreen = CGBitmapContextCreateImage(context);
//UIImage* image = [UIImage imageWithCGImage: iOffscreen];
//UIImage转换成CGImageRef UIImage *loadImage=[UIImage imageNamed:@"comicsplash.png"];
//CGImageRef cgimage=loadImage.CGImage;
@end
