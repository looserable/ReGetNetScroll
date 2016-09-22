//
//  AdScrollView.swift
//  ReGetNetScroll
//
//  Created by john on 16/9/20.
//  Copyright © 2016年 lixiaotao. All rights reserved.
//

/*
 问题描述：
    1.考虑到类的复用的便捷性，决定不使用第三方库。
    2.图片的网络请求应该是异步的，这样将来自动滚动的话就不会出现主线程堵塞的问题。
    3.尽量用3个imageView实现这个功能。
 */
import UIKit

let SCREEN_WIDTH  = Int(UIScreen.main.bounds.size.width)
let SCREEN_HEIGHT = Int(UIScreen.main.bounds.size.height)


class AdScrollView: UIView,imageDownLoadDelegate,UIScrollViewDelegate {
    var adHeight   :Int?
    var pageControl:UIPageControl?
    var timer      :Timer?
    //滚动图用来展示图片
    var scrollView    :UIScrollView?
    
    //下载的队列
    var operationQueue:OperationQueue?
    
    //当前scrollview 滚动到的位置。
    var currentIndex  :Int?

    //图片的地址数组，是数据的来源
    var imgArray      :[String]?
    
    //三个图片的对象
    var firstImageVC :UIImageView?
    var centerImageVC:UIImageView?
    var lastImageVC  :UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageArray(imgArry:[String]) {
        self.imgArray = imgArry
        self.initScrollView();
        self.initPageControl()
    }
    
    //初始化一个scrollview

    func initScrollView(){
        //初始的属性变量赋值
        self.adHeight     = Int(self.frame.size.height)
        self.currentIndex = 0;

        //1.给初始属性赋值
        self.scrollView    = UIScrollView(frame: self.frame)
        self.firstImageVC  = UIImageView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: self.adHeight!))
        self.lastImageVC   = UIImageView(frame: CGRect(x: SCREEN_WIDTH*((self.imgArray?.count)! + 1), y: 0, width: SCREEN_WIDTH, height: self.adHeight!))
        
        self.firstImageVC?.backgroundColor = UIColor.white
        self.lastImageVC?.backgroundColor  = UIColor.white
        
        //队列的初始化
        self.operationQueue              = OperationQueue.init()
        
        //scrollview的属性设置
        let count                        = self.imgArray?.count
        self.scrollView?.contentSize     = CGSize(width:SCREEN_WIDTH * (count! + 2), height: self.adHeight!)
        self.scrollView?.delegate        = self
        self.scrollView?.isPagingEnabled = true
        self.scrollView?.showsHorizontalScrollIndicator = false
        

        
        //2.将子视图添加至父视图
        self.addSubview(self.scrollView!)
        self.scrollView!.addSubview(self.firstImageVC!)
        self.scrollView!.addSubview(self.lastImageVC!)
        
        
        //3.加载图片.eg:0,1,2
        for index in 0...self.imgArray!.count - 1{
            let imgUrl = self.imgArray![index]
            let downLoad = ImageDownLoad.init(imgUrl, self as imageDownLoadDelegate,index)
            
            //downLoad.start()  这里不注释的话，之前一直报错：operation is finished and cannot be enqueued，这是因为你讲operation加入队列之后，operation会自动执行，不需要手动进行start了。
            
            //将operation 加入操作队列
            self.operationQueue?.addOperation(downLoad)
            
            let imageView = UIImageView(frame: CGRect(x: (index + 1) * SCREEN_WIDTH, y: 0, width: SCREEN_WIDTH, height: self.adHeight!))
            imageView.tag = 10000 + index;
            self.scrollView?.addSubview(imageView)
            
        }
        
        //4.最初的布局，此时焦点对准的是centerImageVC
        self.scrollView?.contentOffset = CGPoint(x: SCREEN_WIDTH, y: 0)
        
        //5.启动定时器
        self.timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in

            self.currentIndex! += 1
            self.pageControl?.currentPage = self.currentIndex!%(self.imgArray?.count)!
            
            UIView.animate(withDuration: 0.5, animations: {
                let head_offSet = Int((self.scrollView?.contentOffset.x)!)
                self.scrollView?.contentOffset = CGPoint(x: head_offSet + SCREEN_WIDTH, y: 0)//4
            })

            
            let index = Int((self.scrollView?.contentOffset.x)!)/SCREEN_WIDTH
            print(index)
            if index == 0 {
                self.scrollView?.setContentOffset(CGPoint(x: SCREEN_WIDTH * (self.imgArray?.count)!, y: 0), animated: false)
            }else if index == (self.imgArray?.count)! + 1{
                self.scrollView?.setContentOffset(CGPoint(x: SCREEN_WIDTH, y: 0),animated: false)
            }
            
        })
        
        RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
        
        
    }
    
    func initPageControl(){
        self.pageControl = UIPageControl.init(frame: CGRect(x: SCREEN_WIDTH/2 - 25, y: self.adHeight!, width: 50, height: 20))
        self.pageControl?.numberOfPages = (self.imgArray?.count)!
        self.pageControl?.pageIndicatorTintColor = UIColor.white
        self.pageControl?.currentPageIndicatorTintColor = UIColor.orange
        self.pageControl?.backgroundColor = UIColor.black
        self.addSubview(self.pageControl!);
        self.pageControl?.currentPage = 0;
    }
    
    
    /*func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let isTrue = Thread.isMainThread
        print(isTrue)
        let index = Int(scrollView.contentOffset.x)/SCREEN_WIDTH
        
        if index == 0 {
            scrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH * (self.imgArray?.count)!, y: 0), animated: false)
        }else if index == (self.imgArray?.count)! + 1{
            scrollView.setContentOffset(CGPoint(x: SCREEN_WIDTH, y: 0),animated: false)
        }
        self.pageControl?.currentPage = Int((self.scrollView?.contentOffset.x)!)/SCREEN_WIDTH - 1 % (self.imgArray?.count)!
        
    }*/
    
    
    
    func imageDownLoadFinsishWithImage(image:UIImage,index:Int){
        

        let imageVC = self.scrollView?.viewWithTag(10000+index) as! UIImageView
        imageVC.image = image
        
        if index == 0 {
            self.lastImageVC?.image = image
        }else if index == (self.imgArray?.count)! - 1{
            self.firstImageVC?.image = image
        }
    }
}

