//
//  KKHelp+image.m
//  Kuick
//
//  Created by mengJun on 2018/4/26.
//  Copyright © 2018年 CCKaihui. All rights reserved.
//

#import "KKHelp+image.h"

//const KKRectCornerFlag KKRectCornerFlagZero = KKRectCornerFlagMake(NO, NO, NO, NO);
 KKRectCornerFlag KKRectCornerFlagMake( BOOL topLeft, BOOL topRight, BOOL bottomLeft, BOOL bottomRight) {
    KKRectCornerFlag flag = {topLeft, topRight, bottomLeft, bottomRight};
    return flag;
}
 BOOL KKRectCornerFlagEqualToRectCornerFlag(KKRectCornerFlag flag1, KKRectCornerFlag flag2) {
    return flag1.topLeft == flag2.topLeft && flag1.topRight == flag2.topRight && flag1.bottomLeft == flag2.bottomLeft && flag1.bottomRight == flag2.bottomRight;
}
 const KKRectCornerFlag KKRectCornerFlagZero = {NO, NO, NO, NO};

@implementation KKHelp (image)

#pragma mark   -  图片
/**  压缩图片*/
+ (UIImage *)imageWithOriginalImage:(UIImage *)image{
    // 宽高比
    CGFloat ratio = image.size.width/image.size.height;
    
    // 目标大小
    CGFloat targetW = 1280;
    CGFloat targetH = 1280;
    
    // 宽高均 <= 1280，图片尺寸大小保持不变
    if (image.size.width<1280 && image.size.height<1280) {
        return image;
    }
    // 宽高均 > 1280 && 宽高比 > 2，
    else if (image.size.width>1280 && image.size.height>1280){
        
        // 宽大于高 取较小值(高)等于1280，较大值等比例压缩
        if (ratio>1) {
            targetH = 1280;
            targetW = targetH * ratio;
        }
        // 高大于宽 取较小值(宽)等于1280，较大值等比例压缩 (宽高比在0.5到2之间 )
        else{
            targetW = 1280;
            targetH = targetW / ratio;
        }
        
    }
    // 宽或高 > 1280
    else{
        // 宽图 图片尺寸大小保持不变
        if (ratio>2) {
            targetW = image.size.width;
            targetH = image.size.height;
        }
        // 长图 图片尺寸大小保持不变
        else if (ratio<0.5){
            targetW = image.size.width;
            targetH = image.size.height;
        }
        // 宽大于高 取较大值(宽)等于1280，较小值等比例压缩
        else if (ratio>1){
            targetW = 1280;
            targetH = targetW / ratio;
        }
        // 高大于宽 取较大值(高)等于1280，较小值等比例压缩
        else{
            targetH = 1280;
            targetW = targetH * ratio;
        }
    }
    // 注：这些方法是NSUtil这个工具类里的
    image = [[self alloc] imageCompressWithImage:image targetHeight:targetH targetWidth:targetW];
    
    
    return image;
}

