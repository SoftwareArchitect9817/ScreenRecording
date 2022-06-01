//
//  ImageViewController.swift
//  ScreenRecording
//
//  Created by Zhang Xiqian on 2020/8/7.
//  Copyright © 2020 RUBY MAE Brown. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {
    @IBOutlet var img_view: UIImageView!
    var image : UIImage!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.img_view.image = image
        // Do any additional setup after loading the view.
    }
    
    @IBAction func onclick_close(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
