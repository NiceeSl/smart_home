//
//  WardViewController.swift
//  prjct
//
//  Created by work on 30.11.2022.
//

import UIKit

extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
            else {return}
            DispatchQueue.main.async { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
            guard let url = URL (string: link) else {return}
            downloaded(from: url, contentMode: mode)
        }
}

class WardViewController: UIViewController {
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imgLabel: UIImageView!
    
    var ward: Camera?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLbl?.text = ward?.name
        
        //guard let imgUrl = ward?.snapshot else { return  }
        
        //imgLabel!.downloaded(from: imgUrl)
        
        let imgUrl = ward?.snapshot
        if (imgUrl != nil) {
            imgLabel.downloaded(from: imgUrl!)
        }
    }
    
}
