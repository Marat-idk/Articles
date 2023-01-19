//
//  SectionHeaderView.swift
//  Articles
//
//  Created by Marat on 19.01.2023.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView {
    
    public var title: String? {
        didSet { headerLabel.text = title }
    }
    
    private let headerLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.textColor = .black
        lbl.font = .boldSystemFont(ofSize: 24)
        lbl.textAlignment = .left
        return lbl
    }()
    
    static let identifier = String(describing: SectionHeaderView.self)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(headerLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupHeaderLabelConstraints()
    }
    
    private func setupHeaderLabelConstraints() {
        headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        headerLabel.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
