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
            
            //1.路径准备
            var image:UIImage?
            let fileName = self.getNameFromUrl(urlString: self.imageUrl!)
            let fileManager = FileManager.default
            let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
            var imgData:NSData?
            //2.判断该路径下是否存在，如果存在，直接读取。否则，先下载，然后缓存
            //拼凑完整的地址
            let path = paths.first?.appending(fileName)
            if fileManager.fileExists(atPath: path!){
                imgData   = NSData(contentsOfFile: path!)
                image     = UIImage(data: imgData as! Data)
            }else{
                var url = NSURL.init(string: self.imageUrl!)
                 imgData = NSData.init(contentsOf: url as! URL)
                if self.isCancelled == true{
                    url     = nil
                    imgData = nil
                    return
                }
                image = UIImage(data: imgData as! Data)
                //MARK:下面的方法现在返回的是Data，而data 这种类型是没有writeTofile这种方法的。
                //let pngData = UIImageJPEGRepresentation(image!, 0.5)
                do{
                    try imgData?.write(toFile: path!, options: NSData.WritingOptions.atomicWrite)
                }catch {
                    print("when write,there is something wrong")
                }

                
                
                
            }

            //时刻判断是否有取消的操作
            if self.isCancelled == true{
                image = nil
                return
            }

            if self.delegate != nil{
                let indexNum = NSNumber.init(value: self.index!)
                if image == nil{
                    print("元素：\(self.index)中的地址:\(self.imageUrl)无法取得图片")
                    return
                }
                
                let array    = [image,indexNum] as [Any]
                self.performSelector(onMainThread: #selector(passBack(array:)), with: array, waitUntilDone: true)
                
                
            }
        }
    }
    //回调放在主线程中
    func passBack(array:[Any]){
        
        let image    = array[0] as!UIImage
        let indexNum = array[1] as!NSNumber
        self.delegate?.imageDownLoadFinsishWithImage(image: image,index:indexNum.intValue)

        
    }
    
    //取出图片的名字
    func getNameFromUrl(urlString:String) -> (String){
        let arry:[String] = urlString.components(separatedBy: "/")
        let resultStr = arry.last
        
        return resultStr!
    }

    
    
}
