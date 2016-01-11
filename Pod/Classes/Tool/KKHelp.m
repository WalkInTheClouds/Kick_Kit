//
//  KKHelp.m
//  Kuick
//
//  Created by laoJun on 15/8/5.
//  Copyright (c) 2015年 CCKaihui. All rights reserved.
//

#import "KKHelp.h"
#import "AFNetworking.h"



@implementation KKHelp

///把数组的第一个元素 移动到最后一个
+ (void)moveObjectToLastIndex:(NSMutableArray *)array
{
    id object = array[0];
    [array removeObject:object];
    [array addObject:object];
}
///把一段时间转换成 00:00:00 格式的 字符串
+ (NSString *)getTimeStringWithTimeInterval:(NSInteger)time
{
    
    NSInteger ss = time%60;
    NSInteger mm = (time /60)%60;
    NSInteger hh = time/3600;
    NSString *string = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",(long)hh,(long)mm,(long)ss];
    return string;
}

///把网络上的图片按照一定的尺寸进行裁剪;
/*
 * @param urlStirng url 地址;
 * @param width 图片宽;
 * @param hight 图片长;
 */
+ (NSString *)getClipWebImageURLWithUrlString:(NSString *)urlStirng width:(NSInteger)width hight:(NSInteger)hight
{
    //最终请求单个参数不能大于4000
    CGFloat maxSize = 4000;
    if (hight *[UIScreen mainScreen].scale < maxSize && width *[UIScreen mainScreen].scale < 4000)
    {
        hight = hight *[UIScreen mainScreen].scale;
        width = width *[UIScreen mainScreen].scale;
    }
    NSString *imageType = [[urlStirng componentsSeparatedByString:@"."] lastObject];
    NSString *string = [NSString stringWithFormat:@"%@@1e_%dw_%dh_1c_0i_1o_1x.%@",urlStirng,(int)width,(int)hight,imageType];
//    NSURL *url =  [NSURL URLWithString:string];
//    NSLog(@"--=========$&$@$#$**********************************-%s--%@",__FUNCTION__,urlStirng);
//    NSLog(@"--=========$&$@$#$**********************************-%s--%@",__FUNCTION__,url);
    return string;
}
///把网络上的图片某一边（宽或高）进行固定到一个长度，另外一边按照比例进行调整。
/*
 * @param urlStirng url 地址;
 * @param width 图片宽;
 */
+ (NSString *)getClipWebImageURLWithUrlString:(NSString *)urlStirng width:(NSInteger)width
{
    width = width *[UIScreen mainScreen].scale;
   
    NSString *string = [NSString stringWithFormat:@"%@@%dw",urlStirng,(int)width];
//    NSURL *url =  [NSURL URLWithString:string];
   
    return string;
}
+ (void)getImageInfoWithUrlString:(NSString *)urlString succeedBlock: (I_succeedBlock)success failBlock:(I_failBlock)failed
{
    NSString *url = [NSString stringWithFormat:@"%@@infoexif",urlString];
    url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [[AFHTTPRequestOperationManager manager] GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject)
    {
        if (!operation.responseString)
        {
            //使用gbk编码
            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *dataString = [[NSString alloc]initWithData:operation.responseData encoding:enc];
            NSLog(@"-------%s---%@",__FUNCTION__,dataString);
            NSError *error = nil;
            responseObject = [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
            NSLog(@"-----%@",error);
        }
      
      
        ImageInfoModel *model = [[ImageInfoModel alloc]initWithDictionary:responseObject error:nil];
        success(model);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        failed(error);
    }];
}
/*         
 * @param string 被计算字符串;
 * @param font 字体;
 * @param height 限定高度;
 */
///得到一行字体的长度
+ (CGFloat)getStringWidthWihtString:(NSString *)string
                               font:(UIFont *)font
                              height:(CGFloat)height
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, height) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font}  context:nil];
    
    return ceilf(rect.size.width);
   
}

/*
 * @param string 被计算字符串;
 * @param font 字体;
 * @param width 限定长度;
 */
///得到一行字体的高度
+ (CGFloat)getStringHeightWihtString:(NSString *)string
                                font:(UIFont *)font
                              width:(CGFloat)width
{
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 0) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:font}  context:nil];
    
    return ceilf(rect.size.height);
    
}
/*
 * @param mobileNum 电话号码;
 */
/// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189
     22         */
    NSString * CT = @"^1((33|53|8[09])[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum])
        || ([regextestcm evaluateWithObject:mobileNum])
        || ([regextestct evaluateWithObject:mobileNum])
        || ([regextestcu evaluateWithObject:mobileNum]))
    {
        if([regextestcm evaluateWithObject:mobileNum]) {
            NSLog(@"China Mobile");
        } else if([regextestct evaluateWithObject:mobileNum]) {
            NSLog(@"China Telecom");
        } else if ([regextestcu evaluateWithObject:mobileNum]) {
            NSLog(@"China Unicom");
        } else {
            NSLog(@"Unknow");
        }
        
        return YES;
    }
    else
    {
        return NO;
    }
}


