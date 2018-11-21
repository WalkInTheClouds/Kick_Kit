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
+ (KKiPhoneScreenType)getSrceenTeyp
{
    
    
    CGFloat const iPhoneXS_max = 896;       //414 * 896   3x
    CGFloat const iPhoneXS = 812;           //375 x 812   3x
    CGFloat const iPhoneXR = iPhoneXS_max;  //414 * 896   2x
    CGFloat const iPhoneX = iPhoneXS;       //375 x 812   3x
    CGFloat const iPhone8p = 736;           //414 x 736   3x
    CGFloat const iPhone8 = 667;            //375 x 667   2x
    CGFloat const iPhone7p = iPhone8p;      //414 x 736   3x
    CGFloat const iPhone7 = iPhone8;        //375 x 667   2x
    CGFloat const iPhone6p = iPhone7p;      //414 x 736   3x
    CGFloat const iPhone6 = iPhone7p;       //375 x 667   2x
    CGFloat const iPhone5 = 568;            //320 x 568   2x
    CGFloat const iPhone4 = 480;           ///320 x 480   2x
    
    
    
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    if (height == iPhoneXS_max && scale == 3 ) {
        //6.5
        return KKiPhoneScreenTypeiPhoneXS_MAX;
    }else if (height == iPhoneXR && scale == 2 ){
        //6.1
        return  KKiPhoneScreenTypeiPhoneXR;
    }else if (height == iPhoneXS ||
              height == iPhoneX){
        //5.8
        return  KKiPhoneScreenTypeiPhoneX_iPhoneXS;
    }else if ( height == iPhone8p ||
               height == iPhone7p ||
               height == iPhone6p ){
        //5.5
        return KKiPhoneScreenTypeRetinaHD55;
    }else if (height == iPhone8  ||
              height == iPhone7  ||
              height == iPhone6){
        //.4.7
        return KKiPhoneScreenTypeRetinaHD47;
    }else if (height == iPhone5){
        //4
        return KKiPhoneScreenTypeRetina4;
    }else if (height == iPhone4){
        //3.7
        return KKiPhoneScreenTypeRetina2x;
    }
    
    return 10000;
}

@end
