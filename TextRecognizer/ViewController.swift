//
//  ViewController.swift
//  TextRecognizer
//
//  Created by Maximiliano Morales on 27/04/2022.
//

import UIKit
import Vision

class ViewController: UIViewController {
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.backgroundColor = .blue
        label.textColor = .white
        label.text = "Starting..."
        return label
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cbu")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        view.addSubview(imageView)
        
        recognizeText(image: imageView.image)

    }
    
    override func viewWillLayoutSubviews() {
        super.viewDidLayoutSubviews()

        imageView.frame = CGRect(x: 20,
                                 y: view.safeAreaInsets.top,
                                 width: view.frame.size.width-40,
                                 height: view.frame.size.width-40)
        
        label.frame = CGRect(x: 20,
                             y: view.frame.size.width + view.safeAreaInsets.top,
                             width: view.frame.size.width-40,
                             height: 200)
        label.layer.cornerRadius = 10
        label.layer.masksToBounds = true
        
    }
    
    private func recognizeText(image: UIImage?){

        // converting image into CGImage
        guard let cgImage = image?.cgImage else {
            fatalError("No se pudo convertir la imagen")
        }

        // creating request with cgImage
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])

        // request
        let request = VNRecognizeTextRequest { [weak self] request , error in
            guard let observations = request.results as? [VNRecognizedTextObservation],
                  error == nil else {
                return
            }

            let text = observations.compactMap({
                $0.topCandidates(1).first?.string
            }).joined(separator: ", ")

            DispatchQueue.main.async {
                self?.label.text = text
            }
        }

        do {
            try handler.perform([request])
        }
        catch {
            label.text = "\(error)"
        }
    }

}

