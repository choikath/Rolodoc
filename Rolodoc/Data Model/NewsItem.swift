//
//  NewsItem.swift
//  Rolodoc
//
//  Created by Katherine Choi on 4/28/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//

import Foundation

struct NewsItem {
    //Declaring model variables
    var index : String = ""
    var title : String = ""
//    var description : String = ""
    var source : String = ""
//    var url : String = ""
//    var urlToImage : String = ""
//    var icon : String
//    var publishedAt : String = "2018-04-29T17:20:00Z"
    
    
    init(index: String, title: String, source: String) {
        self.index = index
        self.title = title
        self.source = source
    }
    
    init?(dict: [String: String]) {
        guard let index = dict["index"],
        let title = dict["title"],
        let source = dict["source"]
            else {return nil }
        
        self.index = index
        self.title = title
        self.source = source
        
    }
    
    func dictionaryRepresentation() -> [String: String] { //published at: title
        let dict: [String: String] = ["index": index, "title": title, "source":source]
        return dict
    }
}
