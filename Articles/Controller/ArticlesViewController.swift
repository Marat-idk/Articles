//
//  ArticlesCollectionViewController.swift
//  Articles
//
//  Created by Marat on 18.01.2023.
//

import UIKit
import Kingfisher

final class ArticlesViewController: UIViewController {
    
    private var articles: Articles?
    private var dataSource: UICollectionViewDiffableDataSource<Section, Article>?
    private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createCollectionView()
        view.addSubview(collectionView)
        setupConstraints()
        fetchData()
        createDataSource()
        reloadData()
    }
    
    private func createCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        
        collectionView.register(
            ArticleCollectionViewCell.self,
            forCellWithReuseIdentifier: ArticleCollectionViewCell.identifier)
        
        collectionView.register(
            SectionHeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: SectionHeaderView.identifier)
        
        collectionView.delegate = self
    }
    
    private func setupConstraints() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                collectionView.topAnchor.constraint(equalTo: view.topAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ]
        )
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
    
    // MARK: CompositionalLayout and DiffableDataSource
    
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
        item.contentInsets = .init(
                                top: ItemSizeConstants.topIndent,
                                leading: ItemSizeConstants.leadingIndent,
                                bottom: ItemSizeConstants.bottomIndent,
                                trailing: ItemSizeConstants.trailingIndent)
        
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(ItemSizeConstants.itemWidth),
            heightDimension: .estimated(ItemSizeConstants.itemHeight))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets = .init(top: 10, leading: 10, bottom: 20, trailing: 10)
        
        let header = createSectionHeader()
        section.boundarySupplementaryItems = [header]
        
        return section
    }
    
    // создание хедера секции
    private func createSectionHeader() -> NSCollectionLayoutBoundarySupplementaryItem {
        let sectionHeaderSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .estimated(30))
        
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: sectionHeaderSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        sectionHeader.contentInsets = .init(top: 0, leading: 8, bottom: 0, trailing: 8)
        
        return sectionHeader
    }
    
    private func createDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, Article>(collectionView: collectionView, cellProvider: { [weak self] (collectionView, indexPath, item) -> UICollectionViewCell in
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ArticleCollectionViewCell.identifier, for: indexPath) as? ArticleCollectionViewCell else {
                return UICollectionViewCell()
            }
            
            let section = indexPath.section
            let item = indexPath.item
            let article = self?.articles?.sections?[section].items?[item] ?? Article.defaultArticle
            
            cell.set(with: article)
            cell.articleImageView.kf.setImage(with: URL(string: article.image?.the3X ?? DataSources.noImage.rawValue))
            
            return cell
        })
        dataSource?.supplementaryViewProvider = { [weak self]
            collectionView, kind, indexPath in
            
            // получаем необходмый хедер
            guard let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderView.identifier, for: indexPath) as? SectionHeaderView else {
                return nil
            }
            
            // получаем текущий элемент
            guard let article = self?.dataSource?.itemIdentifier(for: indexPath) else {
                return nil
            }
            
            // и по нему получаем секцию, в которой он находится
            guard let section = self?.dataSource?.snapshot().sectionIdentifier(containingItem: article) else {
                return nil
            }
            
            // получаем хедер секции
            guard let header = section.header else {
                return nil
            }
            
            sectionHeader.title = header
            return sectionHeader
            
        }
    }
    
    private func reloadData() {
        guard let sections = articles?.sections else { return }
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Article>()
        
        snapshot.appendSections(sections)
        
        for section in sections {
            if let items = section.items {
                snapshot.appendItems(items, toSection: section)
            }
        }
        dataSource?.apply(snapshot)
    }
}

// MARK: CollectionViewDelegate

extension ArticlesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ArticleCollectionViewCell else { return }
        cell.isSelected = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ArticleCollectionViewCell else { return }
        cell.isSelected = false
    }
}

struct ItemSizeConstants {
    static let leadingIndent = 8.0
    static let trailingIndent = 8.0
    static let topIndent = 8.0
    static let bottomIndent = 8.0
    static let itemWidth = (UIScreen.main.bounds.width - leadingIndent - trailingIndent) / 2
    static let itemHeight = (UIScreen.main.bounds.height - topIndent - bottomIndent) / 3.2
}
