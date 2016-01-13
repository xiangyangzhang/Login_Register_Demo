//
//  LZXHttpDownload.h
//  SNSDemo
//
//  Created by xyz on 15/9/21.
//  Copyright (c) 2015年 xyz. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 我们的app往往 很多界面都需要 进行下载数据，这时我们可以利用封装性对 下载进一步的封装，哪个界面需要下载那么我们就直接创建封装好的下载对象就可以了
 //当前类 只负责 下载数据,不知道怎么处理处理，界面是需要处理数据,这时 下载对象可以 委托 界面 进行处理数据
 //代理设计模式
 1.通过协议规范代理的行为
 2.block 回调
 */

// A 委托 B 处理事情  A主动 B被动
// 在A 中 回调 B的方法
//
/*
 1.先定义 block 的类型 (在 回调 block 的类中进行定义(主动方写))
 2.在哪里调用block(回调) -》主动方写
 3.实现block 代码块 传给 主动方 -》在被动方写
 */

//定义block 类型  ->调用block的时候 通过 参数 把数据传给对方
typedef void (^DownloadBlock)(NSData *downloadData);
//下载失败的block 类型
typedef void (^ErrorBlock)(NSError *error);


@interface LZXHttpDownload : NSObject <NSURLConnectionDataDelegate>
{
    //下载连接请求
    NSURLConnection *_httpRequest;
}

//保存下载数据
@property (nonatomic,strong) NSMutableData *downloadData;
//保存block 必须要用copy  --》不copy 传入的block 代码块可能会释放
@property (nonatomic,copy) DownloadBlock successBlock;

@property (nonatomic,copy) ErrorBlock errorBlock;

//封装一个函数 通过url 进行下载 并且 把一个block 代码块 传入
//get请求
- (void)downloadDataWithUrl:(NSString *)urlStr successBlock:(DownloadBlock)block failedBlock:(ErrorBlock)errorBlock;

//post请求
//url 地址 + 提交的参数
- (void)postDataWithUrl:(NSString *)urlStr
                 params:(NSString *)paramStr
                success:(DownloadBlock)successBlock
            failedBlock:(ErrorBlock)errorBlock;


@end








