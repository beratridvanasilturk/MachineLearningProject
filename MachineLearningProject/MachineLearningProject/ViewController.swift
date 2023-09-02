//
//  ViewController.swift
//  MachineLearningProject
//
//  Created by Berat Rıdvan Asiltürk on 2.09.2023.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func changeButtonTapped(_ sender: Any) {
        
        // picker ile image cektik galeriden veya kameradan
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        present(picker, animated: true)
    }
    
    // Image cekildikten sonra ne yapilacagini duzenler
    // Kullanici image'i bir kere sectikten sonra ne yapilacagini duzenleriz
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // image'i info ile cast ederek degistiririz
        imageView.image = info[.originalImage] as? UIImage
        // dismiss edip kapatarak kendine tekrar donmemize saglar
        self.dismiss(animated: true)
        
        
        
        
    }
    
}

