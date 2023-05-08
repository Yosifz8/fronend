//
//  UserPostsViewModel.swift
//  fronend
//
//  Created by Yosi Faroh Zada on 08/05/2023.
//

import Foundation

protocol UserPostsViewModelProtocol {
    func didFinishLoadingUserPosts()
    func didFailedToLoadUserPosts()
}

final class UserPostsViewModel {
    private let delegate: UserPostsViewModelProtocol
    var posts = [Post]()
    
    init(delegate: UserPostsViewModelProtocol) {
        self.delegate = delegate
    }
    
    func fetchPosts() {
        ServerService.shared.getPosts(userPosts: true, username: LoginService.shared.username) { [weak self] result  in
            switch result {
            case .success(let posts):
                self?.posts.removeAll()
                self?.posts.append(contentsOf: posts)
                
                DispatchQueue.main.async {
                    self?.delegate.didFinishLoadingUserPosts()
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.delegate.didFailedToLoadUserPosts()
                }
            }
        }
    }
}
