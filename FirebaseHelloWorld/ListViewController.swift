//
//  ListViewController.swift
//  FirebaseHelloWorld
//
//  Created by Aaron ALAYO on 06/03/2020.
//  Copyright © 2020 aAron. All rights reserved.
////
//
import UIKit
class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self // we handle events for the tableview
        tableView.dataSource = self // we also provide data for the tableview
        CloudStorage.startListener(tableView: tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    @IBAction func startEditing(_ sender: Any) {
        
        tableView.isEditing = !tableView.isEditing
        deleteButton.isHidden = !tableView.isEditing
    }
    
    @IBAction func deleteRows(_ sender: UIButton) {
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            
            for indexPath in selectedRows {
                
                CloudStorage.deleteNote(at: indexPath.row)
                
            }
            tableView.reloadData()  
        }
    }
    @IBAction func addPressed(_ sender: UIButton) { // to make a new Note
        CloudStorage.createNote(head: "New Head Line", body: "New Body")
        
        print("created note")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CloudStorage.getSize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
        cell?.textLabel?.text = CloudStorage.getNoteAt(index: indexPath.row)?.head
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController {
            destination.rowNumber = tableView.indexPathForSelectedRow!.row
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row number \(indexPath.row)")
        if !tableView.isEditing {
            performSegue(withIdentifier: "segue1", sender: self)
        }
    }

    
}

