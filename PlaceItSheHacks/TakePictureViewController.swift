//
//  TakePictureViewController.swift
//  PlaceIt
//
//  Place It on 2020-01-11.
//  Copyright © 2020 Place It. All rights reserved.
//

//  Code modified from:
//  CatProfileViewController.swift
//  Snapcat
//
//  Created by Sai Kambampati on 8/21/19.
//  Copyright © 2019 AppCoda. All rights reserved.
//

import Foundation

import UIKit
import VisionKit
import Vision

class TakePictureViewController: UIViewController, VNDocumentCameraViewControllerDelegate {

    
    var textRecognitionRequest = VNRecognizeTextRequest()
    var recognizedText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
      
        
        textRecognitionRequest = VNRecognizeTextRequest(completionHandler: { (request, error) in
            if let results = request.results, !results.isEmpty {
                if let requestResults = request.results as? [VNRecognizedTextObservation] {
                    
                    self.recognizedText = ""
                    for observation in requestResults {
                        guard let candidiate = observation.topCandidates(1).first else { return }
                        self.recognizedText += candidiate.string
                        
                        
                    
                    let sbMain : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let placeDetailsVC = sbMain.instantiateViewController(withIdentifier: "PlaceDetails") as! PlaceDetailsViewController
                        
                    placeDetailsVC.place = self.recognizedText
                    
                    self.navigationController?.pushViewController(placeDetailsVC, animated: true)
                    
                    
                    
                    }
                   //print(self.recognizedText)
                }
            }
            
            
            
            
        })
        textRecognitionRequest.recognitionLevel = .accurate
        textRecognitionRequest.usesLanguageCorrection = false
        textRecognitionRequest.customWords = ["@gmail.com", "@outlook.com", "@yahoo.com", "@icloud.com"]
    }
    
    @IBAction func scanDocument(_ sender: Any) {
        // Use VisionKit to scan business cards
        let documentCameraViewController = VNDocumentCameraViewController()
        documentCameraViewController.delegate = self
        self.present(documentCameraViewController, animated: true, completion: nil)
    
        
    }
    
    func documentCameraViewController(_ controller: VNDocumentCameraViewController, didFinishWith scan: VNDocumentCameraScan) {
        let image = scan.imageOfPage(at: 0)
        let handler = VNImageRequestHandler(cgImage: image.cgImage!, options: [:])
        do {
            try handler.perform([textRecognitionRequest])
        } catch {
            print(error)
        }
        controller.dismiss(animated: true)
    }
}
