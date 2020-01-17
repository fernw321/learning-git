//
//  ProfileViewController.swift
//  JSProject_1
//
//  Created by William Fernandez on 11/10/19.    let userID = Auth.auth().currentUser?.uid

//  Copyright © 2019 William Fernandez. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseFirestore
import Firebase
import Kingfisher

class ProfileViewController: UIViewController, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var genderPicker: UIPickerView!
    @IBOutlet weak var preferencePicker: UIPickerView!
    
    var genderPickerData: [String] = [String]()
    var preferencePickerData: [String] = [String]()

    var userID = ""
    var profileImageURL = ""
    let storage = Storage.storage()
    let db = Firestore.firestore()
    var selectedGender = 0
    var column = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure gender picker
        self.genderPicker.delegate = self
        self.genderPicker.dataSource = self
        
        genderPickerData = ["Cisgender Male", "Cisgender Female", "Transgender Male", "Transgender Female", "Two-Spirit", "Non-Binary", "Genderqueer", "Gender fluid", "Gender neutral"]
        preferencePickerData = ["Straight", "Bisexual", "Gay", "Lesbian", "Bi-curious", "Pansexual"]
        // Set placeholder for UITextView
        bioTextView.text = "Add a bio to your profile"
        bioTextView.delegate = self
        
        
        let defaults = UserDefaults.standard
        let prefersDarkMode = defaults.bool(forKey: "prefersDarkMode")
        if prefersDarkMode {
            overrideUserInterfaceStyle = .dark
        } else {
            overrideUserInterfaceStyle = .light
        }
        
                
        Auth.auth().addStateDidChangeListener { (auth, user) in
            self.userID = user!.uid
            self.loadUserInfo(userID: self.userID)
        }
        

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return genderPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return genderPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: genderPickerData[row], attributes: [NSAttributedString.Key.foregroundColor : UIColor(red: 193/255, green: 74/255, blue: 255/255, alpha: 1.0)])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedGender = row
    }
    
    @IBAction func cameraButtonPressed(_ sender: Any) {
        showImagePickerControllerActionSheet()
    }
    
    
    
    @objc fileprivate func uploadPhoto() {
        guard let image = profileImageView.image, let data = image.jpegData(compressionQuality: 1.0) else {
            print("Something went wrong")
            return
        }
        
        let imageName = UUID().uuidString
        let imageReference = Storage.storage().reference().child(imageName)
        
        imageReference.putData(data, metadata: nil) { (metadata, err) in
            if let err = err {
                print(err)
            }
            
            imageReference.downloadURL(completion: { (url, err) in
                if let err = err {
                    print(err.localizedDescription)
                    return
                }
                
                guard let url = url else {
                    print("Something went wrong")
                    return
                }
                
                let dataReferenece = Firestore.firestore().collection("users").document(self.userID)
                let documentUID = dataReferenece.documentID
                let urlString = url.absoluteString
                
                let data = [
                    "profilePhotoID" : documentUID,
                    "profilePhotoURL" : urlString
                ]
                
                dataReferenece.updateData(data) { (err) in
                    if let err = err {
                        print(err)
                    } else {
                        print("Document successfully updated")
                    }
                    
                    print("Success")
                }
            })
        }
    }
    
    
    
    func loadUserInfo(userID: String) {
        
        db.collection("users").document(userID).getDocument { (document, error) in
            if error == nil {
                if document != nil && document!.exists {
                    let documentData = document!.data()
                    self.nameTextField.text = documentData!["name"] as? String
                    self.emailTextField.text = documentData!["email"] as? String
                    self.bioTextView.text = documentData!["bio"] as? String
                    if let gender = documentData!["gender"] {
                        self.genderPicker.selectRow(gender as! Int, inComponent: 0, animated: true)
                    }
                    if let photo = documentData!["profilePhotoURL"] {
                        self.profileImageURL = photo as! String
                        print(self.profileImageURL)
                        self.loadProfilePicture()
                    }
                }
            } else {
                print("Error retrieving document data.")
            }
        }
    }
    
    
    func loadProfilePicture() {
        let url = URL(string: profileImageURL)
        let processor = DownsamplingImageProcessor(size: CGSize(width: 200, height: 200))
            |> RoundCornerImageProcessor(cornerRadius: 100)
        profileImageView.kf.indicatorType = .activity
        profileImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
    }
    
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if bioTextView.textColor == UIColor.lightGray {
            bioTextView.text = nil
            bioTextView.textColor = UIColor.init(red: 193/255, green: 74/255, blue: 255/255, alpha: 1)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if bioTextView.text.isEmpty {
            bioTextView.text = "Add a bio to your profile"
            bioTextView.textColor = UIColor.init(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        }
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        let dbRef = db.collection("users").document(userID)
        self.uploadPhoto()
        dbRef.updateData([
            "name": nameTextField.text ?? "",
            "bio": bioTextView.text ?? "",
            "gender": selectedGender
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerControllerActionSheet() {
        let photoLibraryAction = UIAlertAction(title: "Choose from library", style: .default) { (action) in
            self.showImagePickerController(sourceType: .photoLibrary)
        }
        let cameraAction = UIAlertAction(title: "Take with camera", style: .default) { (action) in
            self.showImagePickerController(sourceType: .camera)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        AlertService.showAlert(style: .actionSheet, title: "Choose image", message: nil, actions: [photoLibraryAction, cameraAction, cancelAction], completion: nil)
    }
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            profileImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImageView.image = originalImage
        }
        dismiss(animated: true, completion: {
            
        })
    }
    
    
}


