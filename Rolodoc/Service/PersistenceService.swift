//
//  PersistenceService.swift
//  Rolodoc
//
//  Created by Katherine Choi on 7/17/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//

import Foundation

class PersistenceService {
    private init() {}
    static let shared = PersistenceService()
    
    let userDefaults = UserDefaults.standard
    
    func save(_ newsItems: [NewsItem]) {
        var dictArray = [[String:String]]()
        
        for newsItem in newsItems {
            dictArray.append(newsItem.dictionaryRepresentation())
        }
        
        userDefaults.set(dictArray, forKey: "newsItems")
    }
    
    func getNewsItems(completion: @escaping ([NewsItem]) -> Void) {
        guard let dictArray = userDefaults.array(forKey: "newsItems") as?  [[String: String]] else {return}
        var newsItems = [NewsItem]()
        for dict in dictArray {
            guard let newsItem = NewsItem(dict: dict) else {continue}
            newsItems.append(newsItem)
        }
        DispatchQueue.main.async {
            completion(newsItems)
        }
    }
}
