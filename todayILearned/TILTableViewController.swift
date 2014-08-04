//
//  TILTableViewController.swift
//  todayILearned
//
//  Created by Looker, Shawn on 7/29/14.
//  Copyright (c) 2014 Curs.es. All rights reserved.
//

import UIKit
import CoreData

@objc(TILTableViewController)class TILTableViewController: UITableViewController {
    var TILItems: NSMutableArray = []
    let api_url = "http://codeforvegas.org:3000"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load data from Core Data
        println("Loading data from core data")
        
        let user: TILUser? = loadUser() as TILUser?

//        if user != nil {
        if let user: TILUser = loadUser() as TILUser? {

            // We have a user
            println("We have a user: \(user.name)")
//            remote.startConnection("\(api_url)/learnable/show/\(user.name).json")
            let urlPath: String = "\(api_url)/learnable/show/\(user.name).json"
            
            Alamofire.request(.GET, urlPath)
                .responseJSON {(request, response, JSON, error) in
//                    println(JSON)
                    if JSON as? NSDictionary != nil {
                        self.loadTableData(JSON as NSDictionary)
                    } else {
                        Alert.alertMessage("Error", message: "Could not connect to server to load TIL items")
                    }
            }

            
            
            
            
        } else {
            // We do not have a user.  Switch to user load screen
            println("We don't have a user")
            let vc = self.storyboard.instantiateViewControllerWithIdentifier("registerController") as UIViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
        // done with load data
        

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func loadUser() -> TILUser? {
        var appDel: AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        var context: NSManagedObjectContext = appDel.managedObjectContext!
        
        var request = NSFetchRequest(entityName: "User")
        request.returnsObjectsAsFaults = false
        
        var results: NSArray = context.executeFetchRequest(request, error: nil)
        if (results.count > 0) {
            // do this
            println("Getting user")
            //            var user: User = results[0] as User
            var userData: NSManagedObject = results[0] as NSManagedObject
            //            println("User data: \(userData.name), \(userData.uuid)")
//            println(userData./
            
//            var user: TILUser = TILUser(name: userData.name, uuid: userData.uuid, key: userData.key)
            println("Got user")
            var username: String = userData.valueForKey("name") as String
            var uuid: String = userData.valueForKey("uuid") as String
            var key: String = userData.valueForKey("key") as String
            
            return TILUser(name: username, uuid: uuid, key: key)

        } else {
            // do that
            println("0 results returned, potential error")
            return nil

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func loadTableData(jsonResults: NSDictionary){
        // Load fake data
        
        var learnables: NSArray = jsonResults.valueForKey("learnables") as NSArray
        println(learnables)
        
        for l in learnables {
            var item: TILItem = TILItem.dictionaryToItem(l as NSDictionary)
            self.TILItems.addObject(item)
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.TILItems.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
            let CellIndentifier: NSString = "ListPrototypeCell"
            println("Index: \(indexPath.row)")
            var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier(CellIndentifier) as UITableViewCell
            var tilItem: TILItem = self.TILItems.objectAtIndex(indexPath.row) as TILItem
            cell.textLabel.text = tilItem.name
            return cell
    }
    
    
    @IBAction func unwindToList(segue:UIStoryboardSegue){
        var source: AddTILViewController = segue.sourceViewController as AddTILViewController
        if let item: TILItem = source.tilItem {
            self.TILItems.addObject(item)
            self.tableView.reloadData()
            
            self.uploadNewItem(item)
        }
    }
    
    func uploadNewItem(item: TILItem) {
        let urlPath: String = "\(api_url)/learnable/create"
        let user: TILUser = loadUser() as TILUser
        
        let params = [ "uuid": user.uuid, "description": item.name ]

        Alamofire.request(.POST, urlPath, parameters: params)
    }
}