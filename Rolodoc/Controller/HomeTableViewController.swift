//
//  HomeTableViewController.swift
//  Rolodoc
//
//  Created by Katherine Choi on 4/27/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreData
import SVProgressHUD

class HomeTableViewController: UITableViewController, UISearchBarDelegate {

    let ROLODOC_URL = "http://www.pennrolodoc.com/listings.json"

    var consultArray = [ConsultRecord]()
    var arrayToLoad = [ConsultRecord]()
    var hospitalSelected = "HUP"  // save settings into plist
    
    let sections =  ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getConsultData(url: ROLODOC_URL)
        tableView.delegate = self
    }



    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 26
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sections as? [String]
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section] as? String
    }
    */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayToLoad.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "consultCell", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "consultCell")

//        cell.textLabel?.text = consultArray[indexPath.row]["serviceName"]
        cell.textLabel?.text = arrayToLoad[indexPath.row].name
        cell.detailTextLabel?.text = arrayToLoad[indexPath.row].descrip

        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let phoneNum = arrayToLoad[indexPath.row].number
        print(phoneNum)
        if let url = URL(string: "tel://\(phoneNum)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }


    //Write the getConsultData method here:
    func getConsultData(url: String) {
        
        Alamofire.request(url, method: .get).responseJSON {  // makes the request in the background asynchronously
            response in
            if response.result.isSuccess {
                print("Success! Got the consult data")
                
                let consultJSON : JSON = JSON(response.result.value!) // swiftyjson functionality to wrap into json format.
                self.updateConsultData(json: consultJSON)  // self refers to this current class, because this block has closure, but trying to call a method outside the current function
                
                
            }
            else {
                print("Error \(response.result.error)")
//                self.cityLabel.text = "Connection Issues"
            }
        }
    }
    
    func updateConsultData(json: JSON) {
        
        for index in 1...json.count {
            let consultItem = ConsultRecord()
            

            if json[index]["hosp"].stringValue == hospitalSelected {
            consultItem.name = json[index]["name"].stringValue    //swiftyjson made this simpler to parse JSON.  we're optional binding
                consultItem.descrip = json[index]["descrip"].stringValue
                consultItem.number = json[index]["num"]["number"].stringValue
                if consultItem.number != "" {
                    consultArray.append(consultItem)
                }
            }
        }
        
//            consultArray[consultName] = phoneNum
//
//            consultDataModel.name = json["name"].stringValue
//            consultDataModel.number = json["num"]["number"].stringValue
        
//        else {
//            print ("error updating data")
////            cityLabel.text = "Weather Unavailable"
//        }
        arrayToLoad = consultArray
        tableView.reloadData()
    }
    
    

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print("search bar clicked!")
        let allConsults = consultArray
        SVProgressHUD.show()
        let filteredArray = allConsults.filter() { $0.name.localizedCaseInsensitiveContains(searchBar.text!) }
        
        arrayToLoad = filteredArray
//        print(searchBar.text)
        tableView.reloadData()
        SVProgressHUD.dismiss()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            arrayToLoad = consultArray
            tableView.reloadData()
            
            DispatchQueue.main.async {  // run in separate thread in foreground 'main'
                searchBar.resignFirstResponder() //nolonger be selected
                
            }
            
            
        }
    }
    
}


