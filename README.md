# FPSStatusSwift
a swift-version for [JPFPSStatus](https://github.com/joggerplus/JPFPSStatus)

# 安装
```
pod 'FPSStatusSwift'
```

# 使用
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
