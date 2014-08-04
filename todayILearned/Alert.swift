//
//  Alert.swift
//  todayILearned
//
//  Created by Looker, Shawn on 8/4/14.
//  Copyright (c) 2014 Curs.es. All rights reserved.
//

import UIKit

class Alert {
    class func alertMessage(title: String, message: String) {
        var alertView = UIAlertView();
        alertView.addButtonWithTitle("Okay");
        alertView.title = title
        alertView.message = message;
        alertView.show()
    }
}