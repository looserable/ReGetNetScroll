# ReGetNetScroll
广告栏滚动视图的封装swift 版


# Usage
1，把AdScrollView 和 ImageDownLoad 这两个类拖入你的项目中。

2，通过如下代码即可创建一个自动循环播放的广告滚动栏: 

`//1,创建一个AdScrollview的对象
    let adView = AdScrollView(frame: CGRect(x: 0, y: 50, width: SCREEN_WIDTH, height: 180))`

  `//2,给一个数组
    adView.setImageArray(imgArry: ["https://pixabay.com/static/uploads/photo/2016/08/11/08/43/potatoes-1585060_640.jpg","https://pixabay.com/static/uploads/photo/2016/08/25/19/17/boot-1620452_640.jpg","https://pixabay.com/static/uploads/photo/2016/09/15/21/02/alpaca-167     2647_640.jpg"])`

3,oc 的项目将这两个文件拖进去的时候，可从网上查找混编的方法，应该不难。

# Attention

1,因为考虑到封装的特性，这里异步下载图片的方法也是自己封装的，而不是传说中的sdWebImage，所以目前来说，还没有考虑本地缓存的问题。

# future
1,首先完善网络图片的缓存。
2,加入是否在自动循环中，可以手动拖动的属性设置。
3，加入点击图片之后的代理方法。
