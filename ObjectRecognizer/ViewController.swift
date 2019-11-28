//
//  ViewController.swift
//  ObjectRecognizer
//
//  Created by Mihnea Stefan on 28/11/2019.
//  Copyright © 2019 Mihnea Stefan. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBOutlet weak var galleryButton: UIButton!
    @IBOutlet weak var imageInput: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
          cameraButton.addTarget(self, action : #selector(cameraAction), for : .touchUpInside)
              galleryButton.addTarget(self, action : #selector(galleryAction), for : .touchUpInside)
        
    }
    
        func imagePickerController(_ picker : UIImagePickerController, didFinishPickingMediaWithInfo info : [UIImagePickerController.InfoKey : Any]){ // functie responsabila de adaugarea pozelor facute/selectate in UIImage
           
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imageInput.image = image
            
            guard let ciimage = CIImage(image : image) else{
                fatalError("Conversia nu s-a putut face (UIImage > CIImage")
            }
            validateContentsOfImage(image : ciimage)
        
            
            dismiss(animated : true, completion : nil)
        }
                
    }
    
    func validateContentsOfImage(image : CIImage){
        guard let model = try? VNCoreMLModel(for : foodsterModel().model) else{
            fatalError("model nefunctional")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
                guard let results = request.results as? [VNClassificationObservation] else{
                    fatalError("Modelul nu a putut procesa imaginea")
                }

            if let firstResult = results.first{
                self.navigationItem.title = "\(firstResult.identifier)"
            }
            
        }
        let handler = VNImageRequestHandler(ciImage : image)
        try! handler.perform([request])
    }

    @objc func cameraAction(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker ,animated : true, completion : nil)
    }
    
    @objc func galleryAction(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated : true, completion : nil)
    }
    
    
    
}

