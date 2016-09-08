//
//  ContentViewController.swift
//  FoodApp
//
//  Created by LUOHao on 16/6/13.
//  Copyright © 2016年 1000phone. All rights reserved.
//

import UIKit

class ContentViewController: UIViewController {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var introLabel: UILabel!
    @IBOutlet weak var introImageView: UIImageView!
    @IBOutlet weak var okButton: UIButton!
    
    var index = 0
    var heading = ""
    var imageName = ""
    var intro = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        okButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        headingLabel.text = heading
        introLabel.text = intro
        introImageView.image = UIImage(named: imageName)
    }
    
    @IBAction func okButtonClicked(sender: AnyObject) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(true, forKey: "hasWalked")
    }
}
