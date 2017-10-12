//
//  ViewController.m
//  压缩图片
//
//  Created by 王永顺 on 2017/9/12.
//  Copyright © 2017年 EasonWang. All rights reserved.
//

#import "ViewController.h"
#import  <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>
#import "RedrawImage.h"

/**
 *  主屏的宽
 */
#define DEF_SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

/**
 *  主屏的高
 */
#define DEF_SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic) UIImageView *logoImage;
@property (nonatomic) RedrawImage *redrawAction;
@end

@implementation ViewController

-(RedrawImage *)redrawAction {
    
    if (!_redrawAction) {
        _redrawAction = [RedrawImage new];
    }
    return _redrawAction;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(50, 50, DEF_SCREEN_WIDTH-100, DEF_SCREEN_WIDTH-100)];
    [self.view addSubview:self.logoImage];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(cameraClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"选择图片" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(50, DEF_SCREEN_WIDTH-50, DEF_SCREEN_WIDTH-100, 50);
    [self.view addSubview:btn];
}

- (void)cameraClick:(UIButton *)button{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *library = [UIAlertAction actionWithTitle:@"从手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"从手机相册选择");
        
        [self choseAction:502];
        
    }];
    UIAlertAction *picture = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"拍照");
        
        [self choseAction:501];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        NSLog(@"取消");
    }];
    
    [alert addAction:library];
    [alert addAction:picture];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)choseAction:(NSInteger)tag {
    
    UIImagePickerController * imagePickerController= [[UIImagePickerController alloc]init];
    imagePickerController.delegate = self;
    
    if (tag == 501) {
        
        if (![self isCamera]) {
            return ;
        }
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;//相机
            imagePickerController.allowsEditing=YES;
            [self presentViewController:imagePickerController animated:YES completion:^{}];
        }else{
            NSLog(@"当前设备相机不可用");
        }
    }else{
        if (![self isPhotoAlbum]) {
            return;
        }
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing=YES;
        [self presentViewController:imagePickerController animated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *img=info[UIImagePickerControllerEditedImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self.redrawAction compressedImageFiles:img imageKB:100 imageBlock:^(UIImage *image) {
        
        [self.logoImage setImage:image];
    }];
}


-(BOOL)isCamera{
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus ==AVAuthorizationStatusDenied)
    {
        //无权限
        return NO;
    }
    return YES;
}

-(BOOL)isPhotoAlbum{
    
    //如果没有权限有可能引起crash，所以先判断是否有权限
    ALAuthorizationStatus author = [ALAssetsLibrary authorizationStatus];
    if (author == ALAuthorizationStatusRestricted || author ==ALAuthorizationStatusDenied){
        //无权限
//        [MbprogressTool standardShowMessage:@"此应用没有相册权限，请在\"隐私设置中\"中启用访问"];
        return NO;
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
