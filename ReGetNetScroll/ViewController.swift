//
//  ViewController.swift
//  ReGetNetScroll
//
//  Created by john on 16/9/20.
//  Copyright © 2016年 lixiaotao. All rights reserved.
//

import UIKit

class ViewController: UIViewController,touchAdImageDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //1,创建一个AdScrollview的对象
        let adView = AdScrollView(frame: CGRect(x: 0, y: 50, width: SCREEN_WIDTH, height: 180))
        
        //2,设置手动滚动有效果 值得注意的是，设置可以滑动的话一定要设置在数组赋值之前
        adView.scroEnable = true

        //3,给一个数组
        adView.setImageArray(imgArry: ["https://pixabay.com/static/uploads/photo/2016/08/11/08/43/potatoes-1585060_640.jpg","https://pixabay.com/static/uploads/photo/2016/08/25/19/17/boot-1620452_640.jpg","https://pixabay.com/static/uploads/photo/2016/09/15/21/02/alpaca-1672647_640.jpg"])
        
        
        //4,设置代理
        adView.delegate = self
        
        self.view.addSubview(adView)
        
    }
    
    func touchAdImage(atIndex index: Int) {
        print("index = \(index)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

