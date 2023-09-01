//
//  DetailPageViewController.swift
//  cucumberMarket
//
//  Created by 천광조 on 2023/08/14.
//

import UIKit

class DetailPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
 
    @IBOutlet var tables: UITableView!
    
    @IBOutlet var idimageC: UIStackView!
    
    @IBOutlet var mainImage: UIImageView!
    
    @IBOutlet var useredImage: UIImageView!
    
    @IBOutlet var useredId: UILabel!
    
    @IBOutlet var recommends: UILabel!
    
    @IBOutlet var hashTags: UILabel!
    
    @IBOutlet var contents: UILabel!
    
    @IBOutlet var titles: UILabel!
    
    @IBOutlet var commentTextView: UITextView!
    
    @IBOutlet var recommenBtn: UIButton!
    var modelManagers: ModelManager?
    
    var mainCell: MainPageTableViewCell?
    var isSelec = false
    var recoCount: Int = 0
    var models: PostModel?
    func detailUI() {
        guard let models = models else { return }
     
        useredId.text = models.userId
        useredImage.image = models.postImage
        titles.text = models.title
        mainImage.image = models.postImage
        contents.text = models.content
        
        let hashtag = models.hashTag.map { String($0) }.joined(separator: ",")
        hashTags.text = hashtag
        
        recommends.text = "추천수:\(models.recommendCount)"
        print(models.recommendCount)
    }

    // 추천버튼 기능구현
    @IBAction func recommendCountBtn(_ sender: UIButton) {
        if var selectedPost = models {
            recoCount = selectedPost.recommendCount
            isSelec = selectedPost.isSelected
            if selectedPost.isSelected {
                // 이미 추천한 상태라면 추천 취소
                isSelec = false
                recoCount -= 1
                // 선택 상태 변경
                recommenBtn.setTitle("추천하기", for: .normal)
                recommenBtn.setTitleColor(.systemBlue, for: .normal)
            } else {
                // 추천하지 않은 상태라면 추천하기
                isSelec = true
                recoCount += 1
                // 선택 상태 변경
                recommenBtn.setTitle("추천취소", for: .normal)
                recommenBtn.setTitleColor(.systemRed, for: .normal)
            }

            // 추천 수 레이블 업데이트
            selectedPost.recommendCount = recoCount
            selectedPost.isSelected = isSelec
            recommends.text = "추천수: \(selectedPost.recommendCount)"
//            if index in 0..< postArray.count {
//                if postArray[index].postNumber == selectedPost.postNumber {
//                    modelManagers?.updatePost(at: index, wiht: selectedPost)
//                    models = selectedPost
//                }
//            }
            // models에 변경된 값 저장
            if let index = modelManagers?.getPostArray().firstIndex(where: { $0.postNumber == selectedPost.postNumber }) {
                modelManagers?.updatePost(at: index, wiht: selectedPost)
                // models 객체 업데이트
                models = selectedPost
            }

            // 화면 업데이트
            detailUI()
        }
    }

//    수정버튼
    lazy var edits: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(buttonPressed(_:)))
        
        return button
    }()

//    수정버튼  누르면 post페이지로 이동
    @objc private func buttonPressed(_ sender: Any) {
        let postVC = storyboard?.instantiateViewController(withIdentifier: "PostPageViewController") as? PostPageViewController
        postVC?.postNumber = models?.postNumber
        postVC?.modalPresentationStyle = .fullScreen
        postVC?.delegate = self
        if let postVC = postVC {
            present(postVC, animated: true, completion: nil)
        }
    }

//    삭제버튼
    lazy var deletes: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(buttonPresseds(_:)))
        
        return button
    }()

//    삭제버튼 누르면 해당 게시물 삭제
    @objc private func buttonPresseds(_ sender: Any) {
        if let posts = models {
            let alertController = UIAlertController(title: "삭제 확인", message: "게시물을 삭제하시겠습니까?", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "삭제", style: .destructive) { _ in
                // 게시물 삭제 코드 구현
                
                self.modelManagers?.deletePost(posts)
                // 메인 화면으로 돌아가기
                self.navigationController?.popViewController(animated: true)
            }
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            present(alertController, animated: true, completion: nil)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItems = [edits, deletes]
        setUI()
        detailUI()
    }

//    댓글 테이블뷰
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let models = models else { return 0 }
        if models.comment.count == 0 {
            return 1
        } else { return models.comment.count }
    }

//    댓글 테이블뷰
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DetailTableViewCell
        
        if let commentArray = models?.comment, commentArray.count > indexPath.row {
            let comment = commentArray[indexPath.row]
            cell.comments.text = comment.comment
            cell.commentId.text = comment.userId
            // 댓글 이미지를 표시하는 코드가 있어야 함
            cell.commentImage.image = UIImage(named: "contacts")
        } else {
            cell.comments.text = "댓글이 없습니다."
            cell.commentId.text = ""
            cell.commentImage.image = UIImage(named: "person")
        }
        
        return cell
    }

//    테이블뷰 높이 지정
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 해당 indexPath에 대한 행 높이를 반환
        return 100.0 //
    }

    // 화면이 다시 나타날 때마다 데이터를 갱신
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 화면이 다시 나타날 때마다 데이터를 갱신
        detailUI()
        tables.reloadData() // 이 코드가 필요한 경우에 추가
    }
    
    func setUI() {
        tables.dataSource = self
        tables.delegate = self
    }

//    댓글 저장버튼 누르면 댓글 추가
    @IBAction func commentSave(_ sender: Any) {
        if let inputComment = commentTextView.text {
            // models가 nil이 아닌 경우에만 작업 수행
            if var selectedPost = models {
                // 코멘트를 저장하고 추천 카운트를 증가시킴
                let newComment = Comment(userId: "User ID2", comment: inputComment)
                         
                // 현재 선택된 게시글의 인덱스를 찾기
                if let postIndex = postArray.firstIndex(where: { $0.postNumber == selectedPost.postNumber }) {
                    // 해당 게시글의 comment 배열에 댓글을 추가
                    postArray[postIndex].comment.append(newComment)
                             
                    // 선택된 게시글을 업데이트
                    selectedPost.comment = postArray[postIndex].comment
                    models = selectedPost
                    detailUI()
                    tables.reloadData()
                    commentTextView.text = ""
                }
            }
        }
    }
}

extension DetailPageViewController: PostViewControllerDelegate {
    func dismissPostViewController(model: PostModel) {
        models = model
        detailUI()
    }
}
