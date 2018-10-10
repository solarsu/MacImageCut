//
//  ViewController.m
//  DMMacImage
//
//  Created by lbq on 2018/4/23.
//  Copyright © 2018年 lbq. All rights reserved.
//

#import "ViewController.h"
#import "NSImage+DM.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
static NSInteger i = 0;
- (IBAction)clickAction:(id)sender
{
    NSArray *finalArray = [NSArray array];
    NSString *bundel=[[NSBundle mainBundle] resourcePath];
    NSString *deskTopLocation=[[bundel substringToIndex:[bundel rangeOfString:@"Library"].location] stringByAppendingFormat:@"Desktop"];
    NSString *homePath = [deskTopLocation stringByAppendingPathComponent:@"6dkk"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *panoArray = [self getPanoList:homePath];  //获取6dkk/目录下的所有包含pano的文件夹
    NSString *imageTypeStr = [self.imagetype stringValue];
    finalArray = [self gettargetArray:panoArray targetImgType:imageTypeStr];
    int  i = 0;
    for (NSString *imagePath in finalArray) {
        if ([fileManager fileExistsAtPath:imagePath]) {
            NSLog(@"文件存在");
            [self.info setStringValue:[NSString stringWithFormat:@"正在裁剪---%@",[imagePath lastPathComponent]]];
            NSImage *image = [[NSImage alloc]initWithContentsOfFile:imagePath];
            CGRect left = CGRectMake(0, 0, 4608, 3456);
            CGRect right = CGRectMake(4608, 0, 4608, 3456);
            NSImage *imageA = [image scaleAspectFillToSize:left];
            NSImage *imageB = [image scaleAspectFillToSize:right];
            NSString *dirPathA = [homePath stringByAppendingString:[NSString stringWithFormat:@"/%@A",imageTypeStr]];
            NSString *dirPathB = [homePath stringByAppendingString:[NSString stringWithFormat:@"/%@B",imageTypeStr]];
            if (![fileManager fileExistsAtPath:dirPathA]) {
                [fileManager createDirectoryAtPath:dirPathA withIntermediateDirectories:YES attributes:nil error:nil];
            }
            if (![fileManager fileExistsAtPath:dirPathB]) {
                [fileManager createDirectoryAtPath:dirPathB withIntermediateDirectories:YES attributes:nil error:nil];
            }
            NSString *savePathA = [homePath stringByAppendingString:[NSString stringWithFormat:@"/%@A/%d.jpg",imageTypeStr,i]];
            NSString *savePathB = [homePath stringByAppendingString:[NSString stringWithFormat:@"/%@B/%d.jpg",imageTypeStr,i]];
            [self saveImage:imageA savePath:savePathA];
            [self saveImage:imageB savePath:savePathB];
            i++;
        }
    }
    [self.info setStringValue:@"裁剪完成!!!!!"];
 
}



//获取包含pano的文件lujing
-(NSArray *)getPanoList:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *atributes = [NSMutableDictionary dictionary];
    NSError *err = nil;
    if ([fileManager fileExistsAtPath:path]) {
        NSLog(@"文件存在!!!");
    }
  
    [atributes setValue:[NSNumber numberWithShort:0777]
                  forKey:NSFilePosixPermissions];
    
    [fileManager setAttributes:atributes ofItemAtPath:path error:&err];
    if (err) {
        NSLog(@"chmod err --->%@",err);
    }
    
    if ([fileManager isReadableFileAtPath:path]) {
        NSLog(@"文件可读取");
    }
    NSArray *fileList = [NSArray array];
    fileList = [fileManager contentsOfDirectoryAtPath:path error:&err];
    if (err) {
        NSLog(@"error----%@",err);
    }
    NSMutableArray *dirAyyay = [NSMutableArray array];
    for (NSString *filePath in fileList) {
        if ([filePath containsString:@"pano"]) {
            NSString *tmpPath = [path stringByAppendingPathComponent:filePath];
            [dirAyyay addObject:tmpPath];
        }
    }
    return dirAyyay;
}

-(NSArray *)gettargetArray:(NSArray *)pathArray targetImgType:(NSString *)imgTarget{
    NSFileManager *fileManager = [NSFileManager defaultManager];
     NSMutableArray *targetArray = [NSMutableArray array];
    for (NSString *filePath in pathArray) {
        NSArray *fileList = [NSArray array];
        NSError *error  = nil;
        fileList = [fileManager contentsOfDirectoryAtPath:filePath error:&error];  //每一个文件夹里面的内容
        for (NSString *targetPath in fileList) {
            if ([targetPath containsString:imgTarget]) {
                NSString *tmpPath = [filePath stringByAppendingPathComponent:targetPath];
                [targetArray addObject:tmpPath];
            }
        }
    }
    return targetArray;
}


- (void)saveImage:(NSImage *)image savePath:(NSString *)appFile{
    [image lockFocus];
    //先设置 下面一个实例
    NSBitmapImageRep *bits = [[NSBitmapImageRep alloc]initWithFocusedViewRect:NSMakeRect(0, 0, image.size.width, image.size.height)];
    [image unlockFocus];
    
    //再设置后面要用到得props属性
    NSDictionary *imageProps = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:0.9] forKey:NSImageCompressionFactor];
    
    
    //之后 转化为NSData 以便存到文件中
    NSData *imageData = [bits representationUsingType:NSJPEGFileType properties:imageProps];
    
    //设定好文件路径后进行存储就ok了
    [imageData writeToFile:appFile atomically:YES];
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}



@end
