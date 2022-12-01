//
//  ViewController.swift
//  prjct
//
//  Created by work on 23.11.2022.
//

import UIKit

final class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let url = URL(string: "http://cars.cprogroup.ru/api/rubetek/cameras/")            //api segment  "Cameras"
    var wards = [Camera]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        downloadJson()
        tableView.tableFooterView = UIView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func downloadJson(){
        self.tableView.reloadData()
        wards = []
        guard let downloadURL = url else {return}       // try to get url
        URLSession.shared.dataTask(with: downloadURL) {data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {      // data availability check, if error - return
                print ("something is wrong")
                return
        }
        print("downloaded")
        do
        {
            let decoder = JSONDecoder()
            let cameras = try decoder.decode(CameraResponse.self, from: data)
            DispatchQueue.main.async {
            }
            print(cameras)
        } catch {
            print("wrong after dowloaded: \(error)")
        }
    }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? WardViewController {
            destination.ward = wards[tableView.indexPathForSelectedRow!.row]
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wards.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: nil)
        let ward = wards[indexPath.row]
        cell.textLabel?.text = ward.name
        return cell
    }
}
