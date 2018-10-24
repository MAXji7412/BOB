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
 后台播放
 */
+ (void)backgroundPlayer;

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
+ (void)play;


/**
 暂停
 */
+ (void)suspend;


/**
 切换播放和暂停状态
 */
+ (void)delagatePlayPause;

/**
 播放
 */
+ (void)delegatePlay;

/**
 暂停
 */
+ (void)delegateSuspend;

/**
 下一曲
 */
+ (void)delegateNaxt;

/**
 上一曲
 */
+ (void)delagatePrevious;

/**
 远程通知的响应

 @param event 事件
 */
+ (void)remoteControlReceivedWithEvent:(UIEvent *)event;

/**
 设置控制中心播放状态

 @param musicInfo 音乐信息
 */
+ (void)setMediaItemArtworkPlayingInfo:(NSDictionary *)musicInfo;




@end
