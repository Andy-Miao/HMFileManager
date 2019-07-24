//
//  ViewController.m
//  HMFileManager
//
//  Created by humiao on 2019/7/24.
//  Copyright © 2019 humiao. All rights reserved.
//

#import "ViewController.h"
#import "HMFileManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    NSString *fileName = [self getLocalPath:@"egOne"];  // 上传是图像用的OSSManage，在HMFileManager内部可做替换。
    [[HMFileManager share] uploadFileWithPath:fileName Block:^(BOOL state, id data) {
        if (state) {
            NSLog(@"上传成功");
        }
    }];

}


- (NSString *)getLocalPath:(NSString *)localPath {
    NSString *docPath = [HMFileManager documentDirectoryPath];
    
    NSString *myPath = [NSString stringWithFormat:@"%@/%@", docPath, EGOneFilePath];
    // 获取相对路径
    NSString *fileName = [localPath stringByReplacingOccurrencesOfString:@"http://im01.ymm.cn/" withString:@""];
    NSArray *arr = [localPath componentsSeparatedByString:@"/"];
    if (arr.count>0) {
        fileName = [arr lastObject];
    }
    NSString *filePath = [NSString stringWithFormat:@"%@/%@", myPath, fileName];
    
    return filePath;
}
@end
