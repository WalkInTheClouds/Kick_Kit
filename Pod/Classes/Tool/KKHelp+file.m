//
//  KKHelp+file.m
//  Kuick
//
//  Created by laoJun on 16/5/10.
//  Copyright © 2016年 CCKaihui. All rights reserved.
//

#import "KKHelp+file.h"

NSString *const KKSalesCurrentAppModelPathName = @"KKSalesCurrentAppModelPathName.plist";
NSString *const KKSalesMenberPathName = @"KKSalesMenberlPathName.plist";
NSString *const KKSalesMemberWithStatePathName = @"KKSalesMenberlPathName.plist";
NSString *const KKDir_UserHabit = @"UserHabit";

@implementation KKHelp (file)

+ (NSString *)getLibraryPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirPath = [paths objectAtIndex:0];
    NSLog(@"---%@",libraryDirPath);
    return libraryDirPath;
}
+ (BOOL)checkPath:(NSString *)path isDirectory:(BOOL *)isDirectory
{
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL fileExists = NO;
    fileExists = [manager fileExistsAtPath:path isDirectory:isDirectory];
    return fileExists;
}
+(NSString *)getLibraryAppendPath:(NSString *)string
{
    NSString *path = [[self getLibraryPath] stringByAppendingPathComponent:string];
    return path;
}
+ (NSString *)getTruePath:(NSString *)path
{
    BOOL isDirectory = NO;
    if (![self checkPath:path isDirectory:&isDirectory]) {
        NSError *error;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            NSLog(@"---%@",error);
            return nil;
        }
    }
    return path;
    
}
+ (NSString *)getSandBoxAppendPath:(NSString *)string type:(KKSandBoxPathType)type truePath:(BOOL)truePath
{
    NSString *path;
    NSArray *array       = [string componentsSeparatedByString:@"/"];
    NSString *lastString = [array lastObject];
    NSString *dirString;
    BOOL isFile = NO;
    if ((isFile = [lastString containsString:@"."])) {
        NSMutableString *mutString = [string mutableCopy];
        [mutString deleteCharactersInRange:[mutString rangeOfString:lastString]];
        dirString = mutString;
    }else
    {
        dirString = string;
    }
    
    switch (type) {
        case KKSandBoxPathTypeLibraryUserHabit:
        {
            dirString = [[self getLibraryAppendPath:KKDir_UserHabit] stringByAppendingPathComponent:dirString];
        }
            break;
            
        default:
            break;
    }
    if (truePath) {
         path = [self getTruePath:dirString];
    }else
    {
        path = dirString;
    }
   
    if (isFile)
    {
        path = [path stringByAppendingPathComponent:lastString];
    }
    
    return path;
}
+ (BOOL)deleteWithPath:(NSString *)path error:(NSError *)error
{
    NSFileManager *manager = [NSFileManager defaultManager];
    return [manager removeItemAtPath:path error:&error];
}
+ (BOOL)cleanSanBoxAppendPath:(NSString *)string type:(KKSandBoxPathType)type
{
    NSString *path = nil;
    switch (type) {
        case KKSandBoxPathTypeLibraryUserHabit:
        {
           path = [[self getLibraryAppendPath:KKDir_UserHabit] stringByAppendingPathComponent:string];
        }
            break;
            
        default:
            break;
    }
    NSError *error = nil;
    BOOL succeed = [self deleteWithPath:path error:error];
    return succeed;
}
@end
