//
//  ArticlesCollectionViewController.swift
//  Articles
//
//  Created by Marat on 18.01.2023.
//

import UIKit

final class ArticlesViewController: UIViewController {
    
    private var articles: Articles?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Article>?
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createCollectionView()
        view.addSubview(collectionView)
        fetchData()
        createDataSource()
        reloadData()
    }
    
    private func createCollectionView() {
        collectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: createCompositionalLayout())
        collectionView.register(
            ArticleCollectionViewCell.self,
            forCellWithReuseIdentifier: ArticleCollectionViewCell.identifier)
    }
    
    private func fetchData() {
        DataManager.shared.getArticles { [weak self] result in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let articles):
                self?.articles = articles
            }
        }
    }
    
    private func createCompositionalLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, layoutEnvironment) -> NSCollectionLayoutSection? in
            
            guard let _ = self.articles?.sections?[sectionIndex] else { return nil }
            
            return self.createArticlesSection()
        }
        return layout
    }
    
    // создание секции
    private func createArticlesSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1))
        
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(200),
            heightDimension: .estimated(100))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 55, leading: 20, bottom: 0, trailing: 20)
        
        return section
    }
    
    func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Article>(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCollectionViewCell.identifier, for: indexPath) as? ArticleCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let section = indexPath.section
            let item = indexPath.item
            let article = self?.articles?.sections?[section].items?[item] ?? Article.defaultArticle
            
            
            
            cell.set(with: article)
            
            return cell
        })
    }
    
    func reloadData() {
        guard let sections = articles?.sections else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
        
        snapshot.appendSections(sections)
        
        for section in sections {
            // FIXME: fix forced unwrap
            snapshot.appendItems(section.items!, toSection: section)
        }
        dataSource?.apply(snapshot)
    }
}
