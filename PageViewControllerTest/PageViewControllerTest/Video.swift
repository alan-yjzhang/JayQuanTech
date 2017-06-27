//
//  Video.swift
//  YouTubeHomeFeed
//
//  Created by Vamshi Krishna on 07/05/17.
//  Copyright © 2017 VamshiKrishna. All rights reserved.
//

import UIKit

class Video: NSObject {
    var thumbnail_image_name:String?
    var title:String?
    var channel:Channel?
    var number_of_views:NSNumber?
    var uploadDate:NSDate?
    
    override func setValue(_ value: Any?, forKey key: String) {

        let upperFirstCharacter = String(describing: key.characters.first!).uppercased()
        let range = key.startIndex..<key.index(after: key.startIndex)
        let firstUpperKey = key.replacingCharacters(in: range, with: upperFirstCharacter) // e.g Title
        let selector = Selector("set\(firstUpperKey):") // e.g. setTitle
        
//        let selector = Selector(key)  // only check for property existence, not readable or writable.
        if self.responds(to: selector) == false {
            return;
        }
        
        if key == "channel" {
            self.channel = Channel()
            self.channel?.setValuesForKeys(value as! [String: AnyObject])
        }else{
            super.setValue(value, forKey: key)
        }
        
    }
    override init() {
        super.init()
    }
    init(_ dictionary: [String: AnyObject]){
        super.init()
        setValuesForKeys(dictionary)
    }
}

class Channel:NSObject{
    var name:String?
    var profile_image_name:String?
    
    override func setValue(_ value: Any?, forKey key: String) {
        let upperFirstCharacter = String(describing: key.characters.first!).uppercased()
        let range = key.startIndex..<key.index(after: key.startIndex)
        let firstUpperKey = key.replacingCharacters(in: range, with: upperFirstCharacter) // e.g name
        let selector = Selector("set\(firstUpperKey):") // e.g. setName
//        let selector = Selector(key)
        if self.responds(to: selector) == false {
            return;
        }
        super.setValue(value, forKey: key)
    }
}
