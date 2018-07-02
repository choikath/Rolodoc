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
import Drift

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
    
    let sections =  ["Cx", "A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
    var consultDictionary = [String: [ConsultRecord] ]() // store initial loaded list to restore after searches
    var searchedDictionary = [String: [ConsultRecord] ]()
    var dictionaryToLoad = [String: [ConsultRecord] ]()
    var selectedRecord = ConsultRecord()
    var consultsOnly = [String: [ConsultRecord] ]() // store items with 'consult' in name to pin to top
//    var currentIndexPath = IndexPath(row: 0, section: 0)
    
    @IBOutlet weak var NewButton: UIBarButtonItem!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SVProgressHUD.show()
        getConsultData(url: ROLODOC_URL)
//        defaults.set("HUP", forKey: "defaultHospital")
        tableView.delegate = self
        tableView.rowHeight = 70.0
        
        
        // dismiss keyboard if click anywhere else on screen
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(HomeTableViewController.endEditing(_:)))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        Drift.load()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NewButton.addBadge(number: 1)
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
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "consultCell", for: indexPath) as! SwipeTableViewCell
        
//        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "consultCell") as! SwipeTableViewCell
        cell.delegate = self
        
        if let sublist = dictionaryToLoad[sections[indexPath.section]] { //if there are values under each alphabet letter
            cell.textLabel?.text = sublist[indexPath.row].name
            cell.detailTextLabel?.text = sublist[indexPath.row].descrip
//            cell.phoneNum.text = sublist[indexPath.row].number
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath {
        self.selectedRecord = self.dictionaryToLoad[self.sections[indexPath.section]]![indexPath.row]
        return indexPath
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
//                print(consultItem.descrip)
                    consultItem.number = json[index]["num"]["number"].stringValue
                    consultItem.consultant = json[index]["num"]["consultant"].stringValue
                    consultItem.instruc = json[index]["num"]["instruc"].stringValue
                    print(json[index]["num"]["instruc"])
                    consultItem.last_updated = json[index]["last_updated"].stringValue
                
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
        
        // Pull out all with 'consult' in title to pin to top
        let filteredArray = arrayToConvert.filter() { $0.name.localizedCaseInsensitiveContains("consult") }
        tempDictionary["Cx"] = filteredArray
        
        
        // Create alphabetized dictionary into first letter sections
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
//            print("textpage sender :  + \(sender)")
            // sender is a homeview controller instance
            
            let navVC = segue.destination as! UINavigationController
            let modal = navVC.viewControllers.first as! TextPageViewController
            modal.delegate = self
            modal.consultRecord = selectedRecord

        }
        
        if segue.identifier == "goToBananas" {
            let modal = segue.destination as! WhatsHot
            modal.delegate = self
        }
    }
    
// called at completion of "save" button being pressed in entity picker modal, prompts reload of new filtered list by new entity
    func modalDismissed() {
        updateConsultData(json: consultJsonRef)
    }
    
    func clearBadgeOnClose() {
        NewButton.removeBadge()
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
            // handle action by updating model with selection
            
            self.selectedRecord = self.dictionaryToLoad[self.sections[indexPath.section]]![indexPath.row]
            
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
        textpageAction.backgroundColor = UIColor(hexString: "7BB342")
        
        callAction.image = UIImage(named: "phone-icon")
        callAction.backgroundColor = UIColor(hexString: "C0CB33")
        
//        favoriteAction.image = UIImage(named: "star-icon")
//        favoriteAction.backgroundColor = UIColor(hexString: "E4C441")
        
        return [textpageAction, callAction]
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
//            let destinationVC = segue.destination as! ToDoListViewController
//
//            if let indexPath = messageTableView.indexPathForSelectedRow {
//                destinationVC.selectedCategory = categoryArray?[indexPath.row]
//            }
//        }
    
}
extension CAShapeLayer {
    func drawCircleAtLocation(location: CGPoint, withRadius radius: CGFloat, andColor color: UIColor, filled: Bool) {
        fillColor = filled ? color.cgColor : UIColor.white.cgColor
        strokeColor = color.cgColor
        let origin = CGPoint(x: location.x - radius, y: location.y - radius)
        path = UIBezierPath(ovalIn: CGRect(origin: origin, size: CGSize(width: radius * 2, height: radius * 2))).cgPath
    }
}

private var handle: UInt8 = 0

extension UIBarButtonItem {
    private var badgeLayer: CAShapeLayer? {
        if let b: AnyObject = objc_getAssociatedObject(self, &handle) as AnyObject? {
            return b as? CAShapeLayer
        } else {
            return nil
        }
    }
    
    func addBadge(number: Int, withOffset offset: CGPoint = CGPoint.zero, andColor color: UIColor = UIColor.red, andFilled filled: Bool = true) {
        guard let view = self.value(forKey: "view") as? UIView else { return }
        
        badgeLayer?.removeFromSuperlayer()
        
        // Initialize Badge
        let badge = CAShapeLayer()
        let radius = CGFloat(7)
        let location = CGPoint(x: view.frame.width - (radius + offset.x), y: (radius + offset.y))
        badge.drawCircleAtLocation(location: location, withRadius: radius, andColor: color, filled: filled)
        view.layer.addSublayer(badge)
        
        // Initialiaze Badge's label
        let label = CATextLayer()
        label.string = "\(number)"
        label.alignmentMode = kCAAlignmentCenter
        label.fontSize = 11
        label.frame = CGRect(origin: CGPoint(x: location.x - 4, y: offset.y), size: CGSize(width: 8, height: 16))
        label.foregroundColor = filled ? UIColor.white.cgColor : color.cgColor
        label.backgroundColor = UIColor.clear.cgColor
        label.contentsScale = UIScreen.main.scale
        badge.addSublayer(label)
        
        // Save Badge as UIBarButtonItem property
        objc_setAssociatedObject(self, &handle, badge, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func updateBadge(number: Int) {
        if let text = badgeLayer?.sublayers?.filter({ $0 is CATextLayer }).first as? CATextLayer {
            text.string = "\(number)"
        }
    }
    
    func removeBadge() {
        badgeLayer?.removeFromSuperlayer()
    }
}



