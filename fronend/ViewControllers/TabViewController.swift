//
//  TabViewController.swift
//  fronend
//
//  Created by Yosi Faroh Zada on 08/05/2023.
//

import UIKit

final class TabViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.viewControllers = [
            setPostsVC(),
            setCreatePostVC()
        ]
    }
    
    private func setPostsVC() -> UIViewController {
        let posts = PostsViewController()
        let nav = UINavigationController(rootViewController: posts)
        nav.navigationBar.prefersLargeTitles = true
        
        nav.tabBarItem = UITabBarItem(title: "Posts", image: UIImage(systemName: "message"), tag: 0)
        
        return nav
    }
    
    private func setCreatePostVC() -> UIViewController {
        let userPostsVC = UserPostsViewController()
        let nav = UINavigationController(rootViewController: userPostsVC)
        nav.navigationBar.prefersLargeTitles = true
        
        nav.tabBarItem = UITabBarItem(title: "User", image: UIImage(systemName: "profile"), tag: 0)
        
        return nav
    }

}
