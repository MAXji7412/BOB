//
//  PlayTool.m
//  BOB
//
//  Created by 汲群英 on 2018/9/10.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import "PlayTool.h"

#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MPNowPlayingInfoCenter.h>
#import <MediaPlayer/MPMediaItem.h>


NSString *MusicNeme = @"musicNeme";//歌名
NSString *MusicUrl = @"musicUrl";//路径(NSURL)
NSString *MusicAlbumName = @"musicAlbumName";//专辑名称
NSString *MusicArtist = @"musicArtist";//艺术家
NSString *MusicImage = @"musicImage";//专辑封面(UIImage)

@implementation PlayTool

+ (NSArray *)getMusicData
{
    NSMutableArray<NSDictionary *> *musicDataArrM = [NSMutableArray array];;
    
    NSString *sourceDataPath = [[NSBundle mainBundle] bundlePath];
    NSArray<NSString *> *allDataPathArr = [[NSFileManager defaultManager] subpathsAtPath:sourceDataPath];
    
    for (NSString *dataPath in allDataPathArr) {
        
        NSMutableDictionary *mp3InfoDicM = [NSMutableDictionary dictionaryWithCapacity:4];
        
        NSString *fullPath = [sourceDataPath stringByAppendingPathComponent:dataPath];
        NSURL *mp3Url = [NSURL fileURLWithPath:fullPath];
        if (![mp3Url.pathExtension.lowercaseString isEqualToString:@"mp3"]) {
            continue;
        }
        
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:mp3Url
                                                    options:nil];
        
        
        NSArray *titles = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyTitle keySpace:AVMetadataKeySpaceCommon];
        NSArray *artists = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyArtist keySpace:AVMetadataKeySpaceCommon];
        NSArray *albumNames = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata withKey:AVMetadataCommonKeyAlbumName keySpace:AVMetadataKeySpaceCommon];
        
        AVMetadataItem *titleItem = titles.firstObject;
        AVMetadataItem *artistItem = artists.firstObject;
        AVMetadataItem *albumNameItem = albumNames.firstObject;
        
        NSString *title = titleItem.stringValue;
        NSString *artist = artistItem.stringValue;
        NSString *albumName = albumNameItem.stringValue;
        __block UIImage *image;
        
        [mp3InfoDicM setObject:mp3Url forKey:MusicUrl];//MP3文件路径
        [mp3InfoDicM setObject:CheckString(title) forKey:MusicNeme];//歌曲名
        [mp3InfoDicM setObject:CheckString(artist) forKey:MusicArtist];//艺术家
        [mp3InfoDicM setObject:CheckString(albumName) forKey:MusicAlbumName];//专辑名
        
        
        // Load the asset's "playable" key
        NSString *infoKey = @"playable";
        dispatch_semaphore_t semap = dispatch_semaphore_create(0);
        
        
        [asset loadValuesAsynchronouslyForKeys:@[infoKey] completionHandler:^{
            
            
            NSError *error = nil;
            AVKeyValueStatus status = [asset statusOfValueForKey:infoKey error:&error];
            if (error) {
                BOBLog(@"%@",error);
            }
            if (status == AVKeyValueStatusLoaded) {
                NSArray *artworkss = [AVMetadataItem metadataItemsFromArray:asset.commonMetadata
                                                                    withKey:AVMetadataCommonKeyArtwork
                                                                   keySpace:AVMetadataKeySpaceCommon];
                
                for (AVMetadataItem *item in artworkss) {
                    if ([item.keySpace isEqualToString:AVMetadataKeySpaceID3]) {
                        
                        NSAssert([item.value isKindOfClass:NSData.class], @"???");
                        
                        NSData *imageData = (NSData *)item.value;
                        image = [UIImage imageWithData:imageData];
                        if ([image isKindOfClass:UIImage.class]) {
                            [mp3InfoDicM setObject:image forKey:MusicImage];
                        }
                        
                    } else if ([item.keySpace isEqualToString:AVMetadataKeySpaceiTunes]) {
                        image = [UIImage imageWithData:[item.value copyWithZone:nil]];
                        if ([image isKindOfClass:UIImage.class]) {
                            [mp3InfoDicM setObject:image forKey:MusicImage];
                        }
                    }
                }
            }
            
            dispatch_semaphore_signal(semap);
            
        }];
        
        dispatch_semaphore_wait(semap, DISPATCH_TIME_FOREVER);
        
        
        [musicDataArrM addObject:mp3InfoDicM];
        
        
    }
    musicDataArrM = [musicDataArrM sortedArrayUsingComparator:^NSComparisonResult(NSDictionary * _Nonnull obj1, NSDictionary *  _Nonnull obj2) {
        
        return arc4random() %2 ? NSOrderedAscending : NSOrderedDescending ;
    }].mutableCopy;

    return musicDataArrM;
}

