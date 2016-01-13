# Login_Register_Demo
##iOS开发  登陆 注册 demo

---
 A 委托 B 处理事情  A主动 B被动
 
 在A 中 回调 B的方法

- 1.先定义 block 的类型 (在 回调 block 的类中进行定义(主动方写))
- 2.在哪里调用block(回调) -》主动方写
- 3.实现block 代码块 传给 主动方 -》在被动方写

###LZXHttpDownload.h
 
 ``` 
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
 ```

###LZXHttpDownload.m
```
#import "LZXHttpDownload.h"

@implementation LZXHttpDownload
- (instancetype)init {
    if (self = [super init]) {
        //创建空对象
        self.downloadData = [[NSMutableData alloc] init];
    }
    return self;
}
//下载的时候把 block代码 提前传入
- (void)downloadDataWithUrl:(NSString *)urlStr successBlock:(DownloadBlock)block failedBlock:(ErrorBlock)errorBlock {
    
    if (_httpRequest) {
        //取消以前的下载
        [_httpRequest cancel];
        _httpRequest = nil;
    }
    //要立即保存block
    self.successBlock = block;
    self.errorBlock = errorBlock;
    
    //url请求
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    //异步下载请求连接
    _httpRequest = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    //一旦创建就会立即异步下载
    //每次下载 都要重新 创建 新的连接请求
}

#pragma mark - post
- (void)postDataWithUrl:(NSString *)urlStr params:(NSString *)paramStr success:(DownloadBlock)successBlock failedBlock:(ErrorBlock)errorBlock {
    if (_httpRequest) {
        [_httpRequest cancel];
        _httpRequest = nil;
    }
    self.successBlock = successBlock;
    self.errorBlock = errorBlock;
    //可变的请求
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    //设置请求方式默认是get
    request.HTTPMethod = @"POST";
    
    //设置请求头
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //转化为NSData 格式是参数拼接的格式
    NSData *data = [paramStr dataUsingEncoding:NSUTF8StringEncoding];
    
    //请求体的数据 长度
    [request addValue:[NSString stringWithFormat:@"%ld",data.length] forHTTPHeaderField:@"Content-Length"];
    
    //提交 参数 --》参数拼接的数据格式
    //请求体部分
    request.HTTPBody = data;
    //发送请求 建立连接
    _httpRequest =[[NSURLConnection  alloc] initWithRequest:request delegate:self];
}

//接收到响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //把之前的数据 清空
    self.downloadData.length = 0;
}
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    //拼接 下载的数据
    [self.downloadData appendData:data];
}
//下载完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    //下载完成 之后 通知回调block
    if (self.successBlock) {
        //回调block
        self.successBlock(self.downloadData);
    }else {
        NSLog(@"block没有传入");
    }
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"下载失败");
    //下载失败 通知block
    if (self.errorBlock) {
        self.errorBlock(error);
    }
}

@end

```
