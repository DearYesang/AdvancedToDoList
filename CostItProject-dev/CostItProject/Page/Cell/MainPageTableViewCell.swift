//
//  MainPageTableViewCell.swift
//  cucumberMarket
//
//  Created by 천광조 on 2023/08/14.
//

import UIKit

class MainPageTableViewCell: UITableViewCell {

   
    @IBOutlet weak var userImage: UIImageView!
    
    @IBOutlet weak var postDate: UILabel!
    
    @IBOutlet weak var userId: UILabel!
    
    @IBOutlet weak var hashTag: UILabel!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var heartButton: UIButton!
    
    @IBOutlet weak var shareButton: UIButton!
    
    @IBOutlet weak var recommendCount: UILabel!
    
    //공유하기 클로저
    var shareButtonTappedClosure: (() -> Void)?
    var isSelec = false
    var heartnumber: Int = 0
    
    var modelManager: ModelManager?
    
    var model: PostModel? {
        didSet {
            self.userId.text = model?.userId
            self.userImage.image = model?.postImage
            self.title.text = model?.title

            
        }
    }
    
    

    //이미지 원으로 그리기
    override func awakeFromNib() {
        super.awakeFromNib()
        self.userImage.layer.cornerRadius = self.userImage.frame.height / 2
        self.userImage.clipsToBounds = true
       
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

    
    
    //하트 버튼과, 추천수 증가
    @IBAction func heartButtonTapped(_ sender: UIButton) {
        // 한번 누르면 하트.fill 이 되고 카운트 +1 , 다시 누르면 빈 하트 -1
        guard var model = model else { return }
        if self.heartButton.imageView?.image == UIImage(systemName: "heart") {
            heartnumber +=  1
            
            self.heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            self.isSelec = true
            self.recommendCount.text = String(heartnumber)
            model.recommendCount = heartnumber
            model.isSelected = isSelec
            print(model.recommendCount)
            
        } else if self.heartButton.imageView?.image == UIImage(systemName: "heart.fill") {
            heartnumber -= 1
            self.heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
            self.isSelec = false
            self.recommendCount.text = String(heartnumber)
            model.recommendCount = heartnumber
            model.isSelected = isSelec
            print(model.recommendCount)
        }
        
        
    }
    
    
    
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        shareButtonTappedClosure?()
    }
    
    
}
