//
//  PreviewViewController.swift
//  Snapchat Camera
//
//  Created by ashika shanthi on 2/17/18.
//  Copyright © 2018 ashika shanthi. All rights reserved.
//

import UIKit
import ImageIO
import MobileCoreServices
import Photos

class PreviewViewController: UIViewController {
    var pImg: [UIImage]!
    var timer: Timer!
    var counter = 1
    @IBOutlet weak var preview: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        preview.image = pImg[0]
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.display), userInfo: nil, repeats: true)
    }
    
    @objc func display(){
        if !(pImg.count == counter){
            preview.image = pImg[counter]
            counter += 1
        }
        else {
            counter = 0
        }
    }
    
    @IBAction func saveAction(_ sender: Any) {
        createGIF(images: pImg)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        timer.invalidate()
        dismiss(animated: true, completion: nil)
    }
}
extension PreviewViewController{
    func createGIF(images: [UIImage]){
        let fileProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFLoopCount as String: 0]]  as CFDictionary
        let frameProperties: CFDictionary = [kCGImagePropertyGIFDictionary as String: [kCGImagePropertyGIFUnclampedDelayTime as String: 0.5]] as CFDictionary
        
        let documentsDirectoryURL: URL? = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
        let fileURL: URL? = documentsDirectoryURL?.appendingPathComponent("animated.gif")
        if let url = fileURL as CFURL? {
            if let destination = CGImageDestinationCreateWithURL(url, kUTTypeGIF, images.count, nil) {
                CGImageDestinationSetProperties(destination, fileProperties)
                for image in images {
                    if let cgImage = image.cgImage {
                        CGImageDestinationAddImage(destination, cgImage, frameProperties)
                    }
                }
                if !CGImageDestinationFinalize(destination) {
                    print("Failed to finalize the image destination")
                }
                print("Url = \(fileURL!)")
            }
        }
        
        PHPhotoLibrary.shared().performChanges({
            // Request creating an asset from the image.
            PHAssetChangeRequest.creationRequestForAssetFromImage(atFileURL: fileURL!)
        })
    }
}
