//
//  PostsViewModel.swift
//  fronend
//
//  Created by Yosi Faroh Zada on 08/05/2023.
//

import Foundation

protocol PostsViewModelProtocol {
    func didFinishLoadingPosts()
    func didFailedToLoadPosts()
}

final class PostsViewModel {
    
    private let delegate: PostsViewModelProtocol
    private var results = [Post]()
    var posts = [Post]()
    
    init(delegate: PostsViewModelProtocol) {
        self.delegate = delegate
    }
    
    func fetchPosts() {
        ServerService.shared.getPosts(userPosts: false, username: LoginService.shared.username) { [weak self] result  in
            switch result {
            case .success(let posts):
                self?.results.removeAll()
                self?.results.append(contentsOf: posts)
                
                self?.posts.removeAll()
                self?.posts.append(contentsOf: posts)
                
                DispatchQueue.main.async {
                    self?.delegate.didFinishLoadingPosts()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.delegate.didFailedToLoadPosts()
                }
            }
        }
    }
    
    func filterPosts(searchText:String) {
        if searchText.isEmpty {
            posts.removeAll()
            posts.append(contentsOf: results)
            return
        }
        
        posts.removeAll()
        posts = results.filter({ $0.title.contains(searchText) || $0.description.contains(searchText) })
    }
}
