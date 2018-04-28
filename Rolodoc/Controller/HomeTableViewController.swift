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

class HomeTableViewController: UITableViewController {

    let ROLODOC_URL = "http://www.pennrolodoc.com/listings.json"
    
    var consultArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getConsultData(url: ROLODOC_URL)
        tableView.delegate = self
    }



    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return consultArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "consultCell", for: indexPath)
        
        cell.textLabel?.text = consultArray[indexPath.row]
        

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }


    //Write the getWeatherData method here:
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
            let consultName = json[index]["name"].stringValue   //swiftyjson made this simpler to parse JSON.  we're optional binding
            
            consultArray.append(consultName)
//            consultDataModel.name = json["name"].stringValue
//            consultDataModel.number = json["num"]["number"].stringValue
        }
//        else {
//            print ("error updating data")
////            cityLabel.text = "Weather Unavailable"
//        }
        tableView.reloadData()
    }
    
    
    
    

}
