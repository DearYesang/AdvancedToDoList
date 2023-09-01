//
//  UserIdViewController.swift
//  CostItProject
//
//  Created by 천광조 on 2023/08/18.
//

import UIKit
import Alamofire



class UserIdViewController: UIViewController {

    let modelManager: ModelManager
    
    init(modelManager: ModelManager) {
        self.modelManager = modelManager
        super.init(nibName: nil, bundle: nil)
        userIdTextField.delegate = self
        userIdTextField.becomeFirstResponder()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private lazy var enterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = .lightGray
        button.setTitle("Enter", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(enterButtonTapped), for: .touchUpInside)
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        return button
    }()

    
    private lazy var userIdTextField: UITextField = {
        let tf = UITextField()
                tf.frame.size.height = 20
                tf.textColor = .black
                tf.backgroundColor = .lightGray
                tf.borderStyle = .roundedRect
                tf.autocapitalizationType = .none
                tf.autocorrectionType = .no
                tf.spellCheckingType = .no
                tf.clearsOnBeginEditing = false
                tf.translatesAutoresizingMaskIntoConstraints = false
                tf.placeholder = "아이디를 입력해 주세요."
                tf.layer.cornerRadius = 10
                tf.clipsToBounds = true
                return tf
    }()
    
    // UIImageView 인스턴스 생성
    
    private lazy var brandImageView: UIImageView = {
           let spartaLogoView = UIImageView(frame: CGRect(x: 50, y: 100, width: 300, height: 150))
           
           // 이미지 URL
           let spartaLogoUrl = "https://spartacodingclub.kr/css/images/scc-og.jpg"
           
           // Alamofire를 사용하여 이미지 로드
        AF.request(spartaLogoUrl).response { response in
               switch response.result {
               case .success(let data):
                   // 이미지 로드 성공
                   DispatchQueue.main.async {
                       // 이미지를 UIImageView에 설정
                       spartaLogoView.image = UIImage(data: data!)
                   }
               case .failure(let error):
                   // 이미지 로드 실패
                   print("이미지 로드 실패: \(error)")
               }
           }
        return spartaLogoView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
    }

    
    func makeUI() {
        view.backgroundColor = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
        view.addSubview(userIdTextField)
        view.addSubview(enterButton)
        view.addSubview(brandImageView)
        
       
        NSLayoutConstraint.activate([
            userIdTextField.heightAnchor.constraint(equalToConstant: 50),
            userIdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            userIdTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            userIdTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 350),
//            userIdTextField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            
            
            enterButton.heightAnchor.constraint(equalToConstant: 50),
            enterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            enterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
//            enterButton.topAnchor.constraint(equalTo: userIdTextField.bottomAnchor, constant: 50),
            enterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -330)
        ])
        
    }
    
    // 버튼 누르면 동작하는 코드 ===> 로그인하면, 디스미스 (탭바가 더 아래에 깔려있음)
    @objc func enterButtonTapped() {
        
        //전화면의 isLoggedIn속성에 접근하기 ⭐️
        if let presentingVC = presentingViewController {
            let tabBarCon = presentingVC as! UITabBarController
            let nav = tabBarCon.viewControllers?[0] as! UINavigationController
            let firstVC = nav.viewControllers[0] as! MainPageController
            
            if userIdTextField.text == "" && userIdTextField.text == " " {
                let alert = UIAlertController(title: "오류", message: "아이디를 입력해 주세요.", preferredStyle: .alert)
                
                //동작버튼 설정
                let success = UIAlertAction(title: "확인", style: .default)
                alert.addAction(success)
                
                self.present(alert, animated: true, completion: nil)
                return
            } else {
                guard var text = userIdTextField.text else { return }
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let myPageVC = storyboard.instantiateViewController(withIdentifier: "myPageVC") as! MyPageViewController
                
                

               let myProfile = MyPageModel(userId: text, userImage: UIImage(systemName: "person")!, githubURL: "", blogURL: "")
                
                modelManager.appendProfile(myProfile)

//                modelManager.profileUpdate(userId: text)
//                myPageVC.myProfile = modelManager.myProfile
                firstVC.userIdStatus.toggle()
                dismiss(animated: true, completion: nil)
            }
            
        }
    
    }

}


extension UserIdViewController: UITextFieldDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    internal func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if userIdTextField.text == "" && userIdTextField.text == " " {
            return false
        }
        userIdTextField.resignFirstResponder()
        return true
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if (textField.text?.count)! + string.count > 15 {
            return false
        } else {
            return true
        }
    }
    
}
    
    
    

