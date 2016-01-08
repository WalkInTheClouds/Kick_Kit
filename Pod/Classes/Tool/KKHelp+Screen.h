//
//  KKHelp+Screen.h
//  Pods
//
//  Created by laoJun on 16/1/8.
//
//


#import "KKHelp.h"

typedef NS_ENUM(NSUInteger, ScreenType) {
    ScreenType480h = 0,
    ScreenType568h,
    ScreenType667h,
    ScreenType736h,
};

@interface KKHelp (Screen)

//获取当前屏幕尺寸
+ (ScreenType)getSrceenTeyp;

@end
