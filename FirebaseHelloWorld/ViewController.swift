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
                print(note.image)
            }else {
                print("note is empty")
            }
                
        }
    
    }
 
//    @IBAction func btnClicked(_ sender: UIButton) {
//        CloudStorage.createNote(head: "New Head Line", body: "New Body")
//    }
    
    @IBAction func camPressed(_ sender: Any) {
        CameraHandler.shared.showActionSheet(vc: self)
        weak var weakSelf = self //instance of the viewController
        CameraHandler.shared.imagePickedBlock = { (image, imageUrl) in
            if let strongSelf = weakSelf { // avoid retention cycle to avoid memory leak
                strongSelf.img.image = image
                
                if let note = CloudStorage.getNoteAt(index: strongSelf.rowNumber) {
                    if let name = imageUrl.lastPathComponent {
                        CloudStorage.updateNote(index: strongSelf.rowNumber, head: note.head, body: note.body, imageUrl: name)
                    }
                }
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

