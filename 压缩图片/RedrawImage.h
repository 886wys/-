//
//  RedrawImage.h
//  压缩图片
//
//  Created by 王永顺 on 2017/9/12.
//  Copyright © 2017年 EasonWang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface RedrawImage : NSObject

/**
 *  压缩图片
 *
 *  @param image       需要压缩的图片
 *  @param fImageKBytes 希望压缩后的大小(以KB为单位)
 *
 *  @block 压缩后的图片
 */
- (void)compressedImageFiles:(UIImage *)image
                     imageKB:(CGFloat)fImageKBytes
                  imageBlock:(void(^)(UIImage *image))block;


/* 根据 dWidth dHeight 返回一个新的image**/
- (UIImage *)drawWithWithImage:(UIImage *)imageCope width:(CGFloat)dWidth height:(CGFloat)dHeight;

@end
