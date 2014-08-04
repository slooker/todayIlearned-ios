//
//  User.swift
//  todayILearned
//
//  Created by Looker, Shawn on 7/31/14.
//  Copyright (c) 2014 Curs.es. All rights reserved.
//

class TILUser: Equatable {
    var name: String
    var uuid: String
    var key: String
    
    init(name: String, uuid: String, key: String) {
        self.name = name
        self.uuid = uuid
        self.key = key
    }

}


func == (lhs: TILUser, rhs: TILUser) -> Bool {
    return lhs.name == rhs.name && lhs.uuid == rhs.uuid && lhs.key == rhs.key
}