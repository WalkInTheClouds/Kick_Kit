//
//  UIImageView+SetHugeWebImage.m
//  Kuick
//
//  Created by 鲍东升 on 15/11/26.
//  Copyright © 2015年 CCKaihui. All rights reserved.
//

#import "UIImageView+SetHugeWebImage.h"
#import "UIImageView+SetHugeWebImage.h"
#import "UIImageView+WebCache.h"

@implementation UIImageView (SetHugeWebImage)

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder The image to be set initially, until the image request finishes.
 */
- (void)kk_yysetImageWithURLStr:(NSString *)imageURLStr placeholder:(UIImage *)placeholder isYY:(BOOL)isyyLib
{
    if (isyyLib) {
        [self yy_setImageWithURL:[NSURL URLWithString:[self getUtf8Str:imageURLStr]] placeholder:placeholder];
    }else{
        [self sd_setImageWithURL:[NSURL URLWithString:[self getUtf8Str:imageURLStr]] placeholderImage:placeholder];
    }
//    [self sd_setImageWithURL:[NSURL URLWithString:imageURLStr] placeholderImage:placeholder];
    
}

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL The image url (remote or local file path).
 @param options  The options to use when request the image.
 */
- (void)kk_yysetImageWithURL:(NSString *)imageURLStr options:(YYWebImageOptions)options{
    [self yy_setImageWithURL:[NSURL URLWithString:[self getUtf8Str:imageURLStr]] options:options];
}

- (void)kk_yysetImageWithURL:(NSString *)imageURLStr options:(YYWebImageOptions)options placeholder:(UIImage *)placeholder{
    [self yy_setImageWithURL:[NSURL URLWithString:[self getUtf8Str:imageURLStr]] placeholder:placeholder options:options completion:^(UIImage *image, NSURL *url, YYWebImageFromType from, YYWebImageStage stage, NSError *error) {
        
    }];
}

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder The image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)kk_yysetImageWithURL:(NSString *)imageURLStr
               placeholder:(UIImage *)placeholder
                   options:(YYWebImageOptions)options
                completion:(YYWebImageCompletionBlock)completion
{
    [self yy_setImageWithURL:[NSURL URLWithString:[self getUtf8Str:imageURLStr]] placeholder:placeholder options:options completion:completion];
}

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder The image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param progress    The block invoked (on main thread) during image request.
 @param transform   The block invoked (on background thread) to do additional image process.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)kk_yysetImageWithURL:(NSString *)imageURLStr
               placeholder:(UIImage *)placeholder
                   options:(YYWebImageOptions)options
                  progress:(YYWebImageProgressBlock)progress
                 transform:(YYWebImageTransformBlock)transform
                completion:(YYWebImageCompletionBlock)completion
{
    NSURL *url = [NSURL URLWithString:[self getUtf8Str:imageURLStr]];
    [self yy_setImageWithURL: url placeholder:placeholder options:options progress:progress transform:transform completion:completion];
    
//    [self yy_setImageWithURL:[NSURL URLWithString:imageURLStr] placeholder:placeholder options:options progress:progress transform:transform completion:completion];
}

/**
 Set the view's `image` with a specified URL.
 
 @param imageURL    The image url (remote or local file path).
 @param placeholder he image to be set initially, until the image request finishes.
 @param options     The options to use when request the image.
 @param manager     The manager to create image request operation.
 @param progress    The block invoked (on main thread) during image request.
 @param transform   The block invoked (on background thread) to do additional image process.
 @param completion  The block invoked (on main thread) when image request completed.
 */
- (void)kk_yysetImageWithURL:(NSString *)imageURLStr
               placeholder:(UIImage *)placeholder
                   options:(YYWebImageOptions)options
                   manager:(YYWebImageManager *)manager
                  progress:(YYWebImageProgressBlock)progress
                 transform:(YYWebImageTransformBlock)transform
                completion:(YYWebImageCompletionBlock)completion
{
    [self yy_setImageWithURL:[NSURL URLWithString:[self getUtf8Str:imageURLStr]] placeholder:placeholder options:options manager:manager progress:progress transform:transform completion:completion];
}

/**
 Cancel the current image request.
 */



- (NSURL *)getTrueURL:(NSURL *)url
{
    NSString * urlString = [url.absoluteString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    url = [NSURL URLWithString:urlString];
    return url;
}

- (NSString *)getUtf8Str:(NSString*)str
{
    NSString * urlString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return urlString;
}



/*** ---------------------------------------------------------------------------------------------------------------*/

@end
