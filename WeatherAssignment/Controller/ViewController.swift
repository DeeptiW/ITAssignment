//
//  ViewController.swift
//  WeatherAssignment
//
//  Created by Deepti Walde on 22/05/18.
//  Copyright © 2018 Deepti Walde. All rights reserved.
//

import UIKit
import CoreData
import SVProgressHUD




//MARK:- Controller Class
class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        managedContext = appDelegate?.persistentContainer.viewContext
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 44
        fetchFromCoreData(completion: {_ in
            if fetchDetails.count > 0{
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }else{
                callApis(completion: {_ in
                    self.tableView.reloadData()
                })
            }
        })
        
        
        DispatchQueue.main.async {
            Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { timer in
                if checkInternet() {
                    callApis(completion: {_ in
                        self.tableView.reloadData()
                    })
                } else{
                    self.present(showAlertForNoInternet(), animated: true, completion: nil)
                }
            }
        }
    }
    
  
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"", style:.plain, target:nil, action:nil)
    }
    
}



//MARK:- Table View
extension ViewController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchDetails.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CustomCell
        let weather = fetchDetails[indexPath.row]
        cell.backgroundColor = UIColor.clear
        cell.name.text = weather.value(forKeyPath: "name") as? String
        cell.temp.text = "\(weather.value(forKeyPath: "temp") as? String ?? "NA")°C"
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        detailViewController.fetchDetails = fetchDetails[indexPath.row]
        self.navigationController?.pushViewController(detailViewController, animated: true)
    }
}