+ (void)backgroundPlayer
{
    //设置后台任务ID
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        BOBLog(@"???系统要杀我???");
    }];
    
}

#pragma mark MusicPlay

static AVAudioPlayer *audioPlayer;
static id playDelegate;
+ (NSError *)playByMusicInfo:(NSDictionary *)musicInfo
                    delegate:(id)delegate{
    
    if (![musicInfo isKindOfClass:NSDictionary.class]) {
        BOBLog(@"数据内容错误1");
        return [NSError errorWithDomain:@"" code:0 userInfo:@{
                                                              @"msg":@"数据内容错误1"
                                                              }];
    }
    playDelegate = delegate;
    if (audioPlayer) {
        [audioPlayer stop];
        audioPlayer = nil;
    }else{
        [self configPlayerSession];
        
    }
    NSError *err = nil;
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:musicInfo[MusicUrl] error:&err];
    
    if (err) {
        BOBLog(@"声音err:%@",err);
    }
    else if(audioPlayer)
    {
        [self setMediaItemArtworkPlayingInfo:musicInfo];
        
        audioPlayer.delegate = delegate;
        audioPlayer.enableRate = YES;
        audioPlayer.numberOfLoops = 0;
        [audioPlayer play];
    }
    
    return err;
}

+ (void)configPlayerSession
{
    //设置并激活音频会话类别
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    //后台播放,与其他APP的session一同播放
    NSError *error = nil;
    [session setCategory:AVAudioSessionCategoryPlayback
//             withOptions:AVAudioSessionCategoryOptionDuckOthers//AVAudioSessionCategoryOptionMixWithOthers
                   error:&error];
    
    if(error) BOBLog(@"%@",error);//todobob,打印error崩溃？？
    
    //允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

//更新控制中心播放信息
static NSTimer *mediaItemArtworkUpdateTimer;
+ (void)setMediaItemArtworkPlayingInfo:(NSDictionary *)musicInfo
{
    NSMutableDictionary *songDict = [NSMutableDictionary dictionary];
    //歌名
    [songDict setObject:musicInfo[MusicNeme] forKey:MPMediaItemPropertyTitle];
    [songDict setObject:musicInfo[MusicAlbumName] forKey:MPMediaItemPropertyAlbumTitle];
    //歌手名
    [songDict setObject:musicInfo[MusicArtist] forKey:MPMediaItemPropertyArtist];
    //歌曲的总时间
    [songDict setObject:@(audioPlayer.duration)
      forKeyedSubscript:MPMediaItemPropertyPlaybackDuration];
    //设置歌曲图片
    UIImage *image = musicInfo[MusicImage];
    if ([image isKindOfClass:UIImage.class]) {
        MPMediaItemArtwork *imageItem = [[MPMediaItemArtwork alloc]initWithImage:image];
        [songDict setObject:imageItem forKey:MPMediaItemPropertyArtwork];
    }
    
    //设置到控制中心
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:songDict];
    
    if (!mediaItemArtworkUpdateTimer)
    {
        mediaItemArtworkUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                                       target:self
                                                                     selector:@selector(updatePlaySchedule)
                                                                     userInfo:nil
                                                                      repeats:YES];
    }
}

#pragma mark Event

/**
 恢复播放
 */
+ (void)play
{
    if (![audioPlayer isPlaying]) {
        [audioPlayer play];
        mediaItemArtworkUpdateTimer.fireDate = [NSDate date];
    }
}

/**
 暂停
 */
+ (void)suspend
{
    if ([audioPlayer isPlaying]) {
        [audioPlayer pause];
        mediaItemArtworkUpdateTimer.fireDate = [NSDate distantFuture];
    }
}


