//
//  ChatViewController.swift
//  Parsechat
//
//  Created by Alexander Strandberg on 6/21/16.
//  Copyright © 2016 Alexander Strandberg. All rights reserved.
//

import UIKit
import Parse

struct Message {
    var username: String?
    var text: String?
    
}

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var tableView: UITableView!
    
    var chats: [Message] = []
    var isLoadingMoreData = true {
        didSet {
            if isLoadingMoreData == false {
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        //tableView.estimatedRowHeight = 100
        //tableView.rowHeight = UITableViewAutomaticDimension
        
        loadData()
        NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ChatViewController.loadData), userInfo: nil, repeats: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func editingChanged(sender: AnyObject) {
        if textField.text != "" {
            sendButton.enabled = true
        } else {
            sendButton.enabled = false
        }
    }
    
    @IBAction func send(sender: AnyObject) {
        Chat.postChat(textField.text!)
        textField.text = ""
        sendButton.enabled = false
        loadData()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ChatCell") as! ChatCell
        let chat = chats[indexPath.row]
        if let text = chat.text {
            cell.Message.text = text
        }
        if let username = chat.username {
            cell.username.text = username
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func loadData() {
        isLoadingMoreData = true
        // construct PFQuery
        let query = PFQuery(className: "Message_fbuJuly2016")
        query.orderByDescending("createdAt")
        query.includeKey("user")
        query.limit = 50
        
        // fetch data asynchronously
        query.findObjectsInBackgroundWithBlock { (chats: [PFObject]?, error: NSError?) -> Void in
            if let chats = chats {
                // do something with the data fetched
                self.chats = []
                for chat in chats {
                    if let text = chat["text"] as? String {
                        let username = (chat["user"] as? PFUser)?.username ?? ""
                        self.chats.append(Message(username: username, text: text))
                    }
                }
            } else {
                // handle error
                print(error?.localizedDescription)
            }
            self.isLoadingMoreData = false
        }
    }
    
}
