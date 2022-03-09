//
//  CameraViewController.swift
//  InstagramClone
//
//  Created by Luis Morfin on 2/28/22.
//

import UIKit
import AlamofireImage
import Parse

class CameraViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var commentField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    //creates a table in the database
    @IBAction func onSubmit(_ sender: Any) {
        let post = PFObject(className: "Posts")
        
        post["caption"] = commentField.text!
        post["author"] = PFUser.current()!
        
        let imageData = imageView.image!.pngData()
        let file = PFFileObject(name: "image.png", data: imageData!)
        post["image"] = file
        
        post.saveInBackground {(success, error) in
            if success {
                //dismisses the photo
                self.dismiss(animated: true, completion: nil)
                print("Saved!")
            } else {
                print("Error...")
            }
        }
        
    }
    
    
    @IBAction func onCameraButton(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion: nil)
        
    }
    
    //updates the UIImage after a picture is taken/chosen
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        
        let size = CGSize(width: 300, height: 300)
        
        let scaledImage = image.af.imageAspectScaled(toFill: size)
        
        imageView.image = scaledImage
        dismiss(animated: true, completion: nil)
        
    }
    

}
