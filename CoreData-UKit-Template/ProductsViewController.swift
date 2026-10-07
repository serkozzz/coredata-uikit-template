//
//  ProductsViewController.swift
//  SandboxUIKit
//
//  Created by Sergey Kozlov on 06.10.2026.
//

import SwiftUI

class ProductsViewController: UIViewController, UICollectionViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    var dataSource: UICollectionViewDiffableDataSource<String, ProductIdentifier>!
    
    let viewModel: ProductsViewModel = ProductsViewModel(productsService: ProductsService(managedContext: CoreDataStack.shared.managedContext))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        collectionView.register(UICollectionViewListCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.collectionViewLayout = createLayout()
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        
        dataSource = UICollectionViewDiffableDataSource<String, ProductIdentifier>(collectionView: collectionView) { [unowned self] collectionView, indexPath, identifier in
            
            let product = viewModel.product(forId: identifier)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! UICollectionViewListCell
            var conf = cell.defaultContentConfiguration()
            conf.text = product.name
            conf.secondaryText = "\(product.price)"
            cell.contentConfiguration = conf
            return cell
        }
        viewModel.onUpdate = { [unowned self]  in
            applySnapshot()
        }
        
        viewModel.onError = { msg in
            
        }
        
        
        applySnapshot()
    }
    
    func applySnapshot(animating: Bool = true) {
        dataSource.apply(viewModel.snapshot, animatingDifferences: animating)
    }
    
    @IBAction func removeFirst(_ sender: Any) {
        viewModel.removeFirstProduct()
    }
    
}




extension ProductsViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout () { [unowned self] sectionIndex, environment in
            
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .absolute(44))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.interGroupSpacing = 0
            section.contentInsets = .zero
            return section
        }
    }
}