///验证6位号码
+ (BOOL)isValidateTelNumber:(NSString *)number
{
    
    NSString *strRegex = @"[0-9]{6,6}";
    
    NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strRegex];
    BOOL rt = [regextest evaluateWithObject:number];
    
    return rt;
    
}

//验证email
+ (BOOL)isValidateEmail:(NSString *)email {
    //jfkjkfj  @  ddvv  . com
    NSString *strRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{1,5}";
    BOOL rt = [self isValidateRegularExpression:email byExpression:strRegex];
    
    return rt;
}
#pragma mark 是否是纯数字
+ (BOOL)isValidateNumber:(NSString *)string
{
    NSCharacterSet *numberSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    NSCharacterSet *mStrSet = [NSCharacterSet characterSetWithCharactersInString:string];
    if ([numberSet isSupersetOfSet:mStrSet])
    {
        return YES;
    }else
    {
        return NO;
    }
}
#pragma mark 字符串是否为空(包括空格)
+(BOOL)isEmpty:(NSString *)str
{
 
    if (!str)
    {
        return YES;
    } else
    {
    
        //A character set containing only the whitespace characters space (U+0020) and tab (U+0009) and the newline and nextline characters (U+000A–U+000D, U+0085).
        NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
        
        //Returns a new string made by removing from both ends of the receiver characters contained in a given character set.
        NSString *trimedString = [str stringByTrimmingCharactersInSet:set];
        
        if ([trimedString length] == 0) {
            return YES;
        } else {
            return NO;
        }
    }
}
//是否是有效的正则表达式

+ (BOOL)isValidateRegularExpression:(NSString *)strDestination byExpression:(NSString *)strExpression{
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", strExpression];
    
    return [predicate evaluateWithObject:strDestination];
}
///得到边帽拉伸的图
+ (UIImage *)getStretchableImage:(UIImage *)image
{
    NSInteger leftCapWidth = image.size.width * 0.5f;
    NSInteger topCapHeight = image.size.height * 0.5f;
    image= [image stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
    return image;
}
//获得屏幕图像
+ (UIImage *)getScreenshotImage
{
    
    UIWindow *screenWindow = [[UIApplication sharedApplication] keyWindow];
    
    UIGraphicsBeginImageContext(screenWindow.frame.size);
    [screenWindow.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return screenshot;
}
//得到纯数字
+ (NSString *)trimString:(NSString *)string isPhoneNumber:(BOOL)isPhone
{
    NSMutableString *mStr = [NSMutableString stringWithString:string];
    NSCharacterSet *numberSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    for (int i = 0; i<mStr.length; i++)
    {
        //substringWithRange截取字符串的某一部分，NSRange,从第几位截取，截多少位
        NSString *cha = [mStr substringWithRange:NSMakeRange(i, 1)];
        if ([numberSet isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString:cha]])
        {
            //是数字
        }else
        {
            //不是数字
            [mStr deleteCharactersInRange:NSMakeRange(i, 1)];
            i--;
        }
    }
    NSString *numberString = [NSString stringWithString:mStr];
    //去除手机号码的区号
    if (isPhone)
    {
        if ([numberString hasPrefix:@"86"])
        {
            numberString = [numberString substringWithRange:NSMakeRange(2, numberString.length-2)];
        }
    }
    return numberString;
}

+ (NSString *)getString:(id)object
{
    if ([object isKindOfClass:[NSString class]])
    {
        return object;
    }else if ([object isKindOfClass:[NSNumber class]])
    {
        NSInteger num = [object integerValue];
        return [NSString stringWithFormat:@"%ld",(long)num];
    }else
    {
        return [NSString stringWithFormat:@"%@",object];
    }
    
}

#pragma mark --- 图片的修正
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
            
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark 去除多余的分割线
+ (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma mark 获取当前VC
+ (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}
#pragma mark 获取当前弹出vc
+ (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [[UIApplication sharedApplication].delegate window] .rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

#pragma mark : - 获取资源辅助方法

+ (NSString*)getResourcePathByBundleName: (NSString *)bundleName andResouceName: (NSString *)resourceName andType:(NSString*)type{
    NSString *pathString =[[ NSBundle   mainBundle ]. resourcePath   stringByAppendingPathComponent : @"Frameworks" ];
    pathString = [pathString stringByAppendingPathComponent:@"KuickDeal.framework"];
    pathString = [pathString stringByAppendingPathComponent:bundleName];
    NSString *path =  [[NSBundle bundleWithPath:pathString] pathForResource:resourceName ofType:type];
    return path;
}

+ (UIImage*)getResourceImgByBundleName: (NSString *)bundleName andResouceName: (NSString *)resourceName{
    NSString *pathString =[[ NSBundle   mainBundle ]. resourcePath   stringByAppendingPathComponent : @"Frameworks" ];
    pathString = [pathString stringByAppendingPathComponent:@"KuickDeal.framework"];
    pathString = [pathString stringByAppendingPathComponent:bundleName];
    pathString = [pathString stringByAppendingPathComponent:resourceName];
    UIImage *img =  [UIImage imageWithContentsOfFile:pathString];
    return img;
}
@end
