//
//  SampleHandler.swift
//  Extension
//
//  Created by Zhang Xiqian on 2020/7/29.
//  Copyright © 2020 RUBY MAE Brown. All rights reserved.
//

import ReplayKit
@_exported import Photos

class SampleHandler: RPBroadcastSampleHandler {

    
    var writer: AVAssetWriter!
    var videoInput: AVAssetWriterInput!
    var audioInput: AVAssetWriterInput!
    
    let filePath  = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.cybertonic.FavSearch")!.path + "/Library/Caches/temp.mp4"
    var lastSampleBuffer: CMSampleBuffer?
    
    
    
    override func broadcastStarted(withSetupInfo setupInfo: [String : NSObject]?) {
        print("broadcastStarted")
        initWriter()
    }
    
    override func broadcastPaused() {
        // User has requested to pause the broadcast. Samples will stop being delivered.
    }
    
    override func broadcastResumed() {
        // User has requested to resume the broadcast. Samples delivery will resume.
    }
    
    override func broadcastFinished() {
        
        if writer.status != .writing {
            return
        }
        
        videoInput.markAsFinished()
        audioInput.markAsFinished()
        print("writer.status0 = \(writer.status.rawValue)")
        if let lastSampleBuffer = lastSampleBuffer {
            writer.endSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(lastSampleBuffer))
        }
        
        let thread = CMThread.init()
        
        writer.finishWriting { [weak self] in
            
            print("status1 === \(self?.writer.status.rawValue ?? 10086)")
            print("finishWriting handler")
            self?.writer = nil
            let notification = CFNotificationCenterGetDarwinNotifyCenter()
            CFNotificationCenterPostNotification(notification, CFNotificationName.uploadVideoSuccess, nil, nil, true)
            thread.interrupt()
        }
        if !thread.isInterrup {
            let _ = thread.sleep(milliseconds: 3000)
        }
                
    }
    
    override func processSampleBuffer(_ sampleBuffer: CMSampleBuffer, with sampleBufferType: RPSampleBufferType) {
        
        guard let _ = writer else {
            return
        }
        
        if writer.status == .unknown && sampleBufferType == .video {
            writer.startWriting()
            writer.startSession(atSourceTime: CMSampleBufferGetPresentationTimeStamp(sampleBuffer))
        }
        if writer.status == .failed {
            print("Error occured, status = \(writer.status.rawValue), \(writer.error!.localizedDescription) \(String(describing: writer.error))")
            return
        }
        
        switch sampleBufferType {
            case RPSampleBufferType.video:
                
                if videoInput.isReadyForMoreMediaData {
                    if videoInput.append(sampleBuffer) {
                        print("videoInput append sampleBuffer")
                        lastSampleBuffer = sampleBuffer
                    } else {
                        print("videoInput append sampleBuffer failed")
                    }
                }
                
                break
            case RPSampleBufferType.audioApp:
                // Handle audio sample buffer for app audio
                break
            case RPSampleBufferType.audioMic:
                // Handle audio sample buffer for mic audio
                
                if audioInput.isReadyForMoreMediaData {
                    print("audioInput append sampleBuffer")
                    audioInput.append(sampleBuffer)
                }
                break
        @unknown default:
            fatalError()
        }
    }
}

extension SampleHandler {
    
    func initWriter() {
        
        if writer == nil {
            do {
                do {
                    try FileManager.default.removeItem(atPath: filePath)
                } catch {
                    print("remove item error = \(error)")
                }
                try writer = AVAssetWriter.init(outputURL: .init(fileURLWithPath: filePath), fileType: .mp4)
            } catch  {
                fatalError("Assetwriter error : \(error)")
            }

            let widthRemainder = UIScreen.main.bounds.size.width.truncatingRemainder(dividingBy: 16)
            let heightRemainder = UIScreen.main.bounds.size.height.truncatingRemainder(dividingBy: 16)
            
            let videoSettings: [String: Any] = [
                AVVideoCodecKey: AVVideoCodecType.h264,
                AVVideoWidthKey: UIScreen.main.bounds.size.width + widthRemainder,
                AVVideoHeightKey: UIScreen.main.bounds.size.height + heightRemainder
            ]
            videoInput = AVAssetWriterInput.init(mediaType: .video, outputSettings: videoSettings)
            videoInput.expectsMediaDataInRealTime = true
            if writer.canAdd(videoInput) {
                writer.add(videoInput)
                print("add video input")
            } else {
                print("can not add video input")
            }
            
            let audioSettings: [String: Any] = [
                AVFormatIDKey: kAudioFormatMPEG4AAC,
                AVNumberOfChannelsKey: 2,
                AVSampleRateKey: 44100,
                AVEncoderBitRateKey: 64000
            ]
            audioInput = AVAssetWriterInput.init(mediaType: .audio, outputSettings: audioSettings)
            audioInput.expectsMediaDataInRealTime = true
            if writer.canAdd(audioInput) {
                writer.add(audioInput)
                print("add audio input")
            } else {
                print("can not add audio input")
            }
        }
    }
}


// MARK: - TimeStamp
extension SampleHandler {

    var timeStamp : String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let timeStamp = Int(timeInterval)
        return "\(timeStamp)"
    }

    var milliStamp : String {
        let timeInterval: TimeInterval = Date().timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
}
