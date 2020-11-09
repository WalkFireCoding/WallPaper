//
//  PPWallPaperSetTool.h
//  Wallpaper
//
//  Created by yishen on 2020/10/22.
//  Copyright © 2020 BusinessTrip. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    UIImageScreenHome,
    UIImageScreenLock,
    UIImageScreenBoth
} UIImageScreen;

@interface PPWallPaperSetTool : NSObject
/**
 *  开关
 */
@property (nonatomic, assign) BOOL on;

/**
 *  一键保存到相册并设置为壁纸
 */
- (void)saveAndAsScreenPhotoWithImage:(UIImage *)image imageScreen:(UIImageScreen)imageScreen finished:(void (^)(BOOL success))finished;

/**
 *  单例对象
 */
+ (instancetype)shareInstance;
@end

NS_ASSUME_NONNULL_END
