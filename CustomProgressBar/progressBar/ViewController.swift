//
//  ViewController.swift
//  progressBar
//
//  Created by ashika shanthi on 1/4/18.
//  Copyright © 2018 ashika shanthi. All rights reserved.
//

import UIKit
class ViewController: UIViewController {
    
    @IBOutlet weak var progressBar: ProgressBarView!
    var timer: Timer!
    var progressCounter:Float = 0
    let duration:Float = 10.0
    var progressIncrement:Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressIncrement = 1.0/duration
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.showProgress), userInfo: nil, repeats: true)
    }
    
    @objc func showProgress()
    {
        if(progressCounter > 1.0){timer.invalidate()}
        progressBar.progress = progressCounter
        progressCounter = progressCounter + progressIncrement
    }
}

