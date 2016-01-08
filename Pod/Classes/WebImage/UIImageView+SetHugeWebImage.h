//
//  UIImageView+SetHugeWebImage.h
//  Kuick
//
//  Created by 鲍东升 on 15/11/26.
//  Copyright © 2015年 CCKaihui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImage+YYWebImage.h"
#import "YYWebImage.h"

@interface UIImageView (SetHugeWebImage)
- (void)kk_yysetImageWithURLStr:(NSString *)imageURLStr placeholder:(UIImage *)placeholder isYY:(BOOL)isyyLib;
- (void)kk_yysetImageWithURL:(NSString *)imageURLStr options:(YYWebImageOptions)options;
- (void)kk_yysetImageWithURL:(NSString *)imageURLStr options:(YYWebImageOptions)options placeholder:(UIImage *)placeholder;
- (void)kk_yysetImageWithURL:(NSString *)imageURLStr
                 placeholder:(UIImage *)placeholder
                     options:(YYWebImageOptions)options
                  completion:(YYWebImageCompletionBlock)completion;
- (void)kk_yysetImageWithURL:(NSString *)imageURLStr
                 placeholder:(UIImage *)placeholder
                     options:(YYWebImageOptions)options
                    progress:(YYWebImageProgressBlock)progress
                   transform:(YYWebImageTransformBlock)transform
                  completion:(YYWebImageCompletionBlock)completion;
- (void)kk_yysetImageWithURL:(NSString *)imageURLStr
                 placeholder:(UIImage *)placeholder
                     options:(YYWebImageOptions)options
                     manager:(YYWebImageManager *)manager
                    progress:(YYWebImageProgressBlock)progress
                   transform:(YYWebImageTransformBlock)transform
                  completion:(YYWebImageCompletionBlock)completion;

@end