/**
 切换播放和暂停状态
 */
+ (void)delagatePlayPause
{
    if (!audioPlayer) {
        return;
    }
    if ([audioPlayer isPlaying]) {
        [self delegateSuspend];
    }else{
        [self delegatePlay];
    }
}

+ (void)delegatePlay
{
    SEL play = NSSelectorFromString(@"palyResume");
    if (![playDelegate respondsToSelector:play]) {
        return;
    }
    IMP playImp = [playDelegate methodForSelector:play];
    void (* func)(id,SEL) = (void *)playImp;
    
    func(playDelegate,play);
}

+ (void)delegateSuspend
{
    SEL suspend = NSSelectorFromString(@"playSuspend");
    if (![playDelegate respondsToSelector:suspend]) {
        return;
    }
    IMP suspendImp = [playDelegate methodForSelector:suspend];
    void(* func)(id,SEL) = (void *)suspendImp;
    func(playDelegate,suspend);
}

+ (void)delegateNaxt
{
    NSString *selStr = @"curentMusicIndex";
    SEL currentPlayIndex = NSSelectorFromString(selStr);
    if (![playDelegate respondsToSelector:currentPlayIndex]) {
        return;
    }
    IMP currentPlayIndexImp = [playDelegate methodForSelector:currentPlayIndex];
    NSInteger (* func)(id,SEL) = (void *)currentPlayIndexImp;
    NSInteger currentMusicIndex = func(playDelegate,currentPlayIndex);
    currentMusicIndex++;
    [playDelegate setValue:[NSNumber numberWithInteger:currentMusicIndex] forKey:selStr];
}

+ (void)delagatePrevious
{
    NSString *selStr = @"currentMusicIndex";
    SEL currentpPlayIndex = NSSelectorFromString(selStr);
    if (![playDelegate respondsToSelector:currentpPlayIndex]) {
        return;
    }
    IMP currentPlayIndexImp = [playDelegate methodForSelector:currentpPlayIndex];
    NSInteger (* func)(id,SEL) = (void *)currentPlayIndexImp;
    NSInteger currentMusicIndex = func(playDelegate,currentpPlayIndex);
    
    currentMusicIndex++;
    [playDelegate setValue:[NSNumber numberWithInteger:currentMusicIndex] forKey:selStr];
}

+ (AVAudioPlayer *)getPlayer
{
    return audioPlayer;
}


+ (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    
    
    if(event.type != UIEventTypeRemoteControl) return ;
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        {
            [self delegatePlay];
            
            break;
        }
            
        case UIEventSubtypeRemoteControlPause:
        {
            [self delegateSuspend];
            
            break;
        }
            
        case UIEventSubtypeRemoteControlStop:
        {
            [self delegateSuspend];
            [audioPlayer stop];
            break;
        }
            
        case UIEventSubtypeRemoteControlTogglePlayPause:
        {
            [self delagatePlayPause];
            break;
        }
            
        case UIEventSubtypeRemoteControlNextTrack:
        {
            [self delegateNaxt];
            break;
        }
            
        case UIEventSubtypeRemoteControlPreviousTrack:
        {
            [self delagatePrevious];
            break;
        }
            
        case UIEventSubtypeRemoteControlBeginSeekingBackward:
        {
            break;
        }
            
        case UIEventSubtypeRemoteControlEndSeekingBackward:
        {
            
        }
            break;
        case UIEventSubtypeRemoteControlBeginSeekingForward:
        {
            break;
        }
            
        case UIEventSubtypeRemoteControlEndSeekingForward:
        {
            break;
        }
            
        default:
        {
            
        }
            break;
    }
}

//更新控制中心歌曲播放进度
+ (void)updatePlaySchedule
{
    NSDictionary *info=[[MPNowPlayingInfoCenter defaultCenter] nowPlayingInfo];
    NSMutableDictionary *dict=[NSMutableDictionary dictionaryWithDictionary:info];
    [dict setObject:@(audioPlayer.currentTime) forKeyedSubscript:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    [[MPNowPlayingInfoCenter defaultCenter] setNowPlayingInfo:dict];
}






@end
