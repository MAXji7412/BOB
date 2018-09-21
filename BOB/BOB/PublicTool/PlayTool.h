//
//  PlayTool.h
//  BOB
//
//  Created by 汲群英 on 2018/9/10.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>


extern NSString *MusicNeme;//歌名
extern NSString *MusicUrl;//路径(NSURL)
extern NSString *MusicAlbumName;//专辑名称
extern NSString *MusicArtist;//艺术家
extern NSString *MusicImage;//专辑封面(UIImage)


@interface PlayTool : NSObject








/**
 后台播放，在APP将要退到后台时调用
 */
+ (void)turnOnBackgroundProcessingMultimediaEvents;


/**
 获取歌曲信息字典
 
 @return 当前工程内置歌曲及信息，
 */
+ (NSArray *)getMusicData;




/**
 播放音乐

 @param musicInfo 音乐信息
 @param delegate AVAudioPlayer的代理
 @return 错误信息，nil代表成功
 */
+ (NSError *)playByMusicInfo:(NSDictionary *)musicInfo delegate:(id)delegate;



/**
 获取播放实体

 @return 播放实体
 */
+ (AVAudioPlayer *)getPlayer;

/**
 恢复播放
 */
+ (void)resume;


/**
 暂停
 */
+ (void)suspend;









@end
