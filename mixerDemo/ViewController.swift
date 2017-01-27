//
//  ViewController.swift
//  mixerDemo
//
//  Created by Dmitrii Babii on 27.01.17.
//  Copyright © 2017 Onix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let model = PlayerModel()
    
    @IBOutlet weak var playButton: UIButton!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func playTapped(_ sender: Any) {
        if model.isPlaying == true {
            model.stop()
            playButton.setTitle("Play", for:.normal)
        }else{
            model.play()
            playButton.setTitle("Stop", for:.normal)
        }
    }
    

    @IBAction func drumsSliderValueChanged(_ sender: Any) {
        if let drumsSlider = sender as? UISlider
        {
            model.drumsVolume = drumsSlider.value
        }
    }
    
    @IBAction func bassSliderValueChanged(_ sender: Any) {
        if let bassSlider = sender as? UISlider {
            model.bassVolume = bassSlider.value
        }
        
    }
    
    
}

