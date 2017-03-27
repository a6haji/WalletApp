//
//  WalletTableViewController.swift
//  WalletApp
//
//  Created by Aly Haji on 2017-03-26.
//  Copyright © 2017 Aly Haji. All rights reserved.
//

import UIKit

class WalletTableViewController: UITableViewController {
    
    let data = EndPointTypes.Wallet
    
    
    
    var Accounts = [String]()
    var Amounts = [NSNumber]()
    var Start = [String]()
    var End = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()


        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
    
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(self.catchNotification(notification:)),
            name: Notification.Name(rawValue:"MyNotification" + self.data.rawValue),
            object: nil)
        
        APICommunication.apirequest(data: EndPointTypes.Wallet, httpMethod: "GET", httpBody: nil)
        
        
    }
    
    func catchNotification(notification: Notification) -> Void {
        print("Caught Graph notification")
        
        guard let jsonResponse = notification.userInfo else {
            print("No userInfo found in notification")
            return
        }
        
        let json = APICommunication.convertDatatoDictionary(data: jsonResponse["response"] as! Data)
        
        //Parse json response
        guard let id = json?["info"] as? NSDictionary else {
            print ("Could not find info element")
            return
        }
        
        let cards = id["cards"] as! NSArray
        
        for index in 0..<cards.count {
            let card = cards[index] as! NSDictionary
            let account = card["type"]
            let amount = card["amount"]
            let start = card["policy_start_date"]
            let end = card["policy_end_date"]
            
            Accounts.append(account! as! String)
            Amounts.append(amount! as! NSNumber)
            Start.append(start! as! String)
            End.append(end! as! String)
            
        }
        Accounts = convertAccount(account: Accounts)
        Start = convertDate(dates: Start)
        End = convertDate(dates: End)
        
        self.tableView.reloadData()

        
    }
    
    func convertAccount(account: [String]) -> [String] {
        
        var convertNames = [String]()
        
        for name in account {
            let newName = name.replacingOccurrences(of: "_", with: " ")
            convertNames.append(newName.uppercased())
        }
        
        return convertNames
    }
    
    func convertDate(dates: [String]) -> [String] {
        
        var convertDates = [String]()
        
        for dateString in dates {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            dateFormatter.timeZone = TimeZone(abbreviation: "ET")
            let date = dateFormatter.date(from: dateString)
            dateFormatter.dateFormat = "MMM dd yyy"
            convertDates.append(dateFormatter.string(from: date!))
        }
        
        
        return convertDates
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return Accounts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WalletCell", for: indexPath) as! WalletTableViewCell

        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.AccountName.text = Accounts[indexPath.row]
        cell.BalanceAmount.text = "$\(String(describing: Amounts[indexPath.row]))"
        cell.EffectiveDates.text = "Effective: \(Start[indexPath.row]) - \(End[indexPath.row])"

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
