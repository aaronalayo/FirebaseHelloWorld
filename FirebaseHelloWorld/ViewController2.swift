//
//  ViewController2.swift
//  FirebaseHelloWorld
//
//  Created by Aaron ALAYO on 17/03/2020.
//  Copyright © 2020 aAron. All rights reserved.
//

import UIKit

class ViewController2 : UIViewController, UITableViewDataSource, UITableViewDelegate, CloudStorageDownloadDelegate{
    
    func imageDownload(image: UIImage) {
        imageView = image
        
    }

    
    @IBOutlet weak var tableView: UITableView!
      
      var rowNumber = 0
      var stories = [Story]()
      var note = [Note]()
      
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let note = CloudStorage.getNoteAt(index: rowNumber) {
            if note.image != "empty"{
                CloudStorage.downloadImage(name: note.image, vc: self)
            }else {
                print("note is empty")
            }
            stories.append(Story(title:note.head, content: note.body, image: note.image))
        }
        tableView.dataSource = self  // assign this class to handle data for the tableView
        tableView.delegate = self
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if stories[indexPath.row].hasImage() {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as? TableViewCellLabelImage {
                cell.label1.text = stories[indexPath.row].title
                cell.bodyView.text = stories[indexPath.row].content
                cell.imgView.image = UIImage(named: stories[indexPath.row].image)
                
                return cell
//            }else{
//                if let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as? TableViewCellLabelImage {
//                    cell.label1.text = stories[indexPath.row].title
//                    return cell
//                }
                // handle the case, where there is an image
            }
        }
        
        
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stories.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return stories[indexPath.row].hasImage() ? 500:80 // ternary operator. If-statement on one line
        // if the part before the questionmark is true, the return the number just after the questionmark.
        // Else return the number after the colon
    }
    
}

