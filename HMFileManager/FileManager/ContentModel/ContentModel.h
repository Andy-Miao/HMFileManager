//
//  ContentModel.h
//  ManagementPlatform
//
//  Created by 胡苗 on 2017/7/13.
//  Copyright © 2017年 ITUser. All rights reserved.
//

#import <Foundation/Foundation.h>
    
typedef NS_ENUM(NSUInteger, ContentType){
    ContentTypeDirectory = 0,
    ContentTypeFile
};

typedef NS_ENUM(NSUInteger, FileType){
    FileTypePDF = 0,
    FileTypeDOC,
    FileTypePSD,
    FileTypeXLS,
    FileTypePPT
};

/**
 文件类型
 */
@interface ContentModel : NSObject

@property (nonatomic, assign) ContentType curConentType; // 内容类型
@property (nonatomic, copy) NSString *name; // 文件名称
@property (nonatomic, copy) NSString *path; // 文件路径
@property (nonatomic, copy) NSString *createDate; // 创建日期
@property (nonatomic, assign) unsigned long long size; // 文件长度
@property (nonatomic, assign) FileType fileType; // 文件类型

@end
