# RocketBT
 一个兼具Sever和Client角色的RocketBootstarp封装，用起来非常非常简单。
## 1.代码

### 1.1 server code

遵循三步走：

`sharedSingleton` 先初始化

`addDispatchHandler` 注册回调函数

`startServer` 开启server，完事了。


```
RocketBT* rbt = [RocketBT sharedSingleton];
[rbt addDispatchHandler:@"com.xx.ping" dispatch_handler:^(NSMutableDictionary* info) {
    return [[NSMutableDictionary alloc] init];
}];
[rbt startServer];
```

### 1.2 client code


遵循两步走:

`sharedSingleton` 先初始化

`sendMessageWithName` 发消息


```
NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
NSDictionary* ret = [[RocketBT sharedSingleton] sendMessageWithName:@"com.xx.ping" userInfo:info];
NSLog(@"rbt client send %@ recv %@", info, ret);
```


### 1.3 ping pong sample

```
// server code
RocketBT* rbt = [RocketBT sharedSingleton];
[rbt addDispatchHandler:@"com.xx.ping" dispatch_handler:^(NSMutableDictionary* info) {
 NSMutableDictionary* ret = [[NSMutableDictionary alloc] init];
    
    // 这里你可以做你想做的任何事情
    [ret setObject:@"pong" forKey:@"msg"];
    
 return ret;
}];
[rbt startServer];
// client code

NSMutableDictionary* info = [[NSMutableDictionary alloc] init];
[info setObject:@"ping" forKey:@"msg"];

NSDictionary* ret = [[RocketBT sharedSingleton] sendMessageWithName:@"com.xx.ping" userInfo:info];

NSLog(@"rbt client send %@ recv %@", info, ret);
```

## 2. 定制部分

`kTTKCenterName` 为centerName 修改为自己的即可

自己`RocketBT addDispatchHandler`添加自己的对应命令处理即可。

## 3. 注意事项：

使用前必须安装`RocketBootstrap`

Makefile 中添加`RocketBT.m` 和动态库链接, 如下：

```
SRC = src
RocketBT = $(SRC)/RocketBT
TTouchTK_FILES = $(RocketBT)/RocketBT.m


TTouchTK_LIBRARIES += rocketbootstrap
```




