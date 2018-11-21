//
//  KKHelp+file.h
//  Kuick
//
//  Created by laoJun on 16/5/10.
//  Copyright © 2016年 CCKaihui. All rights reserved.
//

#import "KKHelp.h"

/**
 *  销售模块当前选择app的存储路径
 */
FOUNDATION_EXPORT NSString *const KKSalesCurrentAppModelPathName;
FOUNDATION_EXPORT NSString *const KKSalesMenberPathName;
FOUNDATION_EXPORT NSString *const KKSalesMemberWithStatePathName;
typedef NS_ENUM(NSInteger,KKSandBoxPathType)
{
    KKSandBoxPathTypeLibraryUserHabit = 0
};

@interface KKHelp (file)
/**
 *  根据另行拼接路径
 *
 *  @param string     相对路径
 *  @param type       路径类型
 *  @param truePath   是否创建绝对路径
 *
 *  @return 绝对路径
 */
+ (NSString *)getSandBoxAppendPath:(NSString *)string type:(KKSandBoxPathType)type truePath:(BOOL)truePath;


+ (BOOL)cleanSanBoxAppendPath:(NSString *)string type:(KKSandBoxPathType)type;

@end
