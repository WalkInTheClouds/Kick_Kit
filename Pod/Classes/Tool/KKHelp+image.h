//
//  KKHelp+image.h
//  Kuick
//
//  Created by mengJun on 2018/4/26.
//  Copyright © 2018年 CCKaihui. All rights reserved.
//

#import "KKHelp.h"


typedef struct {
    BOOL topLeft;//!< 左上
    BOOL topRight;//!< 右上
    BOOL bottomLeft;//!< 左下
    BOOL bottomRight;//!< 右下
}KKRectCornerFlag;    //!< 矩形四边角标记.


extern KKRectCornerFlag KKRectCornerFlagMake( BOOL topLeft, BOOL topRight, BOOL bottomLeft, BOOL bottomRight);
extern BOOL KKRectCornerFlagEqualToRectCornerFlag(KKRectCornerFlag flag1, KKRectCornerFlag flag2);
extern const KKRectCornerFlag KKRectCornerFlagZero;

@interface KKHelp (image)


/**
 *  压缩图片到指定文件大小(压尺寸,如果不行,再压质量)
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size;


/**  压缩图片
 *   最大尺寸 1280 * 1280
 *
 */
+ (UIImage *)imageWithOriginalImage:(UIImage *)image;


/**
 *  将摸个View转成图片
 *
 *  @param view 目标view
 *
 *  @return 返回的图片文件
 */
+ (UIImage*) imageWithUIView:(UIView*)view;

/**
 *  将摸个View转成图片
 *
 *  @param view 目标view
 *
 *  @return 返回的图片文件
 */
+ (UIImage*)convertViewToImage:(UIView*)view;

/**
 *  把图片裁剪成圆形
 *
 *  @param image: 需要修改的图片
 *  @param inset: 内部偏移
 *
 *  @return UIImage 裁剪成的圆
 */
+ (UIImage *) circleImage:(UIImage*) image withParam:(CGFloat) inset;


/**
 *  自定义裁剪算法 px
 *
 *  @param img: 需要修改的图片
 *  @param cornerRadius: 圆角
 *  @param flag:         标记 确定哪些脚需要裁剪 默认都裁剪
 *
 *  @return UIImage 裁剪好的图
 */
+ (UIImage *)dealImage:(UIImage *)img cornerRadius:(CGFloat)c flag:(KKRectCornerFlag)flag;


/**
 *  自定义裁剪算法 pt
 *  如果是截屏出来的图片或者需要手动转成png 格式的image
 *
 *  @param img: 需要修改的图片
 *  @param cornerRtuadius: 圆角 单位是像素
 *  @param flag:         标记 确定哪些脚需要裁剪 默认都裁剪
 *
 *  @return UIImage 裁剪好的图
 */
+ (UIImage *)dealImage:(UIImage *)img cornerRadiusPt:(CGFloat)c flag:(KKRectCornerFlag)flag;

/**
 * CGContext 裁剪 pt
 *  如果是截屏出来的图片需要手动转成png 格式的image
 *
 *  @param img: 需要修改的图片
 *  @param cornerRadius: 圆角 单位是pt
 *
 *  @return UIImage 裁剪好的图
 */
+ (UIImage *)CGContextClip:(UIImage *)img cornerRadius:(CGFloat)c ;
@end
