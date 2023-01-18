//
//  ArticleCollectionViewCell.swift
//  Articles
//
//  Created by Marat on 18.01.2023.
//

import UIKit

final class ArticleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: ArticleCollectionViewCell.self)
    
    public let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = .systemFont(ofSize: 18)
        lbl.textAlignment = .left
        lbl.numberOfLines = 0
        return lbl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        backgroundColor = .white
        
        [articleImageView, titleLabel].forEach { contentView.addSubview($0) }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        articleImageView.image = nil
        titleLabel.text = ""
    }
    
    private func setupConstraints() {
        setupArticleImageViewConstraints()
        setupTitleLabelConstraints()
    }
    
    private func setupArticleImageViewConstraints() {
        articleImageView.backgroundColor = .blue
        articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        articleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func setupTitleLabelConstraints() {
        titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    public func set(with article: Article) {
        titleLabel.text = article.title
    }
}
