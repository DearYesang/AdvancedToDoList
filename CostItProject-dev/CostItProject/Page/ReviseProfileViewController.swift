//
//  ReviseProfileViewController.swift
//  CostItProject
//
//  Created by t2023-m0090 on 8/17/23.
//

import UIKit


class ReviseProfileViewController : UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBAction func addPick(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        
        self.present(picker, animated: false)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss (animated: false) { () in
            let alert = UIAlertController(title: "취소되었습니다. ", message: "사진이 선택이 취소되었습니다. ", preferredStyle:
                    .alert)
            let ok = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction (ok)
            self.present(alert, animated: false)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info:
                               [UIImagePickerController.InfoKey : Any]) {
        self.dismiss(animated: false) { () in
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            self.imgView.image = image
        }
    }
    
    @IBOutlet weak var userImage: UIImageView!
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}



