//
//  ViewController.swift
//  TextRecognitionExample
//
//  Created by Paul Wiesinger on 14.08.19.
//  Copyright © 2019 Paul Wiesinger. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupImage()
        doVision()
    }

    func setupImage() {
        let url = Bundle.main.url(forResource: "image", withExtension: ".JPG")
        let data = try! Data.init(contentsOf: url!)
        imageView.image = UIImage.init(data: data)
    }
    
    func doVision() {
        let request = VNRecognizeTextRequest.init { (request, error) in
            if let error = error {
                print (error.localizedDescription)
            }
            
            var resultStr = ""
            
            for result in (request.results!) as! [VNRecognizedTextObservation] {
                result.topCandidates(1).forEach { (recognizedText) in
                    resultStr += recognizedText.string + "\n"
                    print(recognizedText.string)
                }
            }
            self.label.text = resultStr
        }
        
        request.recognitionLevel = .accurate
        //request.recognitionLanguages = ["de-de"]
        
        let requestHandler = VNImageRequestHandler.init(data: imageView.image!.pngData()!, options: [:])
        try! requestHandler.perform([request])
    }
}

