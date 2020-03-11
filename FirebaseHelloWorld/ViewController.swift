//
//  ViewController.swift
//  FirebaseHelloWorld
//
//  Created by Mac_8 on 28/02/2020.
//  Copyright © 2020 aAron. All rights reserved.
//

import UIKit

class ViewController: UIViewController{
    
  
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var headLine: UITextView!
    @IBOutlet weak var body: UITextView!
    var rowNumber = 0
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Use rowNumber to get the right Note object
        
        let note = CloudStorage.getNoteAt(index: rowNumber)
        headLine.text = note.head
        body.text = note.body
        if note.image != "empty"{
            CloudStorage.downloadImage(name: note.image, vc: self)
        }else{
            
            print("note is empty")
        }
    }
        
        
           
//        CloudStorage.startListener(tableView: tableView)
//        CloudStorage.createNote(head: "new note", body: "new body")
//        images.append("m1.jpg")
//        images.append("m2.jpg")
//        images.append("m3.jpg")
////        CloudStorage.deleteNote(id: "1ADRue6WlsIboORSo5Dm")
////        CloudStorage.updateNote(index: 0, head: "new headLine", body: "something")
//    }

 

    @IBAction func btnClicked(_ sender: UIButton) {
        CloudStorage.createNote(head: "New Head Line", body: "New Body")
    }

    
    
    @IBAction func downloadBtnPressed(_ sender: UIButton) {
//
//
//        CloudStorage.downloadImage(name: images.randomElement()!, vc:self)
//
//
    }
    
    
    
    
   
    
}

