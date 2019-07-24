//
//  HMFileManager.h
//  ManagementPlatform
//
//  Created by 胡苗 on 2017/7/13.
//  Copyright © 2017年 ITUser. All rights reserved.
//

#import <Foundation/Foundation.h>

#define EGOneFilePath @"Eg1Doc"

@interface NSString (HM)
+ (NSString *)URLDecodedString:(NSString *)str;
@end
/*!
 *  完成回调Block
 */
typedef void(^DoneBlock) (BOOL state, id data);


@interface HMFileManager : NSObject

+ (instancetype)share;

/**
 获取文件列表

 @return 返回文件列表数组
 */
- (NSArray *)getFileList;

/**
 下载指定文件

 @param url 文件连接
 @param compelte 完成回调
 */
- (void)downLoadFileWithUrl:(NSString *)url Block:(DoneBlock)compelte;

/**
 上传文件

 @param path 本地路径
 @param compelte 完成回调
 */
- (void)uploadFileWithPath:(NSString *)path Block:(DoneBlock)compelte;

/**
 获取文件目录

 @return 文件路径
 */
+ (NSString *)documentDirectoryPath;

/**
 文件路径是否存在

 @param directoryPath 文件路径
 @return 文件路径是否存在
 */
+ (BOOL)directoryExist:(NSString *)directoryPath;

/**
 文件是否存在

 @param filePath 文件路径
 @return 文件是否存在
 */
+ (BOOL)fileExist:(NSString *)filePath;

/**
 创建文件路径

 @param parentDirPath 上级文件路径
 @param dirName 文件名
 @return 创建成功与否状态
 */
+ (BOOL)createDirectoryAtParentDirectory:(NSString *)parentDirPath DirectoryName:(NSString *)dirName;

@end
