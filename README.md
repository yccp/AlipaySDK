# AlipaySDK

支付宝支付 SDK ，SDK 已适配 iPhoneX，支持 IPv6_only 网络和 ATS 安全标准，支持手动集成以及 Cocoapods 集成方式，持续更新。

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
  pod “AlipaySDK_MI” #支付宝支付SDK
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

## iOS 调用说明

> 接口名称：AlipaySDK
> 
> 接口描述：提供支付功能。

Alipay 接口主要为商户提供订单支付功能。接口所提供的方法，如下表所示：


| 方法名称 | 方法描述 |
| :-- | :-- |
| +(Alipay *)defaultService; | 获取服务实例。 |
| -(void)payOrder:(NSString *)orderStr fromScheme:(NSString *)schemeStr callback:(CompletionBlock)completionBlock; | 支付并通过回调返回结果。 |
| -(void)processOrderWithPaymentResult:(NSURL*)resultUrl standbyCallback:(CompletionBlock)completionBlock; | 处理支付宝客户端返回的 url（在 app 被杀模式下，通过这个方法获取支付结果）。 |

快捷订单支付 iOS

> 方法名称：pay 方法

> 方法原型：(void)payOrder:(NSString )orderStr fromScheme:(NSString )schemeStr callback:(CompletionBlock)completionBlock;

> 方法功能：提供给商户快捷订单支付功能。


| 参数名称 | 参数描述 |
| :-- | :-- |
| NSString* scheme | 商户程序注册的 URL protocol，供支付完成后回调商户程序使用 |
| (CompletionBlock)completionBlock | 快捷支付开发包回调函数，返回免登、支付结果。本地未安装支付宝客户端，或未成功调用支付宝客户端进行支付的情况下（走 H5 收银台），会通过该 completionBlock 返回支付结果。 |
| NSString* orderString | app 支付请求参数字符串，主要包含商户的订单信息，key=value 形式，以&连接。 |


处理客户端返回 url

> 方法名称：处理客户端方法

> 方法原型：-(void)processOrderWithPaymentResult:(NSURL*)resultUrl standbyCallback:(CompletionBlock)completionBlock;

> 方法功能：设备已安装支付宝客户端情况下，处理支付宝客户端返回的 url。


| 参数名称 | 参数描述 |
| :-- | :-- |
| NSURL *resultUrl | 支付宝客户端回传的 url |
| CompletionBlock completionBlock | 本地安装了支付宝客户端，且成功调用支付宝客户端进行支付的情况下，会通过该 completionBlock 返回支付结果 |


回调接口

在支付过程结束后，会通过 callbackBlock 同步返回支付结果（callbackBlock 是调用支付同步的回调）。支付结果中参数的提取，必须通过 CompletionBlock 获取，禁止开发者私自解析支付结果返回的 URL。

## 出现 UTDID 冲突

已集成阿里云旺，或者之前已集成友盟应用统计 UMCSecurityPlugins 安全组件，现在集成支付宝支付，导入 AlipaySDK.framework 就发生链接错误，如下所示：

