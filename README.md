StarlingFeathers
================

整合Starling+Feathers 还有一些Starling扩展

Starling源码的优化

1.关闭Enterframe事件。
	starling本身会每一帧遍历所有对象派发enterframe事件。如果对象很多效率自然下降。
	改用starling.events.EnterFrameManager统一管理无需每帧遍历所有对象。
	注册enterframe事件的方式不变。
2.VertexData优化。
	mRawData改为bytearray上传数据速度提升.
3.为DisplayObjectContainer添加了3个方法
	addQuiackChild()快速添加子对象
	removeQuickChild()快速移除子对象
	clearChild()一键清理子对象
	使用上面3个方法都不会派发ADD_TO_STAGE,REMOVE_FROME_STAGE事件。当平凡添加和移除子对象时效率可大大提升.
4.使用跳帧策略.
	当任务繁忙的时候渲染部分主动丢帧。
					
应用级别优化

1.简化starling创建流程.
	程序主类继承STLStarup
	Starling入口类继承STLMainClass
	主类中调用
	```actionscript
	
	initStarlingWithWH
	initStarling
	
	```
	进行初一键初始化自动适应屏幕大小。具体效果请运行查看

2.封装了一部分手势
	lzm.starling.gestures包
	
3.添加动态纹理
	lzm.starling.texture.DynamicTextureAtlas
	可以很好的优化drw数量。底层是renderTexture

4.添加一些自定义组建
	lzm.starling.display
	DistortImage，DistortImageContainer四角拉伸图片可拉升的图片
	ImageViewer类似于手机上的图片查看器
	ScrollContainer,ScrollContainerItem优化过的feathers滚动面板
	BaseScene通用场景 做手游比较试用.
	
	其他。。。