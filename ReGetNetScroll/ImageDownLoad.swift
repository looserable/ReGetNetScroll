//
//  ImageDownLoad.swift
//  ReGetNetScroll
//
//  Created by john on 16/9/20.
//  Copyright © 2016年 lixiaotao. All rights reserved.
//

import UIKit

protocol imageDownLoadDelegate {
    
    //下载完成后的回调方法将UIImage的对象传出去
    func imageDownLoadFinsishWithImage(image:UIImage,index:Int)
}
//图片下载类
class ImageDownLoad: Operation {
    //图片的地址
    var imageUrl:String?
    
    //图片在数组中的位置
    var index:Int?
    
    //图片下载的代理
    var delegate:imageDownLoadDelegate?
    
    override init() {
        super.init()
    }
    
    //添加的初始化的方法
    init(_ imgUrl:String,_ delegate:imageDownLoadDelegate, _ index:Int) {
        self.imageUrl = imgUrl
        self.delegate = delegate
        self.index    = index
    }
    
    override func main() {
        autoreleasepool {
            //图片的操作放到这里面
            
            
            if self.isCancelled == true{
                return
            }
            
            var url = NSURL.init(string: self.imageUrl!)
            var imgData = NSData.init(contentsOf: url as! URL)
            if self.isCancelled == true{
                url     = nil
                imgData = nil
                return
            }
            
            var image = UIImage(data: imgData as! Data)
            if self.isCancelled == true{
                image = nil
                return
            }

            if self.delegate != nil{
                let indexNum = NSNumber.init(value: self.index!)
                if image == nil{
                    print(self.imageUrl)
                    return
                }
                let array    = [image,indexNum] as [Any]
                
                self.performSelector(onMainThread: #selector(passBack(array:)), with: array, waitUntilDone: true)
            }
        }
    }
    
    func passBack(array:[Any]){
        
        let image    = array[0] as!UIImage
        let indexNum = array[1] as!NSNumber
        self.delegate?.imageDownLoadFinsishWithImage(image: image,index:indexNum.intValue)

    }
    
    
}
