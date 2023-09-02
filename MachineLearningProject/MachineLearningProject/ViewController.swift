//
//  ViewController.swift
//  MachineLearningProject
//
//  Created by Berat Rıdvan Asiltürk on 2.09.2023.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // CIImage kullanmanin amaci CoreMl'de import ettigimiz MobileNetV2 modulunde image olarak CIImage kullanilmasidir. Dokumantasyondan bakabilirsin ayrintilara
    var chosenImage = CIImage()
    
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
        
        if let ciImage = CIImage(image: imageView.image!) {
            chosenImage = ciImage
        }
        
        
        recognizeImage(image: chosenImage)
    }
    // CI image kullanilarak image alinma islemi yapilir
    // Bu fonksiyon icerisinde istek olusturup bunu handle edecegiz (yani ele alacagiz)
    func recognizeImage(image: CIImage) {
        
        if let model = try? VNCoreMLModel(for: MobileNetV2().model) {
                // Request
            let request = VNCoreMLRequest(model: model) { (vnRequest, error) in
                
                // vnRequest kullanarak sonuclari alacagiz
                // VNClassificationObservation: gorsel analizi sonucunda uretilen siniflandirma
                if let results = vnRequest.results as? [VNClassificationObservation] {
                    if results.count > 0 {
                        // Ilk sonucu alarak en dogru secenegi bulacagimizi dusunuyoruz
                        let topResult = results.first
                        
                        // Yapilan islemin %'sini verir Orn: %90 benzerlikle bu sonuca ulasildi gibi
                        // Kullaniciya dispatch queue ile sonuclari gosterecegiz ve completion handler kullanacagiz
                        DispatchQueue.main.async {
                            // Tahmin edilen yuzde degeri
                            let confidenceLevel = (topResult?.confidence ?? 0) * 100
                            
                            // Yuzde icin dogru cevrim gostermede kullandik
                            let rounded = Int(confidenceLevel * 100) / 100
                            // ML buldugu sonucu ve yuzdesini yazdirir
                            self.resultLabel.text = "\(rounded)" + "%: \(topResult!.identifier) "
                        }
                        
                    }
                    
                }
                
            }
            // Completion Handler
            let handler = VNImageRequestHandler(ciImage: image)
            DispatchQueue.global().async {
                do {
                
                    try handler.perform([request])
                } catch {
                    print("Error in do catch while Handler")
                }
            }
        }
    }
}
