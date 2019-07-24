//
//  HMFileManager.m
//  ManagementPlatform
//
//  Created by 胡苗 on 2017/7/13.
//  Copyright © 2017年 ITUser. All rights reserved.
//

#import "HMFileManager.h"
#import "ContentModel.h"
#import <UIKit/UIKit.h>



@implementation NSString (HM)

+ (NSString *)URLDecodedString:(NSString *)str {
    NSString *decodedString=(__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL, (__bridge CFStringRef)str, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    
    return decodedString;
}
@end

@implementation HMFileManager

+ (instancetype)share {
    
    static HMFileManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    
    return instance;
}

- (NSArray *)getFileList {
    
    // 判断当前文件夹是否存在
    NSString *docPath = [HMFileManager documentDirectoryPath];
    NSString *myPath = [NSString stringWithFormat:@"%@/%@", docPath, EGOneFilePath];
    
    if ([HMFileManager directoryExist:myPath]) {
        return [HMFileManager contentsAtParentDirPath:myPath];
    } else {
        // 创建文件路径
        [HMFileManager createDirectoryAtParentDirectory:docPath DirectoryName:myPath];
        return nil;
    }
}

- (void)downLoadFileWithUrl:(NSString *)url Block:(DoneBlock)compelte {
    
    NSString *docPath = [HMFileManager documentDirectoryPath];
    NSString *myPath = [NSString stringWithFormat:@"%@/%@", docPath, EGOneFilePath];
    url = [NSString URLDecodedString:url];
    NSString *singleUrl = url;
    
    if ([HMFileManager directoryExist:myPath]) {
        //[FileManager contentsAtParentDirPath:myPath];
        NSArray *arr = [url componentsSeparatedByString:@"/"];
        if (arr.count > 0) {
            singleUrl = [arr lastObject];
        }
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@", myPath, singleUrl];
        
        if ([HMFileManager fileExist:filePath]) {
            compelte(YES, @{@"type":@"1", @"path":filePath});
            return;
        }
        
    } else {
        // 创建文件路径
        [HMFileManager createDirectoryAtParentDirectory:docPath DirectoryName:myPath];
    }
    
    // 创建文件
    [HMFileManager createFileAtParentDircetory:myPath FileName:singleUrl];
    
    //TODO: 可用OSS做传输或者用其它的工具类在此处替换 写入流
//    [[OSSManager sharedInstance] downLoadwithUrl:url Dir:myPath Block:^(BOOL state, id data) {
//        compelte(state, @{@"type":@"0", @"path":data});
//    }];
}

- (void)uploadFileWithPath:(NSString *)path Block:(DoneBlock)compelte {
    //TODO: 可用OSS做传输或者用其它的工具类在此处替换 上传流
//    [[OSSManager sharedInstance] uploadFileWithFilePath:path Block:^(BOOL state, id data) {
//        compelte(state, data);
//    }];
}

// 获取document路径
+ (NSString *)documentDirectoryPath {
    
    NSArray *array = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [array objectAtIndex:0];
}

// 判断目录是否存在
+ (BOOL)directoryExist:(NSString *)directoryPath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = NO;
    BOOL exist = [fileManager fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    if (isDirectory && exist) {
        return YES;
    }
    return NO;
}

// 判断文件是否存在
+ (BOOL)fileExist:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager fileExistsAtPath:filePath];
}

// 在父目录下创建子目录
+ (BOOL)createDirectoryAtParentDirectory:(NSString *)parentDirPath DirectoryName:(NSString *)dirName {
    
    if (!parentDirPath) {
        parentDirPath = [self documentDirectoryPath];
    }
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/%@", parentDirPath, dirName];
    
    return [fileManager createDirectoryAtPath:directoryPath withIntermediateDirectories:YES attributes:nil error:nil];
}

// 在父目录下创建子文件
+ (BOOL)createFileAtParentDircetory:(NSString *)parentDirPath FileName:(NSString *)fileName {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", parentDirPath, fileName];
    return [fileManager createFileAtPath:filePath contents:nil attributes:nil];
}

