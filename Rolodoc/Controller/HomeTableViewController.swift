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
import SwipeCellKit
import ChameleonFramework

protocol ModalHandler {
    func modalDismissed()
}

class HomeTableViewController: UITableViewController, UISearchBarDelegate, ModalHandler {

    let defaults = UserDefaults.standard
    let modalVC = EntityPickerViewController()

    let ROLODOC_URL = "http://www.pennrolodoc.com/listings.json"
    var consultJsonRef = JSON() // saves full initial loaded json so can be refiltered when new entity selected.
    var consultArray = [ConsultRecord]()  // saves initial loaded list
    var arrayToLoad = [ConsultRecord]() // used to toggle load between initial full list, or sublist of search results
    
    var hospitalSelected: String = "HUP"
    
    let sections =  ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var consultDictionary = [String: [ConsultRecord] ]() // store initial loaded list to restore after searches
    var searchedDictionary = [String: [ConsultRecord] ]()
    var dictionaryToLoad = [String: [ConsultRecord] ]()

//    var currentIndexPath = IndexPath(row: 0, section: 0)
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        getConsultData(url: ROLODOC_URL)
//        defaults.set("HUP", forKey: "defaultHospital")
        tableView.delegate = self
        tableView.rowHeight = 80.0
        
        
        // dismiss keyboard if click anywhere else on screen
        let tap = UITapGestureRecognizer(target: self.view, action: Selector("endEditing:"))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)

    }

    // Code to play sound with scroll
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if (scrollView.isTracking == true || scrollView.isDragging == true) {
//             print("scrolling with indexpath: \(currentIndexPath)")
//            // Find the indexPath of the cell at the center of the tableview
//            var tableViewCenter = self.tableView.center
//            tableViewCenter = self.tableView.convert(tableViewCenter, from: self.tableView.superview)
//            var centerCellIndexPath = tableView.indexPathForRow(at: tableViewCenter)
//            print(centerCellIndexPath)
//            // "Tick" if the cell at the center of the table has changed
//            if (centerCellIndexPath != self.currentIndexPath)
//            {
//                NSLog("Tick");
//                self.currentIndexPath = centerCellIndexPath!;
//            }
//
//        }
//    }


    // MARK: - Table view data source


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 26
    }
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return self.sections as [String]
    }
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        return index
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if self.tableView(tableView, numberOfRowsInSection: section) == 0 { return nil }
        return self.sections[section] as String
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sublist = dictionaryToLoad[sections[section]] {
//            print("sublist count: \(sublist.count)")
            return sublist.count
        }
        
        return 0
        
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "consultCell", for: indexPath) as! SwipeTableViewCell
        
//        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "consultCell") as! SwipeTableViewCell
        cell.delegate = self
        
        if let sublist = dictionaryToLoad[sections[indexPath.section]] { //if there are values under each alphabet letter
            cell.textLabel?.text = sublist[indexPath.row].name
            cell.detailTextLabel?.text = sublist[indexPath.row].descrip
        }
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let phoneNum = dictionaryToLoad[sections[indexPath.section]]![indexPath.row].number
////        print(phoneNum)
//        if let url = URL(string: "tel://\(phoneNum)"), UIApplication.shared.canOpenURL(url) {
//            if #available(iOS 10, *) {
//                UIApplication.shared.open(url)
//            } else {
//                UIApplication.shared.openURL(url)
//            }
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }


    //Write the getConsultData method here:
    func getConsultData(url: String) {
        
        Alamofire.request(url, method: .get).responseJSON {  // makes the request in the background asynchronously
            response in
            if response.result.isSuccess {
                print("Success! Got the consult data")
                
                let consultJSON : JSON = JSON(response.result.value!) // swiftyjson functionality to wrap into json format.
                self.consultJsonRef = consultJSON
                self.updateConsultData(json: consultJSON)  // self refers to this current class, because this block has closure, but trying to call a method outside the current function
                
                
            }
            else {
                print("Error \(String(describing: response.result.error))")

            }
        }
    }
    
    func updateConsultData(json: JSON) {
        
        // Check whether default has ever been set using picker, otherwise fall back on HUP
        if isKeyPresentInUserDefaults(key: "defaultHospital") {
            hospitalSelected = defaults.string(forKey: "defaultHospital")!
        } else { hospitalSelected = "HUP" }
        
        consultArray = []
        for index in 0...(json.count-1) {
            let consultItem = ConsultRecord()
            
            //filter list by entity
            //check that entity is contained either in hospital, description, or name of service....
            if json[index]["hosp"].stringValue == hospitalSelected  ||
                json[index]["descrip"].stringValue.lowercased().range(of: hospitalSelected.lowercased()) != nil ||
                json[index]["name"].stringValue.lowercased().range(of: hospitalSelected.lowercased()) != nil {
                
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
        searchBar.resignFirstResponder()
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
    
    
    //MARK: Functions to link entity picker modal and this view controller -- sets self as delegate so that entity selected can be linked to a reload of list.
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToEntityPicker" {
            let modal = segue.destination as! EntityPickerViewController
            modal.delegate = self
        }
        
        if segue.identifier == "goToTextPage" {
            let modal = segue.destination as! TextPageViewController
            modal.delegate = self
            modal.consultNum = "614-397-2666"
        }
    }
    
// called at completion of "save" button being pressed in entity picker modal, prompts reload of new filtered list by new entity
    func modalDismissed() {
        updateConsultData(json: consultJsonRef)
    }
    

    
    //check if no default hospital has yet been set -- so can fallback on "HUP" in updateConsultData method
    func isKeyPresentInUserDefaults(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    
    
    @IBAction func endEditing(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
}

//MARK: Swipe Cell Delegate Methods

extension HomeTableViewController: SwipeTableViewCellDelegate {
//    public static var selection: SwipeExpansionStyle
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let textpageAction = SwipeAction(style: .default, title: "TextPage") { action, indexPath in
            // handle action by updating model with seletion
            
            self.performSegue(withIdentifier: "goToTextPage", sender: self)
            }
        
        
        let callAction = SwipeAction(style: .default, title: "Call") { action, indexPath in
            // handle action by updating model with seletion
            
            let phoneNum = self.dictionaryToLoad[self.sections[indexPath.section]]![indexPath.row].number
            //        print(phoneNum)
            if let url = URL(string: "tel://\(phoneNum)"), UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        
        let favoriteAction = SwipeAction(style: .default, title: "Favorite") { action, indexPath in
            // handle action by updating model with deletion
            print("this is my favorite!")
        }
        
        // customize the action appearance
        textpageAction.image = UIImage(named: "text-icon")
        textpageAction.backgroundColor = UIColor.flatYellowColorDark()
        
        callAction.image = UIImage(named: "phone-icon")
        callAction.backgroundColor = UIColor.flatRed()
        
        favoriteAction.image = UIImage(named: "star-icon")
        favoriteAction.backgroundColor = UIColor.flatMagenta()
        
        return [textpageAction, callAction, favoriteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeTableOptions {
        var options = SwipeTableOptions()
//        options.expansionStyle = .default
        options.transitionStyle = .border
        return options
    }
    
//    func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
//        if (segue.identifier == "goToTextPage") {
//            // pass data to next view
//            
//        }
//    }
}

