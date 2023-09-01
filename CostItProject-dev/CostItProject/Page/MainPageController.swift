//
//  ViewController.swift
//  cucumberMarket
//
//  Created by 천광조 on 2023/08/14.
//

import UIKit

class MainPageController: UIViewController {
    @IBOutlet var tableView: UITableView!
    
    let searchController = UISearchController()
    var modelManager = ModelManager()

    var userIdStatus = false
    
    var searchArray: [PostModel] = []
    var isSearching = false
//    var model:[PostModel]? {
//        didSet{
//            model = modelManager.postArray
//        }
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupSearchBar()
        tableView.rowHeight = 120
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !userIdStatus {
            let vc = UserIdViewController(modelManager: modelManager)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false, completion: nil)
        }
        
        tableView.reloadData()
    }
    
    func setupUI() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // 서치바
    func setupSearchBar() {
        navigationItem.title = "Home"
        navigationItem.searchController = searchController
        // (단순)서치바의 사용 - 대리자
        searchController.searchBar.delegate = self
        
        // 첫글자 대문자 설정 없애기
        searchController.searchBar.autocapitalizationType = .none
        
        searchController.automaticallyShowsCancelButton = true
        
        // UISearchController 인스턴스 최기화 설정
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "검색어를 입력하세요"
    }
    
    // 게시물 공유 함수
    func share(index: IndexPath) {
        let objectsToShare = modelManager.getPostArray()[index.row]
        let activityVC = UIActivityViewController(activityItems: [objectsToShare.title], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = view
        // 제외할 것이 있는 경우
        // activityVC.excludedActivityTypes = [UIActivityType.airDrop, UIActivityType.addToReadingList]
        present(activityVC, animated: true)
    }
}

// MARK: - 확장

// 테이블 뷰 프로토콜
extension MainPageController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearching ? searchArray.count : modelManager.getPostArray().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mainCell", for: indexPath) as! MainPageTableViewCell
        
        var index = isSearching ? searchArray[indexPath.row] : modelManager.getPostArray()[indexPath.row]
        cell.model = index
        
        // 해시태그 스트링 값으로
        let hashtag = index.hashTag.map { String($0) }.joined(separator: ",")
        cell.hashTag.text = hashtag
        
        // 시간 할당.
        cell.postDate.text = modelManager.timeAgoString(from: index.date)
        
        // isSelected
//        cell.isSelec = index.isSelected
        
        index.recommendCount = cell.heartnumber
        index.isSelected = cell.isSelec
        modelManager.updatePost(at: indexPath.row, wiht: index)
        
        // 버튼 클로저 실행
        cell.shareButtonTappedClosure = { [weak self] in
            guard let self = self else { return }
            self.share(index: indexPath)
            tableView.reloadData()
        }
        return cell
    }
}

extension MainPageController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let detailVC = storyboard?.instantiateViewController(withIdentifier: "DetailPageViewController") as? DetailPageViewController
        
        let index = modelManager.getPostArray()[indexPath.row]
        detailVC?.models = index
        detailVC?.modelManagers = modelManager
        navigationController?.pushViewController(detailVC!, animated: true)

    }
}

// 서치바 델리게이트
extension MainPageController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        // 빈 배열로 시작
        searchArray = modelManager.getPostArray().filter { $0.title.contains(searchText.lowercased()) }
        // 배열 추가
        isSearching = !searchText.isEmpty
        tableView.reloadData()
    }

//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let text = searchController.searchBar.text else {
//            return
//        }
//        print(text)
//        // 다시 빈 배열로 만들기 ⭐️
//
//        // 등록되어 있는 데이터 배열 로드
//        searchArray = modelManager.getPostArray().filter({$0.content.contains(text)})
//        // 배열 추가
//        isSearching = !text.isEmpty
//
//        self.view.endEditing(true)
//    }
}

// 실시간 검색 결과 업데이트
extension MainPageController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        searchArray = modelManager.getPostArray().filter { $0.title.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }
}
