//
//  PostCell.swift
//  fronend
//
//  Created by Yosi Faroh Zada on 08/05/2023.
//

import UIKit

class PostCell: UITableViewCell {
    static let cellIdentifier = "postcell"
    static let cellHeight = 88.0
    
    private let nameLabel = {
        let label = UILabel()
        
        return label
    }()
    
    private let customImageView = {
        let imgView = UIImageView()
        
        return imgView
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubviews([customImageView, nameLabel])
        addConstraint()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addConstraint() {
        customImageView.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView.bottomAnchor, trailing: nil, size: .init(width: PostCell.cellHeight, height: PostCell.cellHeight))
        customImageView.centerYToSuperview()
        
        nameLabel.anchor(top: contentView.topAnchor, leading: customImageView.trailingAnchor, bottom: contentView.bottomAnchor, trailing: nil, padding: .init(top: 0, left: 10.0, bottom: 0, right: 0))
        nameLabel.centerYToSuperview()
    }
    
    override func prepareForReuse() {
        nameLabel.text = ""
        customImageView.image = nil
    }
    
    public func configure(with post:Post) {
        nameLabel.text = post.title
        customImageView.kf.setImage(with: ServerService.shared.getPostImageUrl(post: post))
    }
}
