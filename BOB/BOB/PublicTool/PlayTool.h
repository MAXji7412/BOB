//
//  PlayTool.h
//  BOB
//
//  Created by 汲群英 on 2018/9/10.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayTool : NSObject


extern NSString *MusicNeme;//歌名
extern NSString *MusicUrl;//路径(NSURL)
extern NSString *MusicAlbumName;//专辑名称
extern NSString *MusicArtist;//艺术家
extern NSString *MusicImage;//专辑封面(UIImage)



/**
 后台播放，在APP将要退到后台时调用
 */
+ (void)turnOnBackgroundProcessingMultimediaEvents;


/**
 获取歌曲信息字典
 
 @return 当前工程内置歌曲及信息，
 */
+ (NSArray *)getMusicData;


@end
