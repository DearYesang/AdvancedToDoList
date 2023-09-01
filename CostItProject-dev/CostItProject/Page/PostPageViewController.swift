//
//  PostPageViewController.swift
//  cucumberMarket
//
//  Created by 천광조 on 2023/08/14.
//

import UIKit
import PhotosUI

protocol PostViewControllerDelegate {
    func dismissPostViewController(model: PostModel)
}

class PostPageViewController: UIViewController {
    
    var postNumber: Int?
    
    let placeholder: String = "필수 항목입니다."
    
    var isNewPost: Bool = true
    
    var postImage: UIImage?
    
    var modelManager = ModelManager()
    
    var delegate: PostViewControllerDelegate?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var hashTagTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var openPhotoLibraryButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var openPhotoLibraryButtonBottomConstraint: NSLayoutConstraint!
    
    @IBAction func buttonDidTapDonePost(_ sender: Any) {

        if let title = titleTextField.text, title.isEmpty || contentTextView.text == placeholder {
            let alert = UIAlertController(title: "필수항목입니다", message: "제목과 내용을 입력해 주세요 ", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(alertAction)
            present(alert, animated: true)
        } else {
            if isNewPost {
                createNewPost()
            } else {
                updatePost()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
  
        isNewPost = postNumber == nil ? true : false
        
        config()
        
        if !isNewPost {
            configByUpdatePost()
        }

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func createNewPost() {
        
        if let newTitle = titleTextField.text,
            let newContent = contentTextView.text {
            let newPost = PostModel(userId: userArray[0].userId,
                                    title: newTitle,
                                    postImage: postImage ?? UIImage(),                      // 기본 이미지 설정해줘야 할 듯
                                    content: newContent,
                                    hashTag: hashTagTextField.text?.components(separatedBy: ",") ?? [],
                                    comment: [])
            
            postArray.append(newPost)
            
            titleTextField.text?.removeAll()
            hashTagTextField.text?.removeAll()
            contentTextView.text.removeAll()
            imageView.isHidden = true
            
            view.endEditing(true)
            
            tabBarController?.selectedIndex = 0

        }
    }
    
    func updatePost() {
        
        guard let updatePostNumber = postNumber,
              let newTitle = titleTextField.text,
              let newContent = contentTextView.text else { return }
        
        postArray[updatePostNumber].title = newTitle
        postArray[updatePostNumber].content = newContent

        if postImage != nil {
            postArray[updatePostNumber].postImage = postImage!
        }
        
        postArray[updatePostNumber].hashTag = hashTagTextField.text?.components(separatedBy: ",") ?? []
        
        delegate?.dismissPostViewController(model: modelManager.getPostArray()[updatePostNumber])

        dismiss(animated: true)
    }
}

extension PostPageViewController {
    
    func config() {
        setupTitleTextFiele()
        setupContentTextView()
        setupOpenPhotoLibraryButton()
        setupDoneButton()
        setupNotification()
    }
    
    func setupTitleTextFiele() {
        titleTextField.placeholder = placeholder
    }
    
    func setupContentTextView() {
        contentTextView.text = placeholder
        contentTextView.textColor = .lightGray
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = UIColor.black.cgColor
        contentTextView.delegate = self
    }
    
    func setupOpenPhotoLibraryButton() {
        openPhotoLibraryButton.setImage(UIImage(systemName: "photo"), for: .normal)
        openPhotoLibraryButton.tintColor = .black
    }
    
    func setupDoneButton() {
        doneButton.tintColor = .black
    }
    
}

//수정하기 셋업
extension PostPageViewController {
    func configByUpdatePost() {
        
        guard let postNumber = postNumber else { return }
        
        titleTextField.text = postArray[postNumber].title
        hashTagTextField.text = postArray[postNumber].hashTag.map( { String($0) } ).joined(separator: ",")
        
        contentTextView.text = postArray[postNumber].content
        contentTextView.textColor = .black
        
        imageView.image = postArray[postNumber].postImage
    
    }
}

extension PostPageViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if contentTextView.text == placeholder {
            contentTextView.text = nil
            contentTextView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if contentTextView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            contentTextView.text = placeholder
            contentTextView.textColor = .lightGray
        }
    }
    
    private func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo as NSDictionary?,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        //safe area 와 button 의 bottomAnchor constraint 초기값 10을 키보드 높이로 변경해서 키보드가 올라오는 만큼 button 도 올라가도록 하는..방..법..인데....
        //1) outlet으로 만들어서 설정했는데 코드로 할 수는 없었을까
        //2) 이 아울렛 이름 괜찮은걸까..?
        //3) 다른 방법은 뭐가 있었을까..?
        openPhotoLibraryButtonBottomConstraint.constant = keyboardFrame.height - view.safeAreaInsets.bottom
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        openPhotoLibraryButtonBottomConstraint.constant = 10
    }
}

extension PostPageViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                DispatchQueue.main.async {
                    guard let selectedImage = image as? UIImage else { return }
                    self.imageView.image = selectedImage
                    self.postImage = selectedImage
                }
            }
        }
    }
    
    @IBAction func buttonDidTapOpenPhotoLibrary(_ sender: Any) {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 1
        configuration.filter = .images
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
}


