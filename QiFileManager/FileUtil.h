//
//  FileUtil.h
//  QiUtils
//
//  Created by dac_1033 on 2018/10/25.
//  Copyright © 2018年 QiShare. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FileUtil : NSObject

// 获取沙盒根路径
+ (NSString *)getHomePath;

// 获取tmp路径
+ (NSString *)getTmpPath;

// 获取Documents路径
+ (NSString *)getDocumentsPath;

// 获取Library路径
+ (NSString *)getLibraryPath;

// 获取LibraryCache路径
+ (NSString *)getLibraryCachePath;

// 检查文件、文件夹是否存在
+ (BOOL)fileExistsAtPath:(NSString *)path isDirectory:(BOOL *)isDir;

// 创建文件
+ (void)createDirectory:(NSString *)path;

// 创建文件夹
+ (NSString *)createFile:(NSString *)filePath fileName:(NSString *)fileName;

// 复制 文件or文件夹
+ (void)copyItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;

// 移动 文件or文件夹
+ (void)moveItemAtPath:(NSString *)srcPath toPath:(NSString *)dstPath;

// 删除 文件or文件夹
+ (void)removeItemAtPath:(NSString *)path;

// 获取目录下所有内容
+ (NSArray *)getContentsOfDirectoryAtPath:(NSString *)docPath;

@end

NS_ASSUME_NONNULL_END
