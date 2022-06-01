//
//  ViewController.swift
//  ScreenRecording
//
//  Created by Zhang Xiqian on 2020/7/29.
//  Copyright © 2020 RUBY MAE Brown. All rights reserved.
// Bundle.main.bundleIdentifier!

import UIKit
@_exported import ReplayKit
import AVKit
import SWCombox

class ViewController: UIViewController ,SWComboxViewDelegate, SWComboxViewDataSourcce{

    @IBOutlet var combox_seconds: SWComboxView!
    @IBOutlet var containerView: UIView!
    @IBOutlet var btn_view: UIButton!
    let broadcastPickerView = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.btn_view.layer.cornerRadius = 20
        self.btn_view.layer.masksToBounds = true
        self.btn_view.isHidden = true
        
//        let broadcastPickerView = RPSystemBroadcastPickerView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.containerView.addSubview(broadcastPickerView)
        broadcastPickerView.preferredExtension = "com.kcm.ScreenRecording1.Extension"
        broadcastPickerView.backgroundColor = .red
        
//        broadcastPickerView.showsMicrophoneButton = false
        
        if let button = broadcastPickerView.subviews.first as? UIButton {
            button.imageView?.tintColor = UIColor.white
        }
        self.containerView.layer.cornerRadius = 25
        self.containerView.layer.masksToBounds = true
        
        let darwinNotificationCenter = DarwinNotificationsManager.sharedInstance()
        darwinNotificationCenter!.register(forNotificationName: "uploadVideoSuccess") {
            print("recording is finished")
            self.processVideo()
        }
        self.combox_seconds.delegate = self
        self.combox_seconds.dataSource = self
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let manager = FileManager.default
        if manager.fileExists(atPath: GlobalData.filePath){
            self.btn_view.isHidden = false
        }else{
            self.btn_view.isHidden = true
        }
    }
    
    func processVideo() {
        let manager = FileManager.default
        if manager.fileExists(atPath: GlobalData.filePath){
            self.btn_view.isHidden = false
        }else{
            self.btn_view.isHidden = true
        }
    }
    
//combox delegate
    func comboxSelected(atIndex index:Int, object: Any, combox withCombox: SWComboxView) {
        GlobalData.seconds_per_frame = index + 1
        print("\(GlobalData.seconds_per_frame)")
    }

    func comboxOpened(isOpen: Bool, combox: SWComboxView) {
       
    }
    
// combox datasource
    func comboBoxSeletionItems(combox: SWComboxView) -> [Any] {
        return ["Take a photo every 1 seconds", "Take a photo every 2 seconds", "Take a photo every 3 seconds", "Take a photo every 4 seconds", "Take a photo every 5 seconds"]
    }
    func comboxSeletionView(combox: SWComboxView) -> SWComboxSelectionView {
        return SWComboxTextSelection()
    }
    func configureComboxCell(combox: SWComboxView, cell: inout SWComboxSelectionCell) {
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.gray.withAlphaComponent(0.1)
    }
    
    
    
    @IBAction func view_recordedVideo(_ sender: Any) {
        let manager = FileManager.default
        if !manager.fileExists(atPath: GlobalData.filePath){
           print("recording file is not exist")
            return
        }
        
        let videoUrl = URL.init(fileURLWithPath: GlobalData.filePath)
        let asset = AVAsset(url: videoUrl)
        let imgGenerator = AVAssetImageGenerator(asset: asset)
        
        let duration = asset.duration
        let durationTime = Int(CMTimeGetSeconds(duration))
        
        var frameArray = [UIImage]()
        for index in 0...durationTime {
            do {
                let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: Int64(index), timescale: 1),  actualTime: nil)
                let frameImage = UIImage(cgImage: cgImage)
                frameArray.append(frameImage)
            } catch {
                print("Failed")
            }
        }
        GlobalData.frameArray = frameArray        
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let recordVC = main.instantiateViewController(withIdentifier: "FrameListViewController") as! FrameListViewController
        self.present(recordVC, animated: true, completion: nil)
    }    
}

