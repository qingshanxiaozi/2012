//
//  ViewController.swift
//  faceDetection
//
//  Created by Sakhti Subitshah Murugan on 10/26/17.
//  Copyright © 2017 Sakhti Subitshah Murugan. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    var imageView = UIImageView()
    var image = UIImage()
    var imageHeight:CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(imageView)
        imageView.contentMode = .scaleAspectFit
        let firstImage = UIImage(named:"1")
        addImage(image: firstImage!)
        
    }
    
    func addImage(image:UIImage){
        print("Entering into addImage block")
        imageView.removeFromSuperview()
        imageHeight = view.frame.width/image.size.width * image.size.height
        imageView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: imageHeight)
        imageView.image = image
        view.addSubview(imageView)
    }

    @IBAction func didChange(_ sender: Any) {
        guard let button = sender as? UIButton else { return }
        let tag = button.tag
        image = UIImage(named:"\(tag)")!
        imageHeight = view.frame.width/image.size.width * image.size.height
        addImage(image: image)
        
    }
    @IBAction func detectFace(_ sender: Any) {
        guard let imageToDetect = imageView.image else {return}
        let request = VNDetectFaceRectanglesRequest.init { (request, error) in
            if let error = error{
                print (error)
            }
            if let result = request.results as? [VNFaceObservation]{
                for faceObservation in result{
                    print(faceObservation.boundingBox)
                    DispatchQueue.main.async {
                        let imageRect = self.imageView.frame
                        let boundingbox = faceObservation.boundingBox
                        let x = boundingbox.origin.x * imageRect.width
                        let width = boundingbox.size.width * imageRect.width
                        let height = boundingbox.size.height * imageRect.height
                         let y = (1-boundingbox.origin.y ) * imageRect.height - height
                        
                        let faceView = UIView(frame:CGRect(x: x, y: y, width: width, height: height))
                        faceView.backgroundColor = .orange
                        faceView.alpha = 0.5
                        faceView.layer.cornerRadius = 15
                        faceView.clipsToBounds = true
                        faceView.layer.borderColor = UIColor.darkGray.cgColor
                        faceView.layer.borderWidth = 1.5
                        self.view.addSubview(faceView)
                        
                    }
                }
            }
        }
                guard let cgImage = imageToDetect.cgImage else {return}
                
                DispatchQueue.global().async {
                    let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
                    do{
                        try handler.perform([request])
                    }catch{
                        print(error)
                    }
                }
                
            }
        }

    


