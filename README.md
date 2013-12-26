TCWeiboSDK-LightVersion

广告一下，升级版SDK 已经发布，功能更强大，更稳定，地址：https://github.com/heloyue/TCWeiboSDK

轻量级腾讯微博SDK for iOS

Tencent Weibo SDK LightVersion for iOS

1. 实现了腾讯微博oauth2.a 授权，SSO授权
2. 实现了 腾讯微博授权续期功能
3. 实现了腾讯微博最基础的请求接口，可以通过此接口快速封装出openapi请求


ps ： 静态库提供了3个版本，通用版（支持arm7，arm7s，i386，模拟器，真机都支持，demo引用此库），arm版（支持arm7，arm7s的真机），x86版（支持i386的模拟器）

注意事项：
1. SSO授权时，应用图标是由SDK从本app中的plist文件中读取 “Icon files” 字段所指的图片传给微博客户端，请务必设置此字段。
2. SSO授权完成后，回调第三方应用时，标识应用来源的SourceApplication 参数，可能是大写，也可能是是小写。如果需要通过此字段判断来源，请务必做好大小写兼容。
