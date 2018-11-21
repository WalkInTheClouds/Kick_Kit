//
//  KKHelp.m
//  Kuick
//
//  Created by laoJun on 15/8/5.
//  Copyright (c) 2015年 CCKaihui. All rights reserved.
//

#import "KKHelp.h"
#import "AFNetworking.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>


@implementation KKHelp

NSString *const KKSDK_KuickLive = @"KuickLive.bundle";
NSString *const KKSDK_KuickCall = @"KuickDeal.bundle";
NSString *const KKSDK_KuickDeal = @"KuickDeal.bundle";

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
    if ([imageType isEqualToString:@"JPEG"]) {
        //修正裁剪,裁剪后缀不能 为jpeg?
        imageType = @"jpg";
    }
    NSString *string = [NSString stringWithFormat:@"%@@1e_%dw_%dh_1c_0i_1o_1x",urlStirng,(int)width,(int)hight];
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
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    manager.responseSerializer.stringEncoding =  enc;
    [manager GET:url
      parameters:nil
        progress:nil
         success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject)
    {
//        NSError *parseError = nil;
//        NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&parseError];
////        NSString * dataString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
//        if (jsonData)
//        {
//            //使用gbk编码
//            NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
//            NSString *dataString = [[NSString alloc]initWithData:jsonData encoding:enc];
//            NSLog(@"-------%s---%@",__FUNCTION__,dataString);
//            NSError *error = nil;
//            responseObject = [NSJSONSerialization JSONObjectWithData:[dataString dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
//            NSLog(@"-----%@",error);
//        }
        
        
        ImageInfoModel *model = [[ImageInfoModel alloc]initWithDictionary:responseObject error:nil];
        success(model);
        

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failed(error);
    }];
    
    /*
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
     */
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
     NSString * KK = @"^1[3|4|5|6|7|8|9]\\d{9}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    NSPredicate *regextestKK = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", KK];
    
    if (([regextestmobile evaluateWithObject:mobileNum])
        || ([regextestcm evaluateWithObject:mobileNum])
        || ([regextestct evaluateWithObject:mobileNum])
        || ([regextestcu evaluateWithObject:mobileNum])
        ||  ([regextestKK evaluateWithObject:mobileNum]))
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

#pragma mark 验证密码
+ (BOOL)isValidatePassWord:(NSString *)passWord{
    NSString *strRegex = @"(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}";
    BOOL rt = [self isValidateRegularExpression:passWord byExpression:strRegex];
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
#pragma mark 获取顶层VC
+ (UIViewController *)getTopViewController
{
    UIViewController *currentVC = [KKHelp getPresentedViewController];
    if (!currentVC) {
        currentVC = [KKHelp getCurrentVC];
    }
    return currentVC;
}
#pragma mark : - 获取资源辅助方法

+ (NSString*)getResourcePathByBundleName: (NSString *)bundleName andResouceName: (NSString *)resourceName andType:(NSString*)type{
    NSString *path =  [[KKHelp getBundleByBundleName:bundleName] pathForResource:resourceName ofType:type];
    return path;
}

+ (UIImage*)getResourceImgByBundleName: (NSString *)bundleName andResouceName: (NSString *)resourceName{
    NSString *pathString = [self getTrueBundlePathWithBundleName:bundleName];
    pathString = [pathString stringByAppendingPathComponent:resourceName];
    UIImage *img =  [UIImage imageWithContentsOfFile:pathString];
    return img;
}

+ (NSBundle*)getBundleByBundleName: (NSString *)bundleName{
    NSString *pathString = [self getTrueBundlePathWithBundleName:bundleName];
    NSBundle *returnBundle =  [NSBundle bundleWithPath:pathString];

    return returnBundle;
}

+ (NSString *)getTrueBundlePathWithBundleName:(NSString *)bundleName
{
    NSString *pathString =[[ NSBundle   mainBundle ]. resourcePath   stringByAppendingPathComponent : @"Frameworks" ];
    pathString = [pathString stringByAppendingPathComponent:@"KuickDeal.framework"];
    pathString = [pathString stringByAppendingPathComponent:bundleName];
    NSFileManager *manger = [NSFileManager  defaultManager];
    BOOL isDir;
    if ([manger fileExistsAtPath:pathString isDirectory:&isDir]) {
        return pathString;
    }else
    {
        return pathString = [[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:bundleName];
    }
    
}
+ (NSString *)getCurrentNetWorkInfo
{
    BOOL isWifi = [AFNetworkReachabilityManager sharedManager].isReachableViaWiFi;
    BOOL isWWAN = [AFNetworkReachabilityManager sharedManager].isReachableViaWWAN;
    NSString *state = @"NULL";
    if (isWifi) {
        state = @"WIFI";
    } else if (isWWAN) {
        CTTelephonyNetworkInfo *telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
        NSString *currentStatus = telephonyInfo.currentRadioAccessTechnology;
        if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]){
            //GPRS网络
            state = @"2G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]){
            //2.75G的EDGE网络
            state = @"2G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
            //3G WCDMA网络
            state = @"3G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
            //3.5G网络
            state = @"3G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
            //3.5G网络
            state = @"3G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
            //CDMA2G网络
            state = @"2G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
            //CDMA的EVDORev0(应该算3G吧?)
            state = @"3G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
            //CDMA的EVDORevA(应该也算3G吧?)
            state = @"3G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
            //CDMA的EVDORev0(应该是算3G吧?)
            state = @"3G";
        } else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
            //HRPD网络
            state = @"";
        }else if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
            //LTE4G网络
            state = @"4G";
        }
    } else {
        state = @"NULL";
    }
    return state;
}
+ (NSArray *)removeFileSuffixesWithStrings:(NSArray *)strings{
  
    if (!strings || strings.count == 0) {
        return strings;
    }else{
        NSMutableArray *array = [NSMutableArray array];
        for (NSString *string in strings) {
            NSString *newString = [self removeFileSuffixesWithString:string];
            [array addObject:newString];
        }
        return array;
    }
    
}
+ (NSString *)removeFileSuffixesWithString:(NSString *)string{
    
    if (!string) {
        return string;
    }
    string =  [string stringByDeletingPathExtension];
    return string;

//    NSMutableArray *chars = [[string componentsSeparatedByString:@"."]  mutableCopy];
//    NSString *suffix = [chars lastObject];
//    if (suffix) {
//        [chars removeObject:suffix];
//         return [chars componentsJoinedByString:@"."];
//    }else{
//        return string;
//    }
}


+ (BOOL)stringContainsEmoji:(NSString *)string
{
    // 过滤所有表情。returnValue为NO表示不含有表情，YES表示含有表情
    __block BOOL returnValue = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    returnValue = YES;
                }
            }
        } else if (substring.length > 1) {
            const unichar ls = [substring characterAtIndex:1];
            if (ls == 0x20e3) {
                returnValue = YES;
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff) {
                returnValue = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                returnValue = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                returnValue = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                returnValue = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                returnValue = YES;
            }
        }
    }];
    return returnValue;
}

#pragma mark : 打开系统设置-本应用
+ (void)openApplicationOpenSettings{
    if (@available(iOS 8,*)){
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        UIApplication *application = [UIApplication sharedApplication];
        if ([application canOpenURL:url]){
            [application openURL:url];
        }
    }
}




@end
