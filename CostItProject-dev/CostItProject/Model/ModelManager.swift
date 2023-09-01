//
//  ModelManager.swift
//  cucumberMarket
//
//  Created by 천광조 on 2023/08/14.
//

import UIKit

class ModelManager {
    var postManager: PostModel?
    var myPageModel: MyPageModel?
    
    
    // 모든 게시물
    var coment: [Comment] = [
        Comment(userId: "haha", comment: "haha")
        
    ]
    
    // 얻기
    func getPostArray() -> [PostModel] {
        return postArray
    }
    
    //나의 페이지 나의 정보
    
    
    func appendProfile(_ model: MyPageModel) {
        userArray.append(model)
    }
    
    //    func profileUpdate(userId: String) {
    //        myProfile.userId = userId
    //    }
    
    //    func updateAll(userId: String, userImage: UIImage, githubURL: String, blogURL: String) {
    //        myProfile.userId = userId
    //        myProfile.userImage = userImage
    //        myProfile.githubURL = githubURL
    //        myProfile.blogURL = blogURL
    //    }
    
    
    // 게시물 삭제
    func deletePost(_ posts: PostModel) {
        if let index = postArray.firstIndex(where: { $0.postNumber == posts.postNumber }) {
            postArray.remove(at: index)
        }
//        for index in 0 ..< postArray.count {
//            if postArray[index].postNumber == posts.postNumber {
//                postArray.remove(at: index)
//                // 해당 객체를 찾았으니 루프를 종료합니다.
//            }
//        }
    }
    
    func timeAgoString(from date: Date) -> String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.second, .minute, .hour, .day], from: date, to: now)
        
        if let day = components.day, day > 0 {
            return "\(day)일 전"
        }
        if let hour = components.hour, hour > 0 {
            return "\(hour)시간 전"
        }
        if let minute = components.minute, minute > 0 {
            return "\(minute)분 전"
        }
        if let second = components.second, second >= 0 {
            return "지금"
        }
        
        return ""
    }
    
    
    func updatePost(at index: Int, wiht post: PostModel) {
        postArray[index] = post
    }
    
}

var postArray = [
    PostModel(userId: "test-ID1",
              title: "코딩이란 무엇인가?",
              postImage: UIImage(systemName: "person")!,
              content: "hahahahahahaha hahahahahahaha hahahahahahaha hahahahahahaha hahahahahahaha hahahahahahaha",
              hashTag: ["iOS", "Swift", "View", "Controller", "TableView", "iOS", "Swift", "iOS", "Swift", "View", "Controller", "TableView", "iOS", "Swift"],
              comment: []),
        
    PostModel(userId: "test-ID22",
              title: "iOS의 시작",
              postImage: UIImage(systemName: "photo")!,
              content: "hahahahahahaha",
              hashTag: ["iOS","Swift","View","Controller","TableView","iOS","Swift"],
              comment: [])
]



var userArray:[MyPageModel] = []

