//
//  ViewController.m
//  QiFileManger
//
//  Created by dac_1033 on 2018/10/25.
//  Copyright © 2018年 QiShare. All rights reserved.
//

#import "ViewController.h"
#import "FileUtil.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"QiFileManger"];
    
    // 关于沙盒
    [self testSandBoxDirectory];
    
//    // 关于NSFileManager
//    [self testFileManager];
    
//    // 可直接读写文件的数据类型
//    [self directReadAndWrite];

//    // 关于NSBundle
//    [self testBundle];

//    // 关于NSFileHandle
//    [self testFileHandle];
}

- (void)testSandBoxDirectory {
    
    // 获取app沙盒的根目录（home）
    NSString *homePath = NSHomeDirectory();
    NSLog(@"NSHomeDirectory: %@", homePath);
    
    // 获取temp路径
    NSString *temp = NSTemporaryDirectory( );
    NSLog(@"NSTemporaryDirectory: %@", temp);
    
    // 获取Document目录
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [paths lastObject];
    NSLog(@"NSDocumentDirectory: %@", docPath);
    
    // 获取Library目录
    paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libPath = [paths lastObject];
    NSLog(@"NSLibraryDirectory: %@", libPath);
    
    // 获取Library中的Cache
    paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachesPath = [paths lastObject];
    NSLog(@"NSCachesDirectory: %@", cachesPath);
}

- (void)testFileManager {
    
    NSString *docPath = [FileUtil getDocumentsPath];
    NSLog(@"--- docPath --->> %@", docPath);
    
    NSString *path1 = [docPath stringByAppendingPathComponent:@"QiShare/A"];
    NSString *path2 = [docPath stringByAppendingPathComponent:@"QiShare/B"];
    NSString *path3 = [docPath stringByAppendingPathComponent:@"QiShare/C"];

    // 创建路径
    [FileUtil createDirectory:path1];
    [FileUtil createDirectory:path2];
    [FileUtil createDirectory:path3];

    // 创建文件
    // 注：创建文件时，文件所在路径需已存在，否则失败！
    NSString *path11 = [FileUtil createFile:path1 fileName:@"a.txt"];
    NSString *path22 = [FileUtil createFile:path2 fileName:@"b.doc"];
    NSString *path33 = [FileUtil createFile:path3 fileName:@"c.json"];

    //// 注：要求所操作的文件在两个路径中中同名
    // 复制文件
    [FileUtil copyItemAtPath:path11 toPath:[path2 stringByAppendingPathComponent:@"a.txt"]];
    // 剪切文件
    [FileUtil moveItemAtPath:path11 toPath:[path3 stringByAppendingPathComponent:@"a.txt"]];
    // 删除文件
    [FileUtil removeItemAtPath:path22];

    // 获取path2下所有内容
    NSArray *contents = [FileUtil getContentsOfDirectoryAtPath:path3];
    NSLog(@"--- contents --->> %@", contents);
}

- (void)directReadAndWrite {
    
    NSString *docPath = [FileUtil getDocumentsPath];
    NSString *path = [docPath stringByAppendingPathComponent:@"QiShare"];
    [FileUtil createDirectory:path];
    NSString *filePath = [FileUtil createFile:path fileName:@"a.txt"];
    
    //// 注：1.写入时将覆盖已有内容；2.数组和字典的元素类型也必须是以下这几个类型。
    NSString *string = @"QiShare test string ...";
    [string writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    NSString *readStr = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSLog(@"读取文件-字符串： %@", readStr);

    NSArray *array = @[@"Q", @"i", @"S", @"h", @"a", @"r", @"e"];
    [array writeToFile:filePath atomically:YES];
    NSArray *readArr = [NSArray arrayWithContentsOfFile:filePath];
    NSLog(@"读取文件-数组： %@", readArr);

    NSDictionary *dict = @{@"en":@"QiShare", @"ch":@"奇分享 "};
    [dict writeToFile:filePath atomically:YES];
    NSDictionary *readDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSLog(@"读取文件-字典： %@", readDict);

    NSData *data = [@"QiShare test data ..." dataUsingEncoding:NSUTF8StringEncoding];
    [data writeToFile:filePath atomically:YES];
    NSData *readData = [NSData dataWithContentsOfFile:filePath];
    NSLog(@"读取文件-二进制： %@", readData);
}

- (void)testBundle {
    
    // 获取main bundle
    NSBundle *mainBundle = [NSBundle mainBundle];
    // 放在app mainBundle中的自定义Test.bundle
    NSString *testBundlePath = [mainBundle pathForResource:@"Test" ofType:@"bundle"];
    NSBundle *testBundle = [NSBundle bundleWithPath:testBundlePath];
    // 放在自定义Test.bundle中的图片
    NSString *resPath = [testBundle pathForResource:@"sound02" ofType:@"wav"];
    NSLog(@"自定义bundle中资源的路径: %@", resPath);
    
    _imgView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_imgView];
    UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"Test.bundle/%@", @"logo_img_02"]];
    NSLog(@"自定义bundle中图片: %@", img);
    [_imgView setImage:img];
}

// NSFileHandle操作文件内容
- (void)testFileHandle {
    
    NSString *docPath = [FileUtil getDocumentsPath];
    NSString *readPath = [docPath stringByAppendingPathComponent:@"read.txt"];
    NSString *writePath = [docPath stringByAppendingPathComponent:@"write.txt"];
    NSData *data = [@"abcdefghijklmnopqrstuvwxyz" dataUsingEncoding:NSUTF8StringEncoding];
    
    NSFileManager *manager=[NSFileManager defaultManager];
    [manager createFileAtPath:readPath contents:data attributes:nil];
    [manager createFileAtPath:writePath contents:nil attributes:nil];
    [data writeToFile:readPath atomically:YES];
    
    // 打开文件 读
    NSFileHandle *readHandle = [NSFileHandle fileHandleForReadingAtPath:readPath];
    NSData *readData = [readHandle readDataToEndOfFile];
    
    // 读取文件中指定位置/指定长度的内容
    [readHandle seekToFileOffset:10];
    readData = [readHandle readDataToEndOfFile];
    NSLog(@"seekToFileOffset:12 = %@", [[NSString alloc] initWithData:readData encoding:NSUTF8StringEncoding]);
    
    [readHandle seekToFileOffset:10];
    readData = [readHandle readDataOfLength:5];
    NSLog(@"seekToFileOffset:10 = %@",[[NSString alloc]initWithData:readData encoding:NSUTF8StringEncoding]);
    [readHandle closeFile];
    
    // 打开文件 写
    NSFileHandle *writeHandle = [NSFileHandle fileHandleForWritingAtPath:writePath];
    // 注：直接覆盖文件原有内容
    [writeHandle writeData:data];
    
    // 注：覆盖了指定位置/指定长度的内容
    [writeHandle seekToFileOffset:2];
    [writeHandle writeData:[@"CDEFG" dataUsingEncoding:NSUTF8StringEncoding]];
    
    [writeHandle seekToEndOfFile];
    [writeHandle writeData:[@"一二三四五六" dataUsingEncoding:NSUTF8StringEncoding]];
    [writeHandle closeFile];
}

@end
