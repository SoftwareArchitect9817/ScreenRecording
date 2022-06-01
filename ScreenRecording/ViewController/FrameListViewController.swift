//
//  FrameListViewController.swift
//  ScreenRecording
//
//  Created by Zhang Xiqian on 2020/8/3.
//  Copyright © 2020 RUBY MAE Brown. All rights reserved.
//

import UIKit

class FrameListViewController: UIViewController , UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    var frameArray = [UIImage]()
    var resultArray = [UIImage]()
    var stateArray = [Int]()
    
    @IBOutlet var col_frame: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        //layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        self.frameArray = GlobalData.frameArray
        self.resultArray = self.getFrameListFromOriginal(frame_array: self.frameArray)
        for index in 0..<self.resultArray.count {
            stateArray.append(0)
        }
        self.col_frame!.collectionViewLayout = layout
        self.col_frame.reloadData()
        // Do any additional setup after loading the view.
    }
    
    func getFrameListFromOriginal(frame_array: [UIImage]) -> [UIImage] {
        var result_array = [UIImage]()
        var count = 60
        if frame_array.count/GlobalData.seconds_per_frame < count {
            count = frame_array.count/GlobalData.seconds_per_frame
        }
        for index in 0..<count {
            result_array.append(frame_array[frame_array.count - index * GlobalData.seconds_per_frame - 1])
        }        
        return result_array.reversed()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FrameCell", for: indexPath) as! FrameCollectionViewCell
        cell.img_frame.image = resultArray[indexPath.row]
        if stateArray[indexPath.row] == 0 {
            cell.img_select.image = UIImage(named: "icon_uncheck")
        }else
        {
            cell.img_select.image = UIImage(named: "icon_check")
        }
        cell.btn_check.tag = indexPath.row
        cell.btn_frame.tag = indexPath.row
        cell.btn_check.addTarget(self, action: #selector(checkImage), for: .touchUpInside)
        cell.btn_frame.addTarget(self, action: #selector(tapFrame), for: .touchUpInside)
        
        cell.contentView.layer.borderColor = UIColor.gray.cgColor
        cell.contentView.layer.borderWidth  = 1
        return cell
    }
    @objc func checkImage(sender:UIButton)
    {
        stateArray[sender.tag] = 1 - stateArray[sender.tag]
        self.col_frame.reloadData()
    }
    
    @objc func tapFrame(sender:UIButton)
    {
        let image = resultArray[sender.tag]
        let main = UIStoryboard(name: "Main", bundle: nil)
        let imageVC = main.instantiateViewController(withIdentifier: "ImageViewController") as! ImageViewController
        imageVC.image = image
        self.present(imageVC, animated: true, completion: nil)        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionviewWidth = (collectionView.bounds.width - 30)/2
        return CGSize(width: collectionviewWidth, height: collectionviewWidth*1.3)
    }
    @IBAction func onclick_upload(_ sender: Any) {
        //get selected array
        var selectedArray = [UIImage]()
        for index in 0..<stateArray.count {
            if stateArray[index] == 1 {
                selectedArray.append(self.resultArray[index])
            }
        }
        if selectedArray.count == 0 {
            let alert = UIAlertController(title: "Warning", message: "Please select at least one image to create a proof", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return
        }
        
        //you can use selectedArray (it is image array)
        
        
        // remove recorded video
        do {
            try FileManager.default.removeItem(atPath: GlobalData.filePath)
        } catch let error as NSError {
            print("Error: \(error.domain)")
        }
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func onclick_cancel(_ sender: Any) {
        // remove recorded video
       do {
           try FileManager.default.removeItem(atPath: GlobalData.filePath)
       } catch let error as NSError {
           print("Error: \(error.domain)")
       }
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
