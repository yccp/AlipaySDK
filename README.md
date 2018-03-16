# AlipaySDK

支付宝支付 SDK ，支持手动集成以及 Cocoapods 集成方式，持续更新。

## 安装 CocoaPods

在终端输入

```
sudo gem install cocoapods
```

如果安装成功，会有一个提示

```
Successfully installed cocoaPods
```

## 使用 CocoaPods 安装 SDK

在您项目工程 `.xcodeproj` 文件同目录下创建一个名为 `Podfile` 文件。如果您尚未创建 Xcode 项目，请立即创建一个并将其保存到您的本地计算机。

在当前工程文件 `.xcodeproj` 所在文件夹下，打开 terminal。

- 创建 `Podfile`

```
touch Podfile
```

- 编辑 `Podfile` 内容

```
platform :ios, '8.0' #手机的系统
target 'YourProjectTarget' do #工程名字
  pod “AlipaySDK” #支付宝支付SDK
end   
```

- 在 `Podfile` 所在的文件夹下输入命令

```
pod install 
//这个可能比较慢，请耐心等待……
end 
```

- 导入成功，启动工程

## 升级新版 SDK

若已经安装了支付宝 iOS 支付 SDK，想要更新到最新版本，在 `Podfile` 文件的目录下使用以下命令

```
pod repo update #用于保证本地支付相关SDK为最新版 pod update   
```

## 使用 CocoaPods 的问题

`pod search` 无法搜索到类库的解决办法（找不到类库）：

- 执行 `pod setup`

- 删除 `~/Library/Caches/CocoaPods` 目录下的 `search_index.json` 文件

```
pod setup 成功后会生成~/Library/Caches/CocoaPods/search_index.json文件
终端输入rm ~/Library/Caches/CocoaPods/search_index.json
删除成功后再执行pod search
```

- 执行 `pod search`

## 使用 SDK

`import <AlipaySDK/AlipaySDK.h>` 后，在 `@implementation AppDelegate` 中以下代码中的 `NSLog` 改为实际业务处理代码。

```
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}
```

## Swift 接入 SDK

- 如果项目使用 Swift 为开发语言，需要添加桥接文件，如 `Bridging-Header.h`

- 同时，在项目 `Build Settings` 中设置桥接文件的位置

- 添加成功后，在桥接文件中写入 `#import <AlipaySDK/AlipaySDK.h>`

- 如此，在需要调用 AlipaySDK 的地方，即可直接使用，具体调用方式参照 OC

- 注意，运行时如果发生报错，在桥接文件中，写入 `#import <UIKit/UIKit.h>`

## 参考文档

App 支付 iOS 集成流程详见：[开发文档/App支付/iOS集成流程](https://docs.open.alipay.com/204/105295/)

