//
//  DetailsViewController.swift
//  MyFavoriteList
//
//  Created by Caner Çağrı on 29.03.2022.
//

import UIKit
import CoreData

class DetailsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var priceTextField: UITextField!
    @IBOutlet var saveButtpn: UIButton!
    @IBOutlet var nameTextField: UITextField!
    
    var selectedItemName = ""
    var selectedItemUUID : UUID?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedItemName != "" {
            // Show selected item options from CoreData
            saveButtpn.isEnabled = false
            
            if let uuidString = selectedItemUUID?.uuidString {
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
                
                // Adding filter    %@ mean = When uudString equal to id, filter data with id
                fetchRequest.predicate = NSPredicate(format: "id = %@", uuidString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                    let sonuclar = try context.fetch(fetchRequest)
                    
                    if sonuclar.count > 0 {
                        for sonuc in sonuclar as! [NSManagedObject] {
                            
                            if let name = sonuc.value(forKey: "name") as? String {
                                nameTextField.text = name
                            }
                            if let price = sonuc.value(forKey: "price") as? Int {
                                priceTextField.text = String(price)
                            }
                            if let image = sonuc.value(forKey: "image") as? Data {
                                let imageLoad = UIImage(data: image)
                                imageView.image = imageLoad
                            }
                        }
                    }
                }catch {
                    print("Error when loading data")
                }
                
            }
        } else {
            saveButtpn.isEnabled = false
            nameTextField.text = ""
            priceTextField.text = ""
           
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(gestureRecognizer)
        
        
        imageView.isUserInteractionEnabled = true
        let imageGesture = UITapGestureRecognizer(target: self, action: #selector(pickImage))
        imageView.addGestureRecognizer(imageGesture)
    }
    
    @objc func pickImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imageView.image = info[.originalImage] as? UIImage
        saveButtpn.isEnabled = true
        self.dismiss(animated: true)
    }
    
    @objc func closeKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func saveBtnTapped(_ sender: Any) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = (appDelegate?.persistentContainer.viewContext)!
        let favorite = NSEntityDescription.insertNewObject(forEntityName: "Favorite", into: context)

        favorite.setValue(nameTextField.text!, forKey: "name")
        
        if let price = Int(priceTextField.text!) {
        favorite.setValue(price, forKey: "price")
        }
        favorite.setValue(UUID(), forKey: "id")
        
        let imageData = imageView.image!.jpegData(compressionQuality: 0.5)
        favorite.setValue(imageData, forKey: "image")
        
        do {
            try context.save()
            print("Save completed!")
        }catch {
            print("Error , didnt save!")
        }
        NotificationCenter.default.post(name: NSNotification.Name("dataEntered"), object: nil)
        self.navigationController?.popViewController(animated: true)
    }
}
