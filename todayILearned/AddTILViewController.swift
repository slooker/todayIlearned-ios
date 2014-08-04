//
//  ViewController.swift
//  todayILearned
//
//  Created by Looker, Shawn on 7/29/14.
//  Copyright (c) 2014 Curs.es. All rights reserved.
//

import UIKit

class AddTILViewController: UIViewController {
    var tilItem: TILItem?
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if sender as? NSObject != self.doneButton{
            return
        }
        if self.textField.text.isEmpty == false {
            println("text field is not empty")
            self.tilItem = TILItem(name: self.textField.text)
        } else {
            println("text field is empty")
        }
    }
    
    // hides keyboard when background is touched
    override func touchesBegan(touches: NSSet!, withEvent event: UIEvent!) {
        self.view.endEditing(true)
    }


}

