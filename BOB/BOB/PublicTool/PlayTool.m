//
//  PlayTool.m
//  BOB
//
//  Created by 汲群英 on 2018/9/10.
//  Copyright © 2018年 qunyingji. All rights reserved.
//

#import "PlayTool.h"

#import <AVFoundation/AVFoundation.h>


NSString *MusicNeme = @"musicNeme";//歌名
NSString *MusicUrl = @"musicUrl";//路径(NSURL)
NSString *MusicAlbumName = @"musicAlbumName";//专辑名称
NSString *MusicArtist = @"musicArtist";//艺术家
NSString *MusicImage = @"musicImage";//专辑封面(UIImage)

@interface PlayTool()

@end

@implementation PlayTool

+ (void)turnOnBackgroundProcessingMultimediaEvents
{
    //设置并激活音频会话类别
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    //后台播放
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    //允许应用程序接收远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    //这样做，可以在按home键进入后台后 ，播放一段时间，几分钟吧。但是不能持续播放网络歌曲，若需要持续播放网络歌曲，还需要申请后台任务id，具体做法是：
    [self backgroundPlayer];
    //其中的_bgTaskId是后台任务UIBackgroundTaskIdentifier _bgTaskId;
}

+ (void)backgroundPlayer
{
    //设置后台任务ID
    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"???系统要杀我???");
    }];
    //    [UIApplication sharedApplication].backgroundTimeRemaining
    
}

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
        [mp3InfoDicM setObject:title forKey:MusicNeme];//歌曲名
        [mp3InfoDicM setObject:artist forKey:MusicArtist];//艺术家
        [mp3InfoDicM setObject:albumName forKey:MusicAlbumName];//专辑名
        
        
        // Load the asset's "playable" key
        NSString *infoKey = @"playable";
        dispatch_semaphore_t semap = dispatch_semaphore_create(0);
        
        
        [asset loadValuesAsynchronouslyForKeys:@[infoKey] completionHandler:^{
            
            
            NSError *error;
            AVKeyValueStatus status = [asset statusOfValueForKey:infoKey error:&error];
            if (error) {
                NSLog(@"%@",error);
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
    
    
    //                         sortedArrayUsingComparator:^NSComparisonResult(NSDictionary * _Nonnull obj1, NSDictionary *  _Nonnull obj2) {
    //
    //                             int randomInt = arc4random() %2;
    //                             return randomInt ? [obj1[@"name"] compare:obj2[@"name"]] : [obj2[@"name"] compare:obj1[@"name"]] ;
    //                         }]
    
    
    
    
    return musicDataArrM;
}















@end
