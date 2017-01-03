//
//  ViewController.swift
//  WOEIDList
//
//  Created by Daesub Kim on 2016. 11. 29..
//  Copyright © 2016년 DaesubKim. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var aTableView: UITableView!
    let importer: WOEIDImporter = WOEIDImporter()
    var woeidList: [WOEID]! = nil
    var woeid: WOEID! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "WOEID"
        
        aTableView.delegate = self
        aTableView.dataSource = self
        aTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    
        woeidList = importer.loadData() // test data
        
        importer.exportDataToPList(woeidList, path: "temp")
        importer.exportDataToCSV(woeidList, path:  "temp")
        importer.exportDataToJSON(woeidList, path: "temp")
        importer.exportDataToXML(woeidList, path: "temp")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return woeidList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        
        let cell: UITableViewCell = aTableView.dequeueReusableCellWithIdentifier("cell") as UITableViewCell!
        let woeid = woeidList[indexPath.row] as WOEID
        cell.textLabel?.text = "\(woeid.code) \(woeid.city) \(woeid.country)"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        print(cell.textLabel?.text)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        print("You selected cell #\(indexPath.row)")
        
        woeid = woeidList[indexPath.row] as WOEID
        self.performSegueWithIdentifier("ShowSimpleVCSegue", sender: self)
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if (segue.identifier == "ShowSimpleVCSegue") {
            if let destinationVC = segue.destinationViewController as? DetailViewController {
                print("SimpleTableViewController")
                destinationVC.woeid = woeid
            }
        }
    }
    
}

