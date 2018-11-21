//
//  KKHelp+Screen.h
//  Pods
//
//  Created by laoJun on 16/1/8.
//
//


#import "KKHelp.h"

//typedef NS_ENUM(NSUInteger, ScreenType) {
//    ScreenType480h = 0,
//    ScreenType568h,
//    ScreenType667h,
//    ScreenType736h,
//};

typedef NS_ENUM(NSUInteger, KKiPhoneScreenType) {
    KKiPhoneScreenTypeiPhoneXS_MAX = 107, //414 * 896 @3x
    KKiPhoneScreenTypeiPhoneXR = 106,//414 *896 @2x
    KKiPhoneScreenTypeiPhoneX_iPhoneXS = 105,//375 x 812 @3x
    KKiPhoneScreenTypeRetinaHD55 = 104,//414 x 736 @3x   >> ip6p\ip7p\ip8p
    KKiPhoneScreenTypeRetinaHD47 = 103,//375 x 667 @2x   >> ip6\ip7\ip8
    KKiPhoneScreenTypeRetina4 = 102,//320 x 568 @2x      >> ipSE\ip5s\ip5\ip5c
    KKiPhoneScreenTypeRetina2x = 101,//320 x 480 @2x     >> ip4s\ip4\ip3GS\ip3\ip2G
    
    /*
     ipx\ipxs\ipxr\ipxs_max  屏幕比例相似，建议使用ipxs_max 覆盖
     ip6~ip8p 系列 屏幕比例相同，建议使用 ip8p 尺寸覆盖
     */
};


@interface KKHelp (Screen)

//获取当前屏幕尺寸
+ (KKiPhoneScreenType)getSrceenTeyp;

@end
