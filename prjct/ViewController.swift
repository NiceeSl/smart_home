//
//  ViewController.swift
//  prjct
//
//  Created by work on 23.11.2022.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    enum Kind {
        case cameras, doors
    }
    
    var Kind: Kind = .cameras
    
    @IBAction func segmentedControlChanged(_ sender: UISegmentedControl) {
        switch(segmentedControl.selectedSegmentIndex)
        {
        case 0:
            downloadJsonCameras()
            self.Kind = .cameras
            break
        case 1:
            downloadJsonDoors()
            self.Kind = .doors
            break
        default:
            break
        }
    }
    
    let urlCameras = URL(string: "http://cars.cprogroup.ru/api/rubetek/cameras/")
    let urlDoors = URL(string: "http://cars.cprogroup.ru/api/rubetek/doors/")
    var items = [Item]()
    var rooms = [String]()
    var newItem: Item?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
//        let codeSegmented = CustomSegmentedControl(frame: CGRect(x: 0, y: 50, width: self.view.frame.width, height: 50), buttonTitle: ["Камеры", "Двери"])
//        codeSegmented.backgroundColor = .clear
//        view.addSubview(codeSegmented)
        tableView?.delegate = self
        tableView?.dataSource = self
        downloadJsonCameras ()
//        tableView?.sectionHeaderHeight = 100
        tableView?.estimatedSectionHeaderHeight = 36;
    }
    
    
    func downloadJsonDoors(){
        guard let downloadURL = urlDoors else {return}
        URLSession.shared.dataTask(with: downloadURL) {data, urlResponse, error in
                guard let data = data, error == nil, urlResponse != nil else {
                    print ("something is wrong")
                    return
            }
            print("also downloaded")
            do
            {
                let decoder = JSONDecoder()
                let model = try decoder.decode(DoorResponse.self, from: data)
                self.items = model.data
                for i in self.items.indices {
                    if (self.items[i].room == nil || !self.rooms.contains(self.items[i].room!)) {
                        self.items[i].room = "OTHER"
                    }
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("wrong after dowloaded: \(error)")
            }
        }.resume()
        }
    
    func downloadJsonCameras(){
        guard let downloadURL = urlCameras else {return}
        URLSession.shared.dataTask(with: downloadURL) {data, urlResponse, error in
                guard let data = data, error == nil, urlResponse != nil else {
                    print ("something is wrong")
                    return
            }
            print("downloaded")
            do
            {
                let decoder = JSONDecoder()
                let model = try decoder.decode(CameraResponse.self, from: data)
                self.items = model.data.cameras
                self.rooms = model.data.room
                self.rooms.append("OTHER")
                for i in self.items.indices {
                    if (self.items[i].room == nil || !self.rooms.contains(self.items[i].room!)) {
                        self.items[i].room = "OTHER"
                    }
                }
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
                }
            } catch {
                print("wrong after dowloaded: \(error)")
            }
        }.resume()
        }
}


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    //SECTIONS
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return items.filter { $0.room == rooms[section]}.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return rooms.count
    }
    
    
    
    //TABLEVIEW DATA
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell") as! MyCell
        let item = getCurrentItem(indexPath: indexPath)
        cell.updateContent(item)
        
        if(item.snapshot != nil && item.rec == nil) {
            if(newItem?.lock == false) {
                cell.locker.image = UIImage(named: "lockeroff")
            }
            else {
                cell.locker.image = UIImage(named: "lockeron")
            }

            if(newItem?.hideCell == true) {
                cell.isHidden = true
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let item = getCurrentItem(indexPath: indexPath)
        let snapshot = item.snapshot
        
        if (snapshot == nil) {
            if(item.rec == nil) {
                return  90
            }
        }
        else {
            return 339
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = getCurrentItem(indexPath: indexPath)
        if (item.rec == nil && item.snapshot != nil) {
            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SecondViewController") as! SecondViewController
            vc.item = item
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else {
            print("It is not a domofon")
        }
        print("You selected cell #\(indexPath.row)!")
    }
    
    
    //HEADER
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = Bundle.main.loadNibNamed("HeaderView", owner: self , options: nil)?.first as! HeaderView
        headerView.headerLabel.text = rooms[section]
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    
    //SWIPES
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = getCurrentItem(indexPath: indexPath)
        if(item.rec != nil) {
            let edit = editAction(at: indexPath)
            let favorite = favoriteAction(at: indexPath)
            return UISwipeActionsConfiguration(actions: [edit, favorite])
        }
        else {
            let edit = editAction(at: indexPath)
            return UISwipeActionsConfiguration(actions: [edit])
        }
    }
    
    func editAction(at indexPath: IndexPath) -> UIContextualAction {
        var item = getCurrentItem(indexPath: indexPath)
        let action = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            let alertController = UIAlertController(title: "Change name", message: "Enter name", preferredStyle: .alert)
            let saveAction = UIAlertAction(title: "OK", style: .default) { (alertAction) in
                let textField = alertController.textFields![0] as UITextField
                item.name = textField.text
                self.tableView.reloadData()
                
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default)
            alertController.addTextField(configurationHandler: nil)
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        
        action.backgroundColor = .groupTableViewBackground
        action.image = UIImage(named: "edit")
        return action
    }
    
    func favoriteAction(at indexPath: IndexPath) -> UIContextualAction {
        var object = getCurrentItem(indexPath: indexPath)
        let action = UIContextualAction(style: .normal, title: "") { (action, view, completion) in
            //            self.items[indexPath.row].favorites = false
            object.favorites = !object.favorites
            self.items[indexPath.row] = object
            completion(true)
            self.tableView.reloadData()
        }
        action.backgroundColor = .groupTableViewBackground
        action.image = UIImage(named: "star")
        return action
    }
    
    func getCurrentItem(indexPath: IndexPath) -> Item {
        let currentSection = rooms[indexPath.section]
        return items.filter {$0.room == currentSection}[indexPath.row]
    }
}
    //Download API Image
    extension UIImageView {
        func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
            contentMode = mode
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard
                    let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                    let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                    let data = data, error == nil,
                    let image = UIImage(data: data)
                else { return }
                DispatchQueue.main.async() { [weak self] in
                    self?.image = image
                }
            }.resume()
        }
        func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit ) {
            guard let url = URL(string: link) else { return }
            downloaded(from: url, contentMode: mode)
        }
    }
    
