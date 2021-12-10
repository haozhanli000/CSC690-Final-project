//
//  TableViewController.swift
//  Notes
//
//  Created by HimenoTowa on 11/24/21.
//

import UIKit
import CoreData

class noteTableViewController: UITableViewController {

    var notes = [Note]()
    
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        retrieveNotes()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        retrieveNotes()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "noteTableViewCell", for: indexPath) as! noteTableViewCell

        let note: Note = notes[indexPath.row]
        cell.configureCell(note: note)
        cell.backgroundColor = UIColor.lightGray
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{

        tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete",handler: {(action, view,success) in
                let note = self.notes[indexPath.row]
                context.delete(note)
                                        
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
                    do {
                    self.notes = try context.fetch(Note.fetchRequest())
                    }
                                            
            catch {
                print("Failed to delete note.")
                }
                                        
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.reloadData()
        })
          
          delete.backgroundColor = UIColor.red
          return UISwipeActionsConfiguration(actions: [delete])
    
    }
    
    func retrieveNotes() {
        managedObjectContext?.perform {
            
            self.fetchNotesFromCoreData { (notes) in
                if let notes = notes {
                    self.notes = notes
                    self.tableView.reloadData()
                    
                }
                
            }
            
        }
        
    }
    
    func fetchNotesFromCoreData(completion: @escaping ([Note]?)->Void){
        managedObjectContext?.perform {
            var notes = [Note]()
            let request: NSFetchRequest<Note> = Note.fetchRequest()
            
            do {
                notes = try  self.managedObjectContext!.fetch(request)
                completion(notes)
                
            }
            
            catch {
                print("Could not fetch notes from CoreData:\(error.localizedDescription)")
                
            }
            
        }
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetails" {
            if let indexPath = self.tableView.indexPathForSelectedRow {
                
                let noteDetailsViewController = segue.destination as! noteViewController
                let selectedNote: Note = notes[indexPath.row]
                
                noteDetailsViewController.indexPath = indexPath.row
                noteDetailsViewController.isExsisting = false
                noteDetailsViewController.note = selectedNote
                
            }
            
        }
            
        else if segue.identifier == "addItem" {
            print("Create Note Tapped")
        }

    }

}
