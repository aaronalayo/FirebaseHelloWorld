//
//  ViewController.swift
//  FirebaseHelloWorld
//
//  Created by Mac_8 on 28/02/2020.
//  Copyright © 2020 aAron. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate{
    
  
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var headLine: UITextView!
    @IBOutlet weak var body: UITextView!
    var rowNumber = 0
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Use rowNumber to get the right Note object
        
        if let note = CloudStorage.getNoteAt(index: rowNumber) {
            headLine.text = note.head
            headLine.delegate = self
            body.text = note.body
            body.delegate = self
            
            if note.image != "empty"{
                CloudStorage.downloadImage(name: note.image, vc: self)
            }else{
                
                print("note is empty")
            }
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
    
 
    @IBAction func camPressed(_ sender: Any) {
        CameraHandler.shared.showActionSheet(vc: self)
        weak var weakSelf = self //instance of the viewController
        CameraHandler.shared.imagePickedBlock = { (image, imageUrl) in
            if let strongSelf = weakSelf { // avoid retention cycle to avoid memory leak
                strongSelf.img.image = image
                
            }
            
                CloudStorage.uploadImage(imageUrl: imageUrl)
             }   
    }
    
    //MARK:-- UITextView Delegate Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        print(" begin editing \(textView.text ?? "")")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print(" did edit \(textView.text ?? "")")
    }
   
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == headLine {
            print(" did edited headLine \(textView.text ?? "")")
            
        }else {
            print(" did edited body \(textView.text ?? "")")
        }
        updateStorage()
    }
    
    func updateStorage() {
        CloudStorage.updateNote(index: rowNumber, head: headLine.text, body: body.text)
    }
    
    
   
    
}

