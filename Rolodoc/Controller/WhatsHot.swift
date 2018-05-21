//
//  WhatsHot.swift
//  Rolodoc
//
//  Created by Katherine Choi on 4/29/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import SwiftMoment
//import TwitterKit
//import SwipeCellKit

class WhatsHot: UITableViewController, UIGestureRecognizerDelegate {

    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    var bearer_token = "AAAAAAAAAAAAAAAAAAAAAMm36AAAAAAAyEHmkBjeeAUTWwdSx7c59RUjYJY%3DBVswM5I7FY88Rf2nyW4lCYXkNzJm8V7ijyrOPS0FhR6aCuZ9po"
//    var newsUrl = "https://api.twitter.com/1.1/statuses/user_timeline.json?pennbatphone=twitterapi&count=20"
    var newsUrl = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=fc3681bdcfe74a8ca761dbf9a0d46635"
    

    
    var newsArray = [NewsItem]()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        getNewsData(url: newsUrl)
        tableView.rowHeight = 80
        tableView.delegate = self
        
    }

    @IBAction func hfPressed(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: "http://www.pennhighfive.com")! as URL)
    }
    @IBAction func closeModal(_ sender: Any) {
//        dismiss(animated: true, completion: nil)
        
        let instagramHooks = "instagram://user?username=pennbananagram"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.openURL(instagramUrl! as URL)
        } else {
            //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.openURL(NSURL(string: "http://instagram.com/pennbananagram")! as URL)
        }
    }
    
    @IBAction func panGestureRecognizerHandler(_ sender: UIPanGestureRecognizer) {
        let touchPoint = sender.location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
            print("gesture began")
        } else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return newsArray.count
    
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "cardCell", for: indexPath)
        cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cardCell")
        
//        print("before printing \(indexPath.row): \(newsArray[indexPath.row].title)")
        cell.textLabel?.text = newsArray[indexPath.row].title
        cell.detailTextLabel?.text = newsArray[indexPath.row].source
        
        
        cell.imageView?.image = UIImage(named: "Heart")
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//        let link = NSURL(string: newsArray[indexPath.row].url)
//
//        if #available(iOS 10, *) {
//            UIApplication.shared.open(link as! URL)
//        } else {
//            UIApplication.shared.openURL(link as! URL)
//        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    //Write the getNewsData method here:
    func getNewsData(url: String) {
        
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + bearer_token
        ]
        
//        Alamofire.request(url, method: .get, headers: headers).responseJSON {  // makes the request in the background asynchronously
        Alamofire.request(url, method: .get).responseJSON {
        response in
            if response.result.isSuccess {
                print("Success! Got the news data")
                
                let newsJSON : JSON = JSON(response.result.value!) // swiftyjson functionality to wrap into json format.
                self.updateNewsData(json: newsJSON)  // self refers to this current class, because this block has closure, but trying to call a method outside the current function
                
                
            }
            else {
                print("Error \(response.result.error)")
                
            }
        }
    }
    
    func updateNewsData(json: JSON) {
        
//        print("json: \(json)")

//        for index in 0...(json["totalResults"].intValue-1) {
       
//
//            var newsItem = NewsItem()
//            newsItem.title = json["articles"][index]["title"].stringValue    //swiftyjson made this simpler to parse JSON.  we're optional binding
//            newsItem.description = json["articles"][index]["description"].stringValue
//            newsItem.source = json["articles"][index]["source"]["name"].stringValue
//            newsItem.urlToImage = json["articles"][index]["urlToImage"].stringValue
//            newsArray.append(newsItem)
//
//
//
//        }
                print(json)
         for index in 0...19 {
            
            let newsItem = NewsItem()
                newsItem.title = json["articles"][index]["title"].stringValue    //swiftyjson made this simpler to parse JSON.  we're optional binding
                newsItem.description = json["articles"][index]["description"].stringValue
            newsItem.source = json["articles"][index]["source"]["name"].stringValue
             newsItem.urlToImage = json["articles"][index]["urlToImage"].stringValue
            
                newsArray.append(newsItem)
        }
//        SVProgressHUD.dismiss()
        tableView.reloadData()
    }

    
}




//extension UIImageView {
//    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
//        contentMode = mode
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard
//                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
//                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
//                let data = data, error == nil,
//                let image = UIImage(data: data)
//                else { return }
//            DispatchQueue.main.async() {
//                self.image = image
//            }
//            }.resume()
//    }
//    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
//        guard let url = URL(string: link) else { return }
//        downloadedFrom(url: url, contentMode: mode)
//    }
//}
