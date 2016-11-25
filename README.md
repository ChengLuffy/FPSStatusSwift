# FPSStatusSwift
a swift-version for [JPFPSStatus](https://github.com/joggerplus/JPFPSStatus)


# 使用
---
 CocoaPods:

```
pod 'FPSStatus', '~> 0.0.2'
```

Carthage:

```
github "ChengLuffy/FPSStatusSwift"
```

开启：
```
FPSStatus.sharedInstance.open()
```
or
```
FPSStatus.sharedInstance.open { (fpsValue) in
            print(fpsValue)
        }

```

关闭：
```
FPSStatus.sharedInstance.close()
```