/**  重绘*/
- (UIImage *)imageCompressWithImage:(UIImage *)sourceImage targetHeight:(CGFloat)targetHeight targetWidth:(CGFloat)targetWidth
{
    //    CGFloat targetHeight = (targetWidth / sourceImage.size.width) * sourceImage.size.height;
    UIGraphicsBeginImageContext(CGSizeMake(targetWidth, targetHeight));
    [sourceImage drawInRect:CGRectMake(0,0,targetWidth, targetHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/**  压缩图片 压缩质量 0 -- 1*/
+ (UIImage *)imageWithOriginalImage:(UIImage *)image quality:(CGFloat)quality{
    
    UIImage *newImage = [self imageWithOriginalImage:image];
    NSData *imageData = UIImageJPEGRepresentation(newImage, quality);
    return [UIImage imageWithData:imageData];
}

/**  压缩图片成Data*/
+ (NSData *)dataWithOriginalImage:(UIImage *)image{
    return UIImageJPEGRepresentation([self imageWithOriginalImage:image], 1);
}

/**
 *  压缩图片到指定文件大小
 *
 *  @param image 目标图片
 *  @param size  目标大小（最大值）
 *
 *  @return 返回的图片文件
 */
+ (NSData *)compressOriginalImage:(UIImage *)image toMaxDataSizeKBytes:(CGFloat)size{
    UIImage *new_image = [self imageWithOriginalImage:image];
    NSData * data = UIImageJPEGRepresentation(new_image, 1.0);
    CGFloat dataBytes = data.length;
    CGFloat maxQuality = 0.9f;
    CGFloat lastData = dataBytes;
    //压质量
    while (dataBytes > size && maxQuality > 0.01f) {
        maxQuality = maxQuality - 0.01f;
        data = UIImageJPEGRepresentation(image, maxQuality);
        dataBytes = data.length;
        if (lastData == dataBytes) {
            break;
        }else{
            lastData = dataBytes;
        }
    }
    if (data.length > size) {
        //压缩尺寸
        UIImage *resultImage = [UIImage imageWithData:data];
        NSData *r_data = UIImageJPEGRepresentation(resultImage, 1);
        NSUInteger lastDataLength = 0;
        NSUInteger maxLength = size;
        while (r_data.length > maxLength && r_data.length != lastDataLength) {
            lastDataLength = r_data.length;
            CGFloat ratio = (CGFloat)maxLength / r_data.length;
            CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                     (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
            UIGraphicsBeginImageContext(size);
            // Use image to draw (drawInRect:), image is larger but more compression time
            // Use result image to draw, image is smaller but less compression time
            [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
            resultImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            r_data = UIImageJPEGRepresentation(resultImage, 1);
        }
        if (r_data.length != data.length) {
            return r_data;
        }
    }
    return data;
}

/**
 *  将摸个View转成图片
 *
 *  @param view 目标view
 *
 *  @return 返回的图片文件
 */
+ (UIImage*) imageWithUIView:(UIView*) view

{
    //此方法失真,模糊
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(view.bounds.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [view.layer renderInContext:context];
    // 从当前context中创建一个改变大小后的图片
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return tImage;
    
}

+ (UIImage*)convertViewToImage:(UIView*)view{
    //完美解决失真模糊
    CGSize s = view.bounds.size;
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了
    UIGraphicsBeginImageContextWithOptions(s, NO, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage*image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



/**
 * 把图片裁剪成圆形
 * @param image: 需要修改的图片
 * @param inset: 内部偏移
 * @return UIImage 裁剪成的圆
 */
+ (UIImage *) circleImage:(UIImage*) image withParam:(CGFloat) inset {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    CGContextFillPath(context);
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}


//
/**
 * CGContext 裁剪 pt
 *
 *  @param img: 需要修改的图片
 *  @param cornerRadius: 圆角 单位是pt
 *
 *  @return UIImage 裁剪好的图
 */
+ (UIImage *)CGContextClip:(UIImage *)img cornerRadius:(CGFloat)c {
    int w = img.size.width * img.scale;
    int h = img.size.height * img.scale;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 1.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, c);
    CGContextAddArcToPoint(context, 0, 0, c, 0, c);
    CGContextAddLineToPoint(context, w-c, 0);
    CGContextAddArcToPoint(context, w, 0, w, c, c);
    CGContextAddLineToPoint(context, w, h-c);
    CGContextAddArcToPoint(context, w, h, w-c, h, c);
    CGContextAddLineToPoint(context, c, h);
    CGContextAddArcToPoint(context, 0, h, 0, h-c, c);
    CGContextAddLineToPoint(context, 0, c);
    CGContextClosePath(context);
    
    CGContextClip(context);     // 先裁剪 context，再画图，就会在裁剪后的 path 中画
    [img drawInRect:CGRectMake(0, 0, w, h)];       // 画图
    CGContextDrawPath(context, kCGPathFill);
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return ret;
}

/**
 *  自定义裁剪算法 pt
 *
 *  @param img: 需要修改的图片
 *  @param cornerRadius: 圆角 单位是pt
 *  @param flag:         标记 确定哪些脚需要裁剪 默认都裁剪
 *
 *  @return UIImage 裁剪好的图
 */
+ (UIImage *)dealImage:(UIImage *)img cornerRadiusPt:(CGFloat)c flag:(KKRectCornerFlag)flag{
    CGFloat px = c * [UIScreen mainScreen].scale;
    img = [UIImage imageWithData:UIImagePNGRepresentation(img)];
    return  [self dealImage:img cornerRadius:px flag:flag];
}


/**
 *  自定义裁剪算法 px
 *
 *  @param img: 需要修改的图片
 *  @param cornerRadius: 圆角 单位是像素
 *  @param flag:         标记 确定哪些脚需要裁剪 默认都裁剪
 *
 *  @return UIImage 裁剪好的图
 */
+ (UIImage *)dealImage:(UIImage *)img cornerRadius:(CGFloat)c flag:(KKRectCornerFlag)flag{
    // 1.CGDataProviderRef 把 CGImage 转 二进制流
    CGDataProviderRef provider = CGImageGetDataProvider(img.CGImage);
    void *imgData = (void *)CFDataGetBytePtr(CGDataProviderCopyData(provider));
    int width = img.size.width * img.scale;
    int height = img.size.height * img.scale;
    
    // 2.处理 imgData
    //    dealImage(imgData, width, height);
    if (KKRectCornerFlagEqualToRectCornerFlag(KKRectCornerFlagZero, flag)) {
        flag = KKRectCornerFlagMake(YES, YES, YES, YES);
    }
    cornerImage(imgData, width, height, c,flag);
    
    // 3.CGDataProviderRef 把 二进制流 转 CGImage
    CGDataProviderRef pv = CGDataProviderCreateWithData(NULL, imgData, width * height * 4, releaseData);
    CGImageRef content = CGImageCreate(width , height, 8, 32, 4 * width, CGColorSpaceCreateDeviceRGB(), kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast, pv, NULL, true, kCGRenderingIntentDefault);
    UIImage *result = [UIImage imageWithCGImage:content];
    CGDataProviderRelease(pv);      // 释放空间
    CGImageRelease(content);
    
    return result;
}

void releaseData(void *info, const void *data, size_t size) {
    free((void *)data);
}

// 裁剪圆角
void cornerImage(UInt32 *const img, int w, int h, CGFloat cornerRadius,KKRectCornerFlag flag) {
    CGFloat c = cornerRadius;
    CGFloat min = w > h ? h : w;
    
    if (c < 0) { c = 0; }
    if (c > min * 0.5) { c = min * 0.5; }
    
    // 左上 y:[0, c), x:[x, c-y)
    if (flag.topLeft) {
        for (int y=0; y<c; y++) {
            for (int x=0; x<c-y; x++) {
                UInt32 *p = img + y * w + x;    // p 32位指针，RGBA排列，各8位
                if (isCircle(c, c, c, x, y) == false) {
                    *p = 0;
                }
            }
        }
    }
   
    // 右上 y:[0, c), x:[w-c+y, w)
    int tmp = w-c;
    if (flag.topRight) {
        for (int y=0; y<c; y++) {
            for (int x=tmp+y; x<w; x++) {
                UInt32 *p = img + y * w + x;
                if (isCircle(w-c, c, c, x, y) == false) {
                    *p = 0;
                }
            }
        }
    }
   
    // 左下 y:[h-c, h), x:[0, y-h+c)
    if (flag.bottomLeft) {
        tmp = h-c;
        for (int y=h-c; y<h; y++) {
            for (int x=0; x<y-tmp; x++) {
                UInt32 *p = img + y * w + x;
                if (isCircle(c, h-c, c, x, y) == false) {
                    *p = 0;
                }
            }
        }
    }
   
    // 右下 y~[h-c, h), x~[w-c+h-y, w)
    if (flag.bottomRight) {
        tmp = w-c+h;
        for (int y=h-c; y<h; y++) {
            for (int x=tmp-y; x<w; x++) {
                UInt32 *p = img + y * w + x;
                if (isCircle(w-c, h-c, c, x, y) == false) {
                    *p = 0;
                }
            }
        }
    }
}


// 判断点 (px, py) 在不在圆心 (cx, cy) 半径 r 的圆内
static inline bool isCircle(float cx, float cy, float r, float px, float py) {
    if ((px-cx) * (px-cx) + (py-cy) * (py-cy) > r * r) {
        return false;
    }
    return true;
}



// 以图片中心为中心，以最小边为边长，裁剪正方形图片
+(UIImage *)cropSquareImage:(UIImage *)image size:(CGSize)size{
    
    CGImageRef sourceImageRef = [image CGImage];//将UIImage转换成CGImageRef
    CGFloat _imageWidth = image.size.width * image.scale;
    CGFloat _imageHeight = image.size.height * image.scale;
    CGFloat _width = _imageWidth > _imageHeight ? _imageHeight : _imageWidth;
    CGFloat _offsetX = (_imageWidth - _width) / 2;
    CGFloat _offsetY = (_imageHeight - _width) / 2;
    CGRect rect = CGRectMake(_offsetX, _offsetY, _width, _width);
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);//按照给定的矩形区域进行剪裁
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    return newImage;
}




@end
