# YHGetNetPictureSize ![](http://pfile.cn/px0r3c)
##免完全下载获取网络链接图片大小尺寸的工具
####在 pod 中集成方法
	在 Podfile 文件中添加:

		pod 'YHGetNetPictureSize'
	
	执行 pod install 命令
####使用方法

```
	// 使用如下方法获取（提醒：当前为同步加载）
   +(CGSize)getImageSizeWithURL:(id)imageURL;
```

![](http://pfile.cn/rmye0j)