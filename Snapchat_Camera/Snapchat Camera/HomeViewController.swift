//
//  HomeViewController.swift
//  Snapchat Camera
//
//  Created by ashika shanthi on 2/17/18.
//  Copyright © 2018 ashika shanthi. All rights reserved.
//

import UIKit
import Firebase

class HomeViewController: UIViewController {
    var cameraSetup: CameraSetup!
    
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var camView: UIView!
    @IBOutlet weak var captureButton: UIButton!
    var previewImage = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
    override func viewWillAppear(_ animated: Bool) {
        previewImage = [UIImage]()
    }
    func initialize(){
        cameraSetup = CameraSetup()
        cameraSetup.captureDevice()
        cameraSetup.configureCaptureInput()
        cameraSetup.configureCaptureOutput()
        cameraSetup.configurePreviewLayer(view: camView)
    }
    @IBAction func captureAction(_ sender: Any) {
        cameraSetup.captureImage {(image, error) in
            guard let image = image else {
                print(error ?? "Image capture error")
                return
            }
            self.previewImage.append(image)
        }
    }
    
    @IBAction func doneAction(_ sender: Any) {
        self.performSegue(withIdentifier: "showPreview", sender: self)
    }
    @IBAction func cameraToggle(_ sender: Any) {
        cameraSetup.toggleCam()
    }
    @IBAction func flashToggle(_ sender: Any) {
        if cameraSetup.flashMode == .off {
            flashButton.setImage(UIImage(named: "flash_on"), for: .normal)
            cameraSetup.flashMode = .on
            
        }
        else {
            flashButton.setImage(UIImage(named: "flash_off"), for: .normal)
            cameraSetup.flashMode = .off}
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? PreviewViewController{
            destination.pImg = self.previewImage
        }
    }
}

