//
//  ArticlesCollectionView.swift
//  Articles
//
//  Created by Marat on 18.01.2023.
//

import UIKit

final class ArticlesCollectionViewController: UICollectionViewController {
    
    private var articles: Articles?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

