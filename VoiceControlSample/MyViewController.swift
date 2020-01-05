//
//  MyViewController.swift
//  VoiceControlSample
//
//  Created by Soojin Ro on 2020/01/03.
//  Copyright © 2020 nsoojin. All rights reserved.
//

import UIKit
import VoiceControl

class MyViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let voice = VoiceControl()
        voice.frame = CGRect(x: 50, y: 50, width: 100, height: 100)
        view.addSubview(voice)
    }
}
