//
//  TILItem.swift
//  todayILearned
//
//  Created by Looker, Shawn on 7/29/14.
//  Copyright (c) 2014 Curs.es. All rights reserved.
//

import Foundation

class TILItem {
    var name: String = ""
    var learned_date: String = ""
    
    init(name:String) {
        self.name = name
    }
    
    init(name: String, learned_date: String) {
        self.learned_date = learned_date
        self.name = name
    }
    
    class func dictionaryToItem(dict: NSDictionary) -> TILItem {
        var name: String = dict.valueForKey("description") as String
        
        var learned_date: String = dict.valueForKey("date_learned") as String
        var item: TILItem = TILItem(name: name, learned_date: learned_date)
        return item
    }
}