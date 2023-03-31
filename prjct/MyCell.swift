//
//  WardViewController.swift
//  prjct
//
//  Created by work on 04.12.2022.
//

import UIKit

class MyCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var playbuttonImg: UIImageView!
    @IBOutlet weak var recImg: UIImageView!
    @IBOutlet weak var favoriteImg: UIImageView!
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var locker: UIImageView!
    @IBOutlet weak var alphaScreenImage: UIImageView!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0))
    }
    var newItem: Item?
    
    func updateContent(_ model: Item) {
        if(model.snapshot != nil ) {
            let url = URL(string: model.snapshot!)
            img?.downloaded(from: url!, contentMode: .scaleToFill)
            img.isHidden = false
            alphaScreenImage.isHidden = false
        }
        else {
            img.isHidden = true
            alphaScreenImage.isHidden = true
        }
        nameLbl.text = model.name
        
        if (model.rec != nil) {
            recImg?.isHidden = model.rec == false
            favoriteImg?.isHidden = model.favorites == false
        }
        else {
            recImg.isHidden = true
            favoriteImg.isHidden = true
        }
        
        if(model.rec == nil) {
            locker.image = UIImage(named: "lockeron")
        }
        else{
            locker.image = nil
        }
        isHidden = false
    }
}


@IBDesignable extension UIView {
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
              layer.cornerRadius = newValue

              // If masksToBounds is true, subviews will be
              // clipped to the rounded corners.
              layer.masksToBounds = (newValue > 0)
        }
    }
}



