//
//  RegisterViewController.swift
//  todayILearned
//
//  Created by Looker, Shawn on 7/31/14.
//  Copyright (c) 2014 Curs.es. All rights reserved.
//
//  Load this if we can't pull the user data


import UIKit
import CoreData

class RegisterViewController: UIViewController, NSURLConnectionDelegate {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var createAccountBtn: UIButton!
    
    var data = NSMutableData()
    
    let api_url = "http://codeforvegas.org:3000/user/create"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createUser() {
        if usernameField.text.utf16Count > 4 {
            // Create user
//            remote.startConnection("\(api_url)/\(usernameField.text)")
            
            println("Ending editing")
            self.view.endEditing(true)

            let urlPath: String = "\(api_url)/\(usernameField.text)"
            
            Alamofire.request(.GET, urlPath)
                .responseJSON {(request, response, JSON, error) in
                    println(JSON)
                    var userData: NSDictionary = JSON as NSDictionary
                    if let error: String = userData.valueForKey("error") as? String {
                        self.alertMessage("Error", message: error)
                    } else {
                        var tilUser: TILUser = TILUser(name: userData.valueForKey("name") as String, uuid: userData.valueForKey("uuid") as String, key: userData.valueForKey("key") as String)
                        println(tilUser)
                        self.saveUser(tilUser)
                    }
            }

                    
            println("Done with nsurl connection")

        } else {
            // Error
            println("Username less than 4 characters")
            alertMessage("Error", message: "Username must be 5 or more characters")
        }
        println("Done with ibaction")
    }
    
    func alertMessage(title: String, message: String) {
        println("Alerting")
        var alertView = UIAlertView();
        alertView.addButtonWithTitle("Okay");
        alertView.title = title
        alertView.message = message;
        println("getting ready to show alert")
        alertView.show();
        println("Done showing alert")
    }
    
    func saveUser(tilUser: TILUser) {
        println("Saving user")
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        // save data to core data
        var newUser = NSEntityDescription.insertNewObjectForEntityForName("User", inManagedObjectContext: context) as NSManagedObject
        newUser.setValue(tilUser.name, forKey: "name")
        newUser.setValue(tilUser.uuid, forKey: "uuid")
        newUser.setValue(tilUser.key, forKey: "key")
        context.save(nil)
        println("Done saving user")
        
        // Take them to the add a learnable screen
        let vc = self.storyboard.instantiateViewControllerWithIdentifier("addTILViewController") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    func saveUser(jsonResult: NSDictionary) {
        var tilUser: TILUser = TILUser(name: jsonResult["name"] as String, uuid: jsonResult["uuid"] as String, key: jsonResult["key"] as String)
        saveUser(tilUser)
    }
}