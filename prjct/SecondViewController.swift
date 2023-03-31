//
//  SecondViewController.swift
//  prjct
//
//  Created by work on 11.01.2023.
//

import UIKit

class SecondViewController: UIViewController {
    
    @IBOutlet weak var keyButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var eyeView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenView: UIImageView!
    @IBOutlet weak var labelTranslyacia2: UILabel!
    @IBOutlet weak var labelTranslyacia: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var keyView: UIView!
    
    @IBAction func keyAction(_ sender: UIButton) {
        
        self.item?.lock = false//!(self.item?.lock!)!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            guard let viewController = storyboard.instantiateViewController(identifier: "ViewController") as? ViewController else { return }
            viewController.newItem = item
            viewController.newItem?.hideCell = false
            show(viewController, sender: nil)
        } else {
            print("Update software")
        }
        print("openned")
    }
    
    @IBAction func hideCellAction(_ sender: UIButton) {
        self.item?.hideCell = true //!(self.item?.hideCell!)!
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            guard let viewController = storyboard.instantiateViewController(identifier: "ViewController") as? ViewController else { return }
            viewController.newItem = item
            show(viewController, sender: nil)
        } else {
            print("Update software")
        }
        print("hidden")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        item?.hideCell = false

    }
    
    var item: Item?
}

