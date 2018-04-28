//
//  ConsultRecord.swift
//  Rolodoc
//
//  Created by Katherine Choi on 4/28/18.
//  Copyright © 2018 Katherine Choi. All rights reserved.
//

import Foundation

class ConsultRecord {
    //Declaring model variables
    
    var id : Int = 0
    var name : String = ""
    var hosp : String = ""
    var instruc : String = ""
    var staticStatus : String = ""
    var activeStatus : String = ""
    var time_am_starts : String = ""
    var time_am_ends : String = ""
    var listing_type : String = ""
    var expires_at : String = ""
    var last_automated_update_at : String = ""
    var last_automated_update_success_at : String = ""
    var descrip : String = ""

    //contained within "num" array in get call
    var number : String = ""
    var pagable : Bool = false
    var consultant : String = ""
    var listing_id : Int = 0
    var active_am : String = ""
    var active_pm : String = ""
    var active_weekend : Bool = false
    var carrier_id : String = ""

    var type : String = ""
    var last_updated : String = ""
    var instruc_html : String = ""
    var shift : String = ""

}
