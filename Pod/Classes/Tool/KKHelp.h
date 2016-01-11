//
//  KKHelp.h
//  Kuick
//
//  Created by laoJun on 15/8/5.
//  Copyright (c) 2015年 CCKaihui. All rights reserved.
//

/*
 *文件名:   KKHelp.h
 *功能描述:   提供一些常用的 函数 处理方法
 *创建人:   gengmengjun
 *修改日期:  20150728
 */

#import <Foundation/Foundation.h>
#import "ImageInfoModel.h"
// block
typedef void (^I_succeedBlock) (ImageInfoModel *infoModel);
typedef void (^I_failBlock) (NSError *error);
@interface KKHelp : NSObject


///把数组的第一个元素 移动到最后一个
+ (void)moveObjectToLastIndex:(NSMutableArray *)array;

///把一段时间转换成 00:00:00 格式的 字符串
+ (NSString *)getTimeStringWithTimeInterval:(NSInteger)time;

///把网络上的图片按照一定的尺寸进行裁剪;
/*
 * @param urlStirng url 地址;
 * @param width 图片宽;
 * @param hight 图片长;
 */
+ (NSString *)getClipWebImageURLWithUrlString:(NSString *)urlStirng
                                     width:(NSInteger)width
                                     hight:(NSInteger)hight;

///把网络上的图片某一边（宽或高）进行固定到一个长度，另外一边按照比例进行调整。
/*
 * @param urlStirng url 地址;
 * @param width 图片宽;
 */
+ (NSString *)getClipWebImageURLWithUrlString:(NSString *)urlStirng
                                     width:(NSInteger)width;
/*
 * @param urlStirng url 地址;
 * @param success 成功地 block 返回 imageinfo model;
 * @param failBlock  错误 block;
 */
///获取网络图片的信息;
+ (void)getImageInfoWithUrlString:(NSString *)urlString
                     succeedBlock: (I_succeedBlock)success
                        failBlock:(I_failBlock)failed;

/*
 * @param string 被计算字符串;
 * @param font 字体;
 * @param height 限定高度;
 */
///得到一行字体的长度
+ (CGFloat)getStringWidthWihtString:(NSString *)string
                               font:(UIFont *)font
                             height:(CGFloat)height;

/*
 * @param string 被计算字符串;
 * @param font 字体;
 * @param width 限定长度;
 */
///得到一行字体的高度
+ (CGFloat)getStringHeightWihtString:(NSString *)string
                                font:(UIFont *)font
                               width:(CGFloat)width;

/*
 * @param mobileNum 电话号码;
 */
/// 正则判断手机号码地址格式
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

/*
 * @param number 验证码;
 */
///验证6位号码
+ (BOOL)isValidateTelNumber:(NSString *)number;
/**
 *  是否是纯数字
 *
 *  @param string 需要判断的参数
 *
 *  @return 判断结果
 */
+ (BOOL)isValidateNumber:(NSString *)string;
/**
 *  字符串是否为空(包括空格)
 *
 *  @param str 需要判断的参数
 *
 *  @return 判断结果
 */
+(BOOL)isEmpty:(NSString *)str;
/*
 * @param number 邮箱;
 */
//验证email
+ (BOOL)isValidateEmail:(NSString *)email;

+ (UIImage *)getStretchableImage:(UIImage *)image;

///获得屏幕图像
+ (UIImage *)getScreenshotImage;

///得到纯数字
+ (NSString *)trimString:(NSString *)string isPhoneNumber:(BOOL)isPhone;

///任意类型转字符串
+ (NSString *)getString:(id)object;

/**
 *  修正图片方向
 *
 *  @param aImage 需要修正的image
 *
 *  @return 处理过的image
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 *  去除多余的分割线
 *
 *  @param tableView 需要去除的tableView
 */
+ (void)setExtraCellLineHidden: (UITableView *)tableView;

/**
 *  获取当前vc(不包含弹出vc)
 *
 *  @return 当前vc
 */
+ (UIViewController *)getCurrentVC;

/**
 *  获取当前弹出vc
 *
 *  @return 弹出的vc
 */
+ (UIViewController *)getPresentedViewController;
@end
