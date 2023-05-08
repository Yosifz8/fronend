//
//  SinglePostViewController.swift
//  fronend
//
//  Created by Yosi Faroh Zada on 08/05/2023.
//

import UIKit

final class SinglePostViewController: UIViewController {
    
    private let post: Post
    
    init(post: Post) {
        self.post = post
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
    }
    
    private func configureView() {
        title = "Post"
        view.backgroundColor = .white
        
        let postImage = {
            let imgView = UIImageView()
            
            imgView.contentMode = .scaleAspectFit
            imgView.kf.setImage(with: ServerService.shared.getPostImageUrl(post: post))
            
            return imgView
        }()
        
        let titleLabel = {
            let label = UILabel()
            
            label.text = post.title
            
            return label
        }()
        
        let descriptionLabel = {
            let label = UILabel()
            
            label.text = post.description
            
            return label
        }()
        
        let whatsappButton = {
            let btn = UIButton()
            
            btn.setTitle("Share whatsapp", for: .normal)
            btn.setTitleColor(.black, for: .normal)
            
            btn.addTarget(self, action: #selector(didPressShareWhatsappButton), for: .touchUpInside)
            
            return btn
        }()
        
        let showOnMapButton = {
            let btn = UIButton()
            
            btn.setTitle("Show on map", for: .normal)
            btn.setTitleColor(.black, for: .normal)
            
            if post.latitude == nil && post.latitude == nil {
                btn.isHidden = true
            }
            
            btn.addTarget(self, action: #selector(didPressShowOnMapButton), for: .touchUpInside)
            
            return btn
        }()
        
        view.addSubviews([postImage, titleLabel, descriptionLabel, whatsappButton, showOnMapButton])
        
        postImage.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: nil, bottom: nil, trailing: nil, size: .init(width: 200, height: 200))
        postImage.centerXToSuperview()
        
        titleLabel.anchor(top: postImage.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        
        whatsappButton.anchor(top: descriptionLabel.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        
        showOnMapButton.anchor(top: whatsappButton.bottomAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: nil, trailing: view.safeAreaLayoutGuide.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
    }
}

extension SinglePostViewController {
    @objc private func didPressShareWhatsappButton() {
        let originalString = ServerService.shared.getPostUrl(post: post)
        let escapedString = originalString.addingPercentEncoding(withAllowedCharacters:CharacterSet.urlQueryAllowed)
        let url  = URL(string: "whatsapp://send?text=\(escapedString!)")
        
        if UIApplication.shared.canOpenURL(url! as URL) {
            UIApplication.shared.open(url! as URL, options: [:], completionHandler: nil)
        }
    }
    
    @objc private func didPressShowOnMapButton() {
        let mapVC = MapViewController(post: post)
        navigationController?.pushViewController(mapVC, animated: true)
    }
}
