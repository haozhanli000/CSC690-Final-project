//
//  TableViewController.swift
//  
//
//  Created by HimenoTowa on 11/24/21.
//

import UIKit
import CoreData

class noteViewController: UIViewController, UITextFieldDelegate,  UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextViewDelegate {

    @IBOutlet weak var noteInfoView: UIView!
    @IBOutlet weak var noteImageViewView: UIView!
    @IBOutlet weak var noteNameLabel: UITextField!
    @IBOutlet weak var noteDescriptionLabel: UITextView!
    @IBOutlet weak var noteImageView: UIImageView!
    
    var managedObjectContext: NSManagedObjectContext? {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    }
    
    var notesFetchedResultsController: NSFetchedResultsController<Note>!
    var notes = [Note]()
    var note: Note?
    var isExsisting = false
    var indexPath: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let note = note {
            noteNameLabel.text = note.noteName
            noteDescriptionLabel.text = note.noteDescription
            noteImageView.image = UIImage(data: note.noteImage! as Data)

        }
        
        if noteNameLabel.text != "" {
            isExsisting = true
        }
        
        noteNameLabel.delegate = self
        noteDescriptionLabel.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    // Core data
    func saveToCoreData(completion: @escaping ()->Void){
        managedObjectContext!.perform {
            do {
                
                completion()
                try self.managedObjectContext?.save()
                
                print("Note saved to CoreData.")
                
            }
            
            catch let error {
                print("Could not save note to CoreData: \(error.localizedDescription)")
                
            }
            
        }
        
    }
    
    // Image Picker
    @IBAction func pickImageButtonWasPressed(_ sender: Any) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        
        let alertController = UIAlertController(title: "Add an Image", message: "Choose From", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (action) in
            pickerController.sourceType = .camera
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let photosLibraryAction = UIAlertAction(title: "Photos Library", style: .default) { (action) in
            pickerController.sourceType = .photoLibrary
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let savedPhotosAction = UIAlertAction(title: "Saved Photos Album", style: .default) { (action) in
            pickerController.sourceType = .savedPhotosAlbum
            self.present(pickerController, animated: true, completion: nil)
            
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        alertController.addAction(cameraAction)
        alertController.addAction(photosLibraryAction)
        alertController.addAction(savedPhotosAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        self.noteImageView.image = image
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        
    }

    // Save
    @IBAction func saveButtonWasPressed(_ sender: UIBarButtonItem) {
        if noteNameLabel.text == "" || noteNameLabel.text == "Header" || noteDescriptionLabel.text == "" || noteDescriptionLabel.text == "Note" {
            
            let alertController = UIAlertController(title: "Missing Information", message:"You left one or more fields empty. Please make sure that all fields are filled before attempting to save.", preferredStyle: UIAlertController.Style.alert)
            let OKAction = UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: nil)
            
            alertController.addAction(OKAction)
            
            self.present(alertController, animated: true, completion: nil)
    
        }
        
        else {
            if (isExsisting == false) {
                let noteName = noteNameLabel.text
                let noteDescription = noteDescriptionLabel.text
                
                if let moc = managedObjectContext {
                    let note = Note(context: moc)

                    if let data = self.noteImageView.image!.pngData() {
                        note.noteImage = data as Data
                        if self.noteImageView.image != UIImage.init(data: data){ print("hi")}
                    }
                
                    note.noteName = noteName
                    note.noteDescription = noteDescription
                
                    saveToCoreData() {
                        
                        let isPresentingInAddFluidPatientMode = self.presentingViewController is UINavigationController
                        
                        if isPresentingInAddFluidPatientMode {
                            self.dismiss(animated: true, completion: nil)
                    
                            
                        }
                            
                        else {
                            self.navigationController!.popViewController(animated: true)
                            
                        }

                    }


                }
            
            }
            
            else if (isExsisting == true) {
                
                let note = self.note
                
                let managedObject = note
                managedObject!.setValue(noteNameLabel.text, forKey: "noteName")
                managedObject!.setValue(noteDescriptionLabel.text, forKey: "noteDescription")
                
                if let data = self.noteImageView.image!.pngData() {
                    managedObject!.setValue(data, forKey: "noteImage")
                }
                
                do {
                    try context.save()
                    
                    let isPresentingInAddFluidPatientMode = self.presentingViewController is UINavigationController
                    
                    if isPresentingInAddFluidPatientMode {
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                        
                    else {
                        self.navigationController!.popViewController(animated: true)
                        
                    }

                }
                
                catch {
                    print("Failed to update existing note.")
                }
            }

        }

    }
    
    // Cancel
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInAddFluidPatientMode = presentingViewController is UINavigationController
        
        if isPresentingInAddFluidPatientMode {
            dismiss(animated: true, completion: nil)
            
        }
        
        else {
            navigationController!.popViewController(animated: true)
            
        }
        
    }
    
    // Text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n") {
            textView.resignFirstResponder()
            return false
            
        }
        
        return true
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if (textView.text == "Note") {
            textView.text = ""
            
        }
        
    }
    
}

fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
	return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}


fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
	return input.rawValue
}
