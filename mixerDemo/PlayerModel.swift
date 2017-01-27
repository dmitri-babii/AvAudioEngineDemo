//
//  mixerModel.swift
//  mixerDemo
//
//  Created by Dmitrii Babii on 27.01.17.
//  Copyright © 2017 Onix. All rights reserved.
//

import Foundation
import AVFoundation


class PlayerModel
{
    let engine = AVAudioEngine()
    let drumPlayer = AVAudioPlayerNode()
    let bassPlayer = AVAudioPlayerNode()
    var drumPlayerLoopBuffer:AVAudioPCMBuffer?
    var bassPlayerLoopBuffer:AVAudioPCMBuffer?
    private var _isPlaying = false
    
    var drumsVolume:Float{
        get{
            return drumPlayer.volume
        }set{
            drumPlayer.volume = newValue
        }
    }
    
    var bassVolume:Float{
        get{
            return bassPlayer.volume
        }set{
            bassPlayer.volume = newValue
        }
    }
    
    var isPlaying:Bool{
        get{
            return _isPlaying
        }
    }
    
    init() {
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayback)
            try audioSession.setActive(true)
        }catch let error{
            print(error.localizedDescription)
        }
        
        if let drumFilePath = Bundle.main.path(forResource: "amen", ofType: "m4a")
        {
            let drumLoopUrl = URL(fileURLWithPath:drumFilePath)
            do{
                
                let drumAudioFile = try AVAudioFile(forReading: drumLoopUrl)
                let drumProcessingFormat = drumAudioFile.processingFormat
                let drumFileLength = AVAudioFrameCount(drumAudioFile.length)
                drumPlayerLoopBuffer = AVAudioPCMBuffer(pcmFormat: drumProcessingFormat, frameCapacity: drumFileLength)
                try drumAudioFile.read(into: drumPlayerLoopBuffer!)
            }catch let error {
                print(error.localizedDescription)
            }
            engine.attach(drumPlayer)
        }
        
        if let bassFilePath = Bundle.main.path(forResource: "bass", ofType: "m4a"){
            let bassLoopUrl = URL(fileURLWithPath:bassFilePath )
            do {
                let bassAudionFile = try AVAudioFile(forReading: bassLoopUrl)
                let bassProcessingFormat = bassAudionFile.processingFormat
                let bassFileLength = AVAudioFrameCount(bassAudionFile.length)
                bassPlayerLoopBuffer = AVAudioPCMBuffer(pcmFormat: bassProcessingFormat, frameCapacity: bassFileLength)
                try bassAudionFile.read(into: bassPlayerLoopBuffer!)
            }catch let error {
                print(error.localizedDescription)
            }
            engine.attach(bassPlayer)
        }
        
        if let drumBuffer = drumPlayerLoopBuffer{
            engine.connect(drumPlayer, to: engine.mainMixerNode, format: drumBuffer.format)
            drumPlayer.scheduleBuffer(drumBuffer, at: nil, options: .loops, completionHandler: nil)
        }
        
        if let bassBuffer = bassPlayerLoopBuffer{
            engine.connect(bassPlayer, to: engine.mainMixerNode, format: bassBuffer.format)
            bassPlayer.scheduleBuffer(bassBuffer, at: nil, options: .loops, completionHandler: nil)
        }
        
        engine.prepare()
        
        do{
            try engine.start()
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func play(){
        
        if let drumBuffer = drumPlayerLoopBuffer{
            drumPlayer.scheduleBuffer(drumBuffer, at: nil, options: .loops, completionHandler: nil)
        }
        
        if let bassBuffer = bassPlayerLoopBuffer{
            bassPlayer.scheduleBuffer(bassBuffer, at: nil, options: .loops, completionHandler: nil)
        }

        _isPlaying = true
        drumPlayer.play()
        bassPlayer.play()
    }
    
    func stop(){
        _isPlaying = false
        drumPlayer.stop()
        bassPlayer.stop()
    }
    
    
}

