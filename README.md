# 前言

苹果提供了KVO功能来让我们实现对对象属性的监控。

但是由于苹果的API非常不人性化，使用非常不方便，所以我就写了这个工具来简化KVO的实现。

感兴趣的可以加QQ群交流：70835656 (JC开源项目交流)

# 特点

* 使用方便
* 线程安全
* block作为回调
* 无须在dealloc中做清理

# 不足

目前仅支持对象类型，值类型尚不支持，如：CGRect、CGSize、NSInteger，CGFloat等。

如果需要对这些值类型进行监控，需要将其包装在`NSValue`,在进行监控。

后续版本会寻找解决方案

# 使用方式

### 对username进行监控

```
[JCObserve(self.person, username) changed:^(id newValue, id oldValue) {
        NSLog(@"\n--p.username被改变了--1，newValue = %@ oldValue=%@",newValue,oldValue);
    }];
```
JCObserve为一个宏指令，上面代码是对，self.person的username属性进行监控，当username发生变化时，block将会被执行。

### 对同一个属性多次监控

```
[JCObserve(self.person, username) changed:^(id newValue, id oldValue) {
        NSLog(@"\n--p.username被改变了--1，newValue = %@ oldValue=%@",newValue,oldValue);
    }];

    [JCObserve(self.person, username) changed:^(id newValue, id oldValue) {
        NSLog(@"\n--p.username被改变了--2，newValue = %@ oldValue=%@",newValue,oldValue);
    }];
```
同一个对象的同一个属性可以被监控多次，当属性发生变化时，所有的block将会按监控顺序一次执行。

# 安装方式

### CocoaPods

1. 在Podfile文件中添加 `pod 'JCObserver'`
2. 执行 `pod install` 或 `pod update` 命令
3. 引文头文件 `#import <JCObserver/JCObserver.h>`

### 手动安装

1. 下载JCObserver项目
2. 将JCObserver文件夹拖入到项目中
3. 引文头文件 `#import "JCObserver.h"`

# 信息反馈

* 使用中发现Bug请在Issues提出，或者邮件告知我，我将尽快修复
* 使用中有好的建议也可以在Issues提出，或邮件告知我

