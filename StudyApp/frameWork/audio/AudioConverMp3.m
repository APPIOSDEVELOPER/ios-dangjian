//
//  AudioConverMp3.m
//  PhoneApp
//
//  Created by yaojinhai on 2017/8/18.
//  Copyright © 2017年 yaojinhai. All rights reserved.
//

#import "AudioConverMp3.h"
#import "lame.h"

@implementation AudioConverMp3

+ (NSString *)audioPCMtoMP3:(NSString *)orginPath {
    
    if (orginPath.length < 4) {
        return orginPath;
    }
    
    NSString *cafFilePath = orginPath;

    
    NSString *lastPath = orginPath.lastPathComponent;
    lastPath = [lastPath substringToIndex:[lastPath rangeOfString:@"."].location];
    
    NSString *mp3FilePath = [[orginPath stringByDeletingLastPathComponent] stringByAppendingFormat:@"/%@.mp3",lastPath];
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:mp3FilePath]){
        [fileManager removeItemAtPath:mp3FilePath error:nil];
    }
    @try {
        int read, write;
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 11025.0);
        lame_set_brate(lame, 16);
        lame_set_mode(lame, 1);
        lame_set_num_channels(lame, 2);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        return mp3FilePath;
    }
     
}


@end







