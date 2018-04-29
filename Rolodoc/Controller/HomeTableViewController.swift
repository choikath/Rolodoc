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
    
    let sections =  ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var consultDictionary = [String: [ConsultRecord] ]() // store initial loaded list to restore after searches
    var searchedDictionary = [String: [ConsultRecord] ]()
    var dictionaryToLoad = [String: [ConsultRecord] ]()
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        getConsultData(url: ROLODOC_URL)
        tableView.delegate = self
        
    }



    // MARK: - Table view data source


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

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sublist = dictionaryToLoad[sections[section]] {
//            print("sublist count: \(sublist.count)")
            return sublist.count
        }
        return 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "consultCell", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "consultCell")

        if let sublist = dictionaryToLoad[sections[indexPath.section]] { //if there are values under each alphabet letter
            cell.textLabel?.text = sublist[indexPath.row].name
            cell.detailTextLabel?.text = sublist[indexPath.row].descrip
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let phoneNum = dictionaryToLoad[sections[indexPath.section]]![indexPath.row].number
//        print(phoneNum)
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

            }
        }
    }
    
    func updateConsultData(json: JSON) {
        
        for index in 0...json.count-1 {
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

        arrayToLoad = consultArray
        convertToDictionary(arrayToConvert: arrayToLoad)
        consultDictionary = dictionaryToLoad
        SVProgressHUD.dismiss()
        tableView.reloadData()
    }
    
    func convertToDictionary(arrayToConvert: Array<ConsultRecord>) {
        var tempDictionary = [String: [ConsultRecord] ]()
        for record in arrayToConvert {
            if var recordsThisLetter = tempDictionary[String(record.name.prefix(1))] {
                recordsThisLetter.append(record)
                tempDictionary[String(record.name.prefix(1))] = recordsThisLetter
            }
            else {
                tempDictionary[String(record.name.prefix(1))] = [record]
            }
        }
        //        print(consultDictionary)
        dictionaryToLoad = tempDictionary
    }
    

    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print("search bar clicked!")
        
        let allConsults = consultArray

        let filteredArray = allConsults.filter() { $0.name.localizedCaseInsensitiveContains(searchBar.text!) }
        
        convertToDictionary(arrayToConvert: filteredArray)
//        arrayToLoad = filteredArray
//        print(searchBar.text)
        searchedDictionary = dictionaryToLoad
        tableView.reloadData()

    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
//            arrayToLoad = consultArray
            dictionaryToLoad = consultDictionary
            tableView.reloadData()
            
            DispatchQueue.main.async {  // run in separate thread in foreground 'main'
                searchBar.resignFirstResponder() //nolonger be selected
                
            }
            
            
        }
    }
    
}


