//
//  Story.swift
//  FirebaseHelloWorld
//
//  Created by Aaron ALAYO on 18/03/2020.
//  Copyright © 2020 aAron. All rights reserved.
//

import Foundation
class Story{
    
    var title: String
    var content: String
    var image:String
    init (title:String, content:String, image:String){
        self.title = title
        self.content = content
        self.image = image
    }
    
    func hasImage() -> Bool {
        return image.count > 0 // returns true, if there is some image-name string
    }
}