```
Showing Recent Issues
Ld /Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/ZZYBotClient.app/ZZYBotClient normal arm64
    cd /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient
    export IPHONEOS_DEPLOYMENT_TARGET=10.0
    export PATH="/Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/usr/bin:/Applications/Xcode.app/Contents/Developer/usr/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin"
    /Applications/Xcode.app/Contents/Developer/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang++ -arch arm64 -isysroot /Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS11.2.sdk -L/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos -L/Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/BaiduMapKit/BaiduMapKit/thirdlibs -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/AFNetworking -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/Charts -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/FMDB -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/IQKeyboardManager -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/LBXScan -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/LCActionSheet -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/MJExtension -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/MJRefresh -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/MKDropdownMenu -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/Masonry -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/PGDatePicker -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/PGPickerView -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/RTRootNavigationController -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/Reachability -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/SAMKeychain -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/SDWebImage -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/SKTagView -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/SVProgressHUD -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/TZImagePickerController -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/XHWebImageAutoSize -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/YYKit -F/Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/pop -F/Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK -F/Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/BaiduMapKit/BaiduMapKit -F/Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCAnalytics -F/Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCCommon -F/Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCErrorCatch -F/Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties -filelist /Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Intermediates.noindex/ZZYBotClient.build/Debug-iphoneos/ZZYBotClient.build/Objects-normal/arm64/ZZYBotClient.LinkFileList -Xlinker -rpath -Xlinker @executable_path/Frameworks -Xlinker -rpath -Xlinker @loader_path/Frameworks -Xlinker -rpath -Xlinker @executable_path/Frameworks -miphoneos-version-min=10.0 -dead_strip -Xlinker -object_path_lto -Xlinker /Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Intermediates.noindex/ZZYBotClient.build/Debug-iphoneos/ZZYBotClient.build/Objects-normal/arm64/ZZYBotClient_lto.o -Xlinker -export_dynamic -Xlinker -no_deduplicate -fobjc-arc -fobjc-link-runtime -stdlib=libc++ -ObjC -lc++ -lcrypto -lsqlite3 -lsqlite3.0 -lssl -lz -framework AFNetworking -framework AlipaySDK -framework BaiduMapAPI_Base -framework BaiduMapAPI_Cloud -framework BaiduMapAPI_Location -framework BaiduMapAPI_Map -framework BaiduMapAPI_Radar -framework BaiduMapAPI_Search -framework BaiduMapAPI_Utils -framework CFNetwork -framework Charts -framework CoreGraphics -framework CoreLocation -framework CoreMotion -framework CoreTelephony -framework CoreText -framework FMDB -framework Foundation -framework IQKeyboardManager -framework LBXScan -framework LCActionSheet -framework MJExtension -framework MJRefresh -framework MKDropdownMenu -framework Masonry -framework OpenGLES -framework PGDatePicker -framework PGPickerView -framework QuartzCore -framework RTRootNavigationController -framework Reachability -framework SAMKeychain -framework SDWebImage -framework SKTagView -framework SVProgressHUD -framework Security -framework SecurityEnvSDK -framework SystemConfiguration -framework TZImagePickerController -framework UIKit -framework UMAnalytics -framework UMCommon -framework UMErrorCatch -framework UTDID -framework XHWebImageAutoSize -framework YYKit -framework pop -framework CoreTelephony -framework AdSupport -framework Pods_ZZYBotClient -Xlinker -dependency_info -Xlinker /Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Intermediates.noindex/ZZYBotClient.build/Debug-iphoneos/ZZYBotClient.build/Objects-normal/arm64/ZZYBotClient_dependency_info.dat -o /Users/myfolders/Library/Developer/Xcode/DerivedData/ZZYBotClient-alqhouatlrvwfqdxglbrmmnqsdoc/Build/Products/Debug-iphoneos/ZZYBotClient.app/ZZYBotClient

duplicate symbol _OBJC_CLASS_$_UTDIDAES in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDAES.o)
duplicate symbol _OBJC_METACLASS_$_UTDIDAES in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDAES.o)
duplicate symbol _OBJC_CLASS_$_UTDIDBaseUtils in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDBaseUtils.o)
duplicate symbol _OBJC_METACLASS_$_UTDIDBaseUtils in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDBaseUtils.o)
duplicate symbol _OBJC_CLASS_$_AidRequester in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(AidRequester.o)
duplicate symbol _OBJC_METACLASS_$_AidRequester in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(AidRequester.o)
duplicate symbol _OBJC_CLASS_$_AidManager in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(AidManager.o)
duplicate symbol _OBJC_METACLASS_$_AidManager in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(AidManager.o)
duplicate symbol _OBJC_CLASS_$_UTDIDIntUtils in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDIntUtils.o)
duplicate symbol _OBJC_METACLASS_$_UTDIDIntUtils in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDIntUtils.o)
duplicate symbol _OBJC_CLASS_$_UTDIDStringUtils in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDStringUtils.o)
duplicate symbol _OBJC_METACLASS_$_UTDIDStringUtils in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDStringUtils.o)
duplicate symbol _OBJC_CLASS_$_UTDIDTypeConvert in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDTypeConvert.o)
duplicate symbol _OBJC_METACLASS_$_UTDIDTypeConvert in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDTypeConvert.o)
duplicate symbol _OBJC_CLASS_$_UTDIDMain in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDMain.o)
duplicate symbol _OBJC_METACLASS_$_UTDIDMain in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDMain.o)
duplicate symbol _OBJC_CLASS_$_UTDIDOpenUDID in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDOpenUDID.o)
duplicate symbol _OBJC_METACLASS_$_UTDIDOpenUDID in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDOpenUDID.o)
duplicate symbol _OBJC_CLASS_$_UTDIDHelper in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDHelper.o)
duplicate symbol _OBJC_METACLASS_$_UTDIDHelper in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDHelper.o)
duplicate symbol _OBJC_CLASS_$_AidStorage in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(AidStorage.o)
duplicate symbol _OBJC_METACLASS_$_AidStorage in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(AidStorage.o)
duplicate symbol _OBJC_CLASS_$_UTDevice in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDevice.o)
duplicate symbol _OBJC_METACLASS_$_UTDevice in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDevice.o)
duplicate symbol _OBJC_IVAR_$_UTDIDKeychainItemWrapper.genericPasswordQuery in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDKeychainItemWrapper.o)
duplicate symbol _OBJC_CLASS_$_UTDIDKeychainItemWrapper in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDKeychainItemWrapper.o)
duplicate symbol _OBJC_METACLASS_$_UTDIDKeychainItemWrapper in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDKeychainItemWrapper.o)
duplicate symbol _OBJC_IVAR_$_UTDIDKeychainItemWrapper.keychainItemData in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDKeychainItemWrapper.o)
duplicate symbol _OBJC_CLASS_$_UTDIDPersistentConf in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDPersistentConf.o)
duplicate symbol _OBJC_METACLASS_$_UTDIDPersistentConf in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDPersistentConf.o)
duplicate symbol _OBJC_CLASS_$_UTDIDPersistentFile in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDPersistentFile.o)
duplicate symbol _OBJC_METACLASS_$_UTDIDPersistentFile in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDPersistentFile.o)
duplicate symbol _OBJC_CLASS_$_UTDIDGTMBase64 in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDGTMBase64.o)
duplicate symbol _OBJC_METACLASS_$_UTDIDGTMBase64 in:
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/AlipaySDK_MI/AlipaySDK/AlipaySDK.framework/AlipaySDK
    /Users/myfolders/Downloads/Zhiziyun/ZZYBotClient/ZZYBotClient/Pods/UMCSecurityPlugins/thirdparties/UTDID.framework/UTDID(UTDIDGTMBase64.o)
ld: 34 duplicate symbols for architecture arm64
clang: error: linker command failed with exit code 1 (use -v to see invocation)
```

AlipaySDK_No_UTDID，支付宝支付 SDK ，适用于集成了百川 SDK，出现 UTDID 冲突：[caosuyang/AlipaySDK_No_UTDID](https://github.com/caosuyang/AlipaySDK_No_UTDID)。

## 参考文档

App 支付 iOS 集成流程详见：[开发文档/App支付/iOS集成流程](https://docs.open.alipay.com/204/105295/)

## 许可 License

支付宝支付 SDK 是在 [MIT 的许可](https://github.com/caosuyang/AlipaySDK/blob/master/LICENSE)下发布的。

