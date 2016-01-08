//
//  KKHelp+Screen.m
//  Pods
//
//  Created by laoJun on 16/1/8.
//
//

#import "KKHelp+Screen.h"

@implementation KKHelp (Screen)

//获取当前屏幕尺寸
+ (ScreenType)getSrceenTeyp
{
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (height == 480.f)
    {
        //3.4寸
        return ScreenType480h;
    }else if (height == 568.f)
    {
        //4寸
        return ScreenType568h;
    }else if (height == 667.f )
    {
        
        return ScreenType667h;
    }else if (height == 736.f)
    {
        return ScreenType736h;
    }
    return 10000;
}

@end
