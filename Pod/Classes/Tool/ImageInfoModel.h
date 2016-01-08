//
//  ImageInfoModel.h
//  Kuick
//
//  Created by laoJun on 15/8/24.
//  Copyright (c) 2015年 CCKaihui. All rights reserved.
//

#import "JSONModel.h"

@class valueModel;
@interface ImageInfoModel : JSONModel

@property (nonatomic,strong)NSDictionary <Optional>*FileSize;
@property (nonatomic,strong)NSDictionary <Optional>*Format;
@property (nonatomic,strong)NSMutableDictionary <Optional>*ImageHeight;
@property (nonatomic,strong)NSMutableDictionary <Optional>*ImageWidth;

@end


@interface valueModel : JSONModel

@property (nonatomic,copy)NSString *value;

@end