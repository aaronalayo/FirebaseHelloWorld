//
//  CloudStorage.swift
//  FirebaseHelloWorld
//
//  Created by Mac_8 on 28/02/2020.
//  Copyright © 2020 aAron. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

class CloudStorage{
    
    private static var list = [Note]()
    private static let db = Firestore.firestore()
    private static let storage = Storage.storage()//get the instance
    private static let notes = "notes"
    
    
//    static func downloadImage(name: String, vc: ViewController){
//         print("download called...")
//
//        let storageRef = storage.reference()
//        if let imageName = imageUrl.lastPathComponent {
//               let imgRef = storageRef.child("images/\(imageName)") // get "filehandle"
//                print("found image")
//               imgRef.getData(maxSize: 4000000) { (data, error) in
//                   if error == nil {
//                       print("success downloading image !")
//                       let img = UIImage(data: data!)
//                       DispatchQueue.main.async { // prevent background thread from
//                           // interrupting the main thread, which handles user input
//                           vc.img.image = img
//                       }
//                   } else {
//                       print("some error downloading \(error.debugDescription)")
//                   }
//
//               }
//        }
//
//           }
//
    
    static func downloadImage(name: String, vc:ViewController){
          print("download called...")
            
          let imgRef = storage.reference(withPath: "image/\(name)") // get "filehandle"
        imgRef.getData(maxSize: 8000000) { (data, error) in
              if error == nil {
                  print("success downloading image !")
                  let img = UIImage(data: data!)
                  DispatchQueue.main.async { // prevent background thread from
                      // interrupting the main thread, which handles user input
                      vc.img.image = img
                  }
              } else {
                  print("some error downloading \(error.debugDescription)")
              }
              
          
           }
      }
    static func getSize() -> Int{
           return list.count
       }
    
    static func getNoteAt(index:Int) -> Note?{
        if list.count > index {
            return list[index]
        }
        return nil
    }
    
    
    
    static func startListener(tableView: UITableView){
        print("Starting listener")
        db.collection(notes).addSnapshotListener {(snap, error) in
            if error == nil {
                self.list.removeAll() //clears the list
                for note in snap!.documents {
                    let map = note.data()
                    let head = map["head"] as! String
                    let body = map["body"] as! String
                    let image = map["image"] as? String ?? "empty"
                    
                    let newNote = Note(id: note.documentID, head: head, body: body, image: image)
                    self.list.append(newNote)
                }
                DispatchQueue.main.async {
                    tableView.reloadData()
                }
            }
            
        }
    }
 
   
    static func deleteNote(id:String) {
        let docRef = db.collection(notes).document(id)
        
        docRef.delete()
    }
    
    static func deleteNote(at index:Int) {
        if let noteId =  getNoteAt(index: index)?.id{
            deleteNote(id: noteId)
        }
    }
    
    static func updateNote(index: Int, head: String, body: String, imageUrl: String? = "empty") {
        let note = list[index]
        let docRef = db.collection(notes).document(note.id)
        var map = [String:String]()
        map["head"] = head
        map["body"] = body
        map["image"] = imageUrl
        docRef.setData(map)
    }
    static func createNote(head: String, body: String, imageUrl: String? = "empty") {
        let newDoc = db.collection(notes).document()
        var map = [String:String]()
        map["head"] = head
        map["body"] = body
        map["image"] = imageUrl
        newDoc.setData(map)
    }
    
    static func uploadImage(imageUrl: NSURL) {
        // File located on disk
        let localFile = imageUrl
        
        // Create a reference to the file you want to upload
        if let imageName = imageUrl.lastPathComponent {
            let imageRef = storage.reference().child("image/\(imageName)")
            
            
            let uploadTask = imageRef.putFile(from: localFile as URL, metadata: nil) { metadata, error in
                guard let metadata = metadata else {
                    // Uh-oh, an error occurred!
                    print("error uploading file:\(localFile)")
                    return
                    
                }
                print("succesfully uploaded file:\(metadata)")
                
            }
            uploadTask.resume()
        }
    }
    
    
}
