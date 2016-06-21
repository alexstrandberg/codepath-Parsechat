//
//  Chat.swift
//  Parsechat
//
//  Created by Alexander Strandberg on 6/21/16.
//  Copyright © 2016 Alexander Strandberg. All rights reserved.
//

import Foundation
import Parse

class Chat {
    class func postChat(text: String){
        let chat = PFObject(className: "Message_fbuJuly2016")
        chat["text"] = text
        chat["user"] = PFUser.currentUser()
        
        chat.saveInBackgroundWithBlock({(success, error) -> Void in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("Message uploaded: \(text)")
            }
        })
    }
}
