//
//  ArticleCollectionViewCell.swift
//  Articles
//
//  Created by Marat on 18.01.2023.
//

import UIKit

final class ArticleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = String(describing: ArticleCollectionViewCell.self)
    
    public override var isSelected: Bool {
        didSet { isSelected ? (layer.borderWidth = 3) : (layer.borderWidth = 0) }
    }
    
    public let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        isSelected = false
        backgroundColor = .white
        layer.borderColor = UIColor(red: 122/255, green: 149/255, blue: 244/255, alpha: 1.0).cgColor
        
        [articleImageView, blurView].forEach { contentView.addSubview($0) }
        blurView.contentView.addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupConstraints()
        self.layer.cornerRadius = 15
        
        articleImageView.layer.cornerRadius = 15
        articleImageView.clipsToBounds = true
        blurView.layer.cornerRadius = 15
        blurView.clipsToBounds = true
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        isSelected = false
        articleImageView.image = nil
        titleLabel.text = ""
    }
    
    private func setupConstraints() {
        setupArticleImageViewConstraints()
        setupBlurViewConstraints()
        setupTitleLabelConstraints()
    }
    
    private func setupArticleImageViewConstraints() {
//        articleImageView.backgroundColor = .blue
        articleImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        articleImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        articleImageView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        articleImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func setupBlurViewConstraints() {
        blurView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        blurView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
        blurView.topAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -10).isActive = true
        blurView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
    private func setupTitleLabelConstraints() {
        titleLabel.leadingAnchor.constraint(equalTo: blurView.leadingAnchor, constant: 10).isActive = true
        titleLabel.trailingAnchor.constraint(equalTo: blurView.trailingAnchor, constant: -10).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: blurView.bottomAnchor, constant: -10).isActive = true
    }
    
    public func set(with article: Article) {
        titleLabel.text = article.title
    }
}
