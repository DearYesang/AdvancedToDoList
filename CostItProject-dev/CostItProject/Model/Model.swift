//
//  Model.swift
//  cucumberMarket
//
//  Created by 천광조 on 2023/08/14.
//

import UIKit

// 게시글 관련 모델

struct PostModel {
    static var number = 0
    
    var postNumber: Int
    var userId: String
    var title: String
    var postImage: UIImage
    var content: String
    var hashTag: [String]
    var comment: [Comment]
    var recommendCount: Int
    var isSelected: Bool
    let date = Date()
    

    init(userId: String, title: String, postImage: UIImage, content: String, hashTag: [String], comment: [Comment]) {
        self.postNumber = PostModel.number
        self.userId = userId
        self.title = title
        self.postImage = postImage
        self.content = content
        self.hashTag = hashTag
        self.comment = comment
        self.recommendCount = 0
        self.isSelected = false
        PostModel.number += 1
    }
    
//    mutating func updateRecommendCount(_ count: Int, _ selected: Bool) {
//        self.recommendCount = count
//        self.isSelected = selected
//    }
//
//    mutating func addComment(_ comment: Comment) {
//        self.comment.append(comment)
//    }
}
    
// 마이페이지 모델
struct MyPageModel {
    var userId: String
    var userImage: UIImage
    var githubURL: String
    var blogURL: String
}
    
struct Comment {
    static var commentNum = 0
    var commentNumber: Int
    var userId: String
    var comment: String
        
    init(userId: String, comment: String) {
        self.commentNumber = Comment.commentNum
        self.userId = userId
        self.comment = comment
        Comment.commentNum += 1
    }
}
    
//
