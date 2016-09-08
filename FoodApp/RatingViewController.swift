//
//  RatingViewController.swift
//  FoodApp
//
//  Created by LUOHao on 16/6/6.
//  Copyright © 2016年 1000phone. All rights reserved.
//

import UIKit

class RatingViewController: UIViewController {
    
    let ratings = ["dislike", "good", "great"]

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingStackView: UIStackView!
    
    var model: Cafe!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 通过仿射变换给三个按钮的UIStackView添加一个缩放动画
        let trans1 = CGAffineTransformMakeScale(0, 0)
        let trans2 = CGAffineTransformMakeTranslation(0, 500)
        // 叠加两个仿射变换的效果
        ratingStackView.transform = CGAffineTransformConcat(trans1, trans2)
        
        // 创建一个模糊效果(毛玻璃)对象
        let blurEffect = UIBlurEffect(style: .Dark)
        // 创建一个视觉效果视图并应用上面的模糊效果
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        // 设置视觉效果视图的大小和位置
        blurEffectView.frame = self.view.bounds
        // 将视觉效果视图添加到UIImageView上面
        photoImageView.addSubview(blurEffectView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        photoImageView.image = model.photo
        
        // 通过UIView的方法设置视图上的动画
        UIView.animateWithDuration(1.2, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.2, options: [], animations: { () -> Void in
                // 清除仿射变换产生的效果
                self.ratingStackView.transform = CGAffineTransformIdentity
            }, completion: nil)
    }
    
    @IBAction func close(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func selectRating(sender: UIButton) {
        model.rating = ratings[sender.tag - 200]
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
