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
    
    
    static func downloadImage(name: String, vc: ViewController){
         print("download called...")
               let imgRef = storage.reference(withPath: name) // get "filehandle"
               imgRef.getData(maxSize: 4000000) { (data, error) in
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
    
    static func getNoteAt(index:Int) -> Note{
        return list[index]
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
 
   
    static func deleteNote(id:String){
        let docRef = db.collection(notes).document(id)
       
        docRef.delete()
        }
    
    static func updateNote(index: Int, head: String, body: String){
        let note = list[index]
        let docRef = db.collection(notes).document(note.id)
        var map = [String:String]()
        map["head"] = head
        map["body"] = body
        docRef.setData(map)
    }
    static func createNote(head: String, body: String){
        let newDoc = db.collection(notes).document()
        var map = [String:String]()
        map["head"] = head
        map["body"] = body
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
/*
 extension UIImage{
     func getImageType() {
        let imageData = self.pngData();
        let str = self.contentType(for: imageData)

    }

    func contentType(for data: NSData) -> String {
//        var c = UnsafeMutablePointer<UInt8>.allocate(capacity: 8)
        var c : UnsafeMutablePointer<UInt8>? = nil
        data.getBytes(&c, length: 1)
        switch (c) {
            case 0xFF:
                    return "image/jpeg"
            case 0x89:
                    return "image/png"
            case 0x47:
                    return "image/gif"
            case 0x49:
                break;
            case 0x42:
                return "image/bmp"
            case 0x4D:
                return "image/tiff"
        }
        return "";
    }
}*/
