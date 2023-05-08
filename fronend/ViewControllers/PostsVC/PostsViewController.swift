//
//  PostsViewController.swift
//  fronend
//
//  Created by Yosi Faroh Zada on 08/05/2023.
//

import UIKit
import Kingfisher

final class PostsViewController: UIViewController {
    private lazy var viewModel = PostsViewModel(delegate: self)
    
    private lazy var searchBar = {
        let bar = UISearchBar()
        
        bar.delegate = self
        bar.placeholder = "Search"
        
        return bar
    }()
    
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
        title = "Posts"
        view.backgroundColor = .white
        
        view.addSubviews([searchBar, postsTable])
        
        searchBar.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        postsTable.anchor(top: searchBar.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
    }
    
}

extension PostsViewController: UITableViewDelegate, UITableViewDataSource {
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
        
        let vc = SinglePostViewController(post: viewModel.posts[indexPath.row])
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let prefetcher = ImagePrefetcher(urls: [ServerService.shared.getPostImageUrl(post: viewModel.posts[indexPath.row])])
        prefetcher.start()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return PostCell.cellHeight
    }
}

extension PostsViewController: PostsViewModelProtocol {
    func didFinishLoadingPosts() {
        postsTable.reloadData()
    }
    
    func didFailedToLoadPosts() {
        let alert = UIAlertController(title: "Error", message: "Failed to load posts", preferredStyle: .alert)
        alert.addAction(.init(title: "Ok", style: .default))
        present(alert, animated: true)
    }
}

extension PostsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterPosts(searchText: searchText)
        postsTable.reloadData()
    }
}