// 获取父目录下所有字内容 （包含目录和文件）
+ (NSArray *)contentsAtParentDirPath:(NSString *)parentDirectory {
    
    //获取当前目录下的所有文件
    NSArray *directoryContents = [[NSFileManager defaultManager] directoryContentsAtPath: parentDirectory];
    
    NSMutableArray *foldersArr = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *photosArr = [NSMutableArray arrayWithCapacity:0];
    
    NSArray *sourceList = @[foldersArr, photosArr];
    
    for (NSUInteger i = 0; i < directoryContents.count; i++) {
        //获取一个文件或文件夹
        NSString *selectedFile = (NSString*)[directoryContents objectAtIndex: i];
        
        //拼成一个完整路径
        NSString *selectedPath = [parentDirectory stringByAppendingPathComponent: selectedFile];
        
        BOOL isDir;
        //判断是否是为目录
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:selectedPath isDirectory:&isDir] && isDir)
        {
            //目录
            [foldersArr addObject:selectedPath];
        }
        else
        {
            //文件
            ContentModel *model = [[ContentModel alloc] init];
            model.path = selectedPath;
            model.name = selectedFile;
          
            if ([model.path hasSuffix:@"pdf"]) {
                model.fileType = FileTypePDF;
            } else if ([model.path hasSuffix:@"doc"]) {
                 model.fileType = FileTypeDOC;
            } else if ([model.path hasSuffix:@"xls"]) {
                model.fileType = FileTypeXLS;
            } else if ([model.path hasSuffix:@"ppt"]) {
                model.fileType = FileTypePPT;
            } else {
                model.fileType = FileTypePSD;
            }
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *path = selectedPath;//@"/tmp/List";
            NSError *error = nil;
            NSDictionary *fileAttributes = [fileManager attributesOfItemAtPath:path error:&error];
            
            if (fileAttributes != nil) {
                
                NSNumber *fileSize = [fileAttributes objectForKey:NSFileSize];
                //NSString *fileOwner = [fileAttributes objectForKey:NSFileOwnerAccountName];
                //NSDate *fileModDate = [fileAttributes objectForKey:NSFileModificationDate];
                NSDate *fileCreateDate = [fileAttributes objectForKey:NSFileCreationDate];
                
                unsigned long long sizeValue = [fileSize unsignedLongLongValue];
                sizeValue/=1024;
                if (sizeValue == 0) {
                    sizeValue = 1;
                }
                model.size = sizeValue;
                
                model.createDate = [self getTimeWithDate:fileCreateDate];
            }
            
            [photosArr addObject:model];
        }
    }
    
    return [sourceList copy];
}

#pragma mark 获取沙盒中完整的文件路径
+ (NSString *)getFilePath:(NSString *)currentPath{
    
    NSString *filePath;
    
    //获取沙盒Documents目录路径
    NSString *docPath = [self documentDirectoryPath];
    NSString *fileName = [NSString stringWithFormat:@"qmsht%@%ld.png", [self getTimeSpForNow], random()%10000];
    //跟文件名组合起来(使用NSString的实例方法stringByAppendingPathComponent: 组成文件的完整路径）
    filePath = [docPath stringByAppendingPathComponent:fileName];
    NSLog(@"filePath：%@",filePath);
    
    return currentPath?[currentPath stringByAppendingPathComponent:fileName]:docPath;
}

/**
 * 将图片写进沙盒
 */
+ (void)writeImageToDocPathsWith:(NSString *)currentPath AndImgs:(NSArray *)images Block:(DoneBlock)complete {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        for (UIImage *image in images) {
            
            NSString *filePath = [self getFilePath:currentPath];
            
            if (![fileManager fileExistsAtPath:filePath]) {
                
                [fileManager createFileAtPath:filePath contents:nil attributes:nil];
            }
            
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:filePath];
            
            NSData *fileData = UIImagePNGRepresentation(image);
            //文件句柄指向文件末尾，相当于给文件追加内容
            [fileHandle seekToEndOfFile];
            //写文件
            [fileHandle writeData:fileData];
            
            [fileHandle closeFile];
        }
        // 操作结束，返回主线程刷新
        complete(YES, @"done");
    });
}

+ (NSString *)getTimeWithDate:(NSDate *)date {
    // 获取当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    return [dateFormatter stringFromDate:date];;
}

+ (NSString *)getCurrentTime {
    // 获取当前时间
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy/MM/dd HH:mm"];
    return [dateFormatter stringFromDate:[NSDate date]];
}

+ (NSString *)getTimeSpForNow {
    
    NSDate *datenow = [NSDate date];//现在时间,你可以输出来看下是什么格式
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
}
@end
