//
//  UserPostsViewController.swift
//  fronend
//
//  Created by Yosi Faroh Zada on 08/05/2023.
//

import UIKit
import Kingfisher

final class UserPostsViewController: UIViewController {
    private lazy var viewModel = UserPostsViewModel(delegate: self)
    
    private lazy var postsTable = {
        let tableView = UITableView()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = PostCell.cellHeight
        tableView.register(PostCell.self, forCellReuseIdentifier: PostCell.cellIdentifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.fetchPosts()
    }
    
    private func configureView() {
        title = "User"
        view.backgroundColor = .white
        
        view.addSubviews([postsTable])
        
        postsTable.fillSuperview()
        
        navigationItem.rightBarButtonItem = .init(title: "New", style: .plain, target: self, action: #selector(didPressCreateNewPost))
    }
}

extension UserPostsViewController {
    @objc private func didPressCreateNewPost() {
        navigationController?.pushViewController(NewPostViewController(), animated: true)
    }
}

extension UserPostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.cellIdentifier, for: indexPath) as? PostCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: viewModel.posts[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let editPost = NewPostViewController(post: viewModel.posts[indexPath.row])
        navigationController?.pushViewController(editPost, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let prefetcher = ImagePrefetcher(urls: [ServerService.shared.getPostImageUrl(post: viewModel.posts[indexPath.row])])
        prefetcher.start()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PostCell.cellHeight
    }
}

extension UserPostsViewController: UserPostsViewModelProtocol {
    func didFinishLoadingUserPosts() {
        postsTable.reloadData()
    }
    
    func didFailedToLoadUserPosts() {
        let alert = UIAlertController(title: "Error", message: "Failed to load posts", preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}
