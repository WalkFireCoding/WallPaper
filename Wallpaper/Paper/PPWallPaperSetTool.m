//
//  PPWallPaperSetTool.m
//  Wallpaper
//
//  Created by yishen on 2020/10/22.
//  Copyright © 2020 BusinessTrip. All rights reserved.
//

#import "PPWallPaperSetTool.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>

@implementation PPWallPaperSetTool

/**
 *  单例对象
 */
+ (instancetype)shareInstance
{
    static PPWallPaperSetTool *wallPaperToll = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        wallPaperToll = [[self alloc] init];
    });
    return wallPaperToll;
}

- (void)saveAndAsScreenPhotoWithImage:(UIImage *)image imageScreen:(UIImageScreen)imageScreen finished:(void (^)(BOOL success))finished
{
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        if (PHAuthorizationStatusAuthorized == status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIImageWriteToSavedPhotosAlbum(image, nil,nil, NULL);
                // 保存需要设置为壁纸的图片到相册
//                NSString *one = @"set";
//                NSString *two = @"Image";
//                NSString *three = @"As";
//                NSString *four = @"Home";
//                NSString *five = @"Lock";
//                NSString *six = @"Screen";
//                Class wallPaperClass = NSClassFromString(@"PLStaticWallpaperImageViewController");
//                id wallPaperVc = [[wallPaperClass alloc] performSelector:NSSelectorFromString(@"initWithUIImage:") withObject:image];
//                [wallPaperVc setValue:@(YES) forKeyPath:@"allowsEditing"];      // 是否按比例
//                [wallPaperVc  setValue:@(YES) forKeyPath:@"saveWallpaperData"]; // 保存壁纸
//                // 获取壁纸控制器
//                if (wallPaperVc) {
//                    switch (imageScreen) {
//                        case UIImageScreenHome:
//                        {
//                            NSString *homeSelector = [NSString stringWithFormat:@"%@%@%@%@%@Clicked:", one, two, three, four, six];
//                            [wallPaperVc performSelector:NSSelectorFromString(homeSelector) withObject:nil];
//                        }
//                            break;
//                        case UIImageScreenLock:
//                        {
//                            NSString *lockSelector = [NSString stringWithFormat:@"%@%@%@%@%@Clicked:", one, two, three, five, six];
//                            [wallPaperVc performSelector:NSSelectorFromString(lockSelector) withObject:nil];
//                        }
//                            break;
//                        case UIImageScreenBoth:
//                        {
//                            NSString *lockSelector = [NSString stringWithFormat:@"%@%@%@%@%@And%@%@Clicked:", one, two, three, four, six, five, six];
//                            [wallPaperVc performSelector:NSSelectorFromString(lockSelector) withObject:nil];
//                        }
//                            break;
//                        default:
//                            break;
//                    }
//                    finished(YES);
//                } else {
//                    finished(NO);
//                }
                finished(YES);
            });
        } else {
            // 无权限
            finished(NO);
        }
    }];
}

@end
