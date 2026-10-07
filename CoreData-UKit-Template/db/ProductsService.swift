//
//  CellService.swift
//  tic tac toe
//
//  Created by Sergey Kozlov on 19.04.2025.
//
internal import CoreData
import UIKit


typealias ProductIdentifier = NSManagedObjectID
typealias ProductsSnapshot = NSDiffableDataSourceSnapshot<String, ProductIdentifier>

class ProductsService: NSObject, NSFetchedResultsControllerDelegate {
   
    private let managedContext: NSManagedObjectContext
    private let repository: ProductsRepository
    
    private var resultsController: NSFetchedResultsController<Product>!
    public var snapshot: ProductsSnapshot!
   
    private enum ChangeType {
        case collection
        case item
    }
    
    public var onItemUpdate: (() -> Void)?
    public var onCollectionUpdate: (() -> Void)?
    
    public init(managedContext: NSManagedObjectContext) {
        self.managedContext = managedContext
        self.repository = ProductsRepository(context: managedContext)
        super.init()
        updateRequest()
    }
    
    public func orderedProducts() -> [Product] {
        try! repository.orderedProducts()
    }
    
    public func product(with id: ProductIdentifier) -> Product {
        try! repository.product(with: id)!
    }
    
    public func setProductPrice(_ price: Double, for id: ProductIdentifier) throws  {
        do {
            try repository.setProductPrice(price, for: id)
        }
        catch {
            throw DBError.unableToUpdateProduct
        }
    }
    
    public func setProductName(_ name: String, for id: ProductIdentifier) throws  {
        do {
            try repository.setProductName(name, for: id)
        }
        catch {
            throw DBError.unableToUpdateProduct
        }
    }
    
    public func removeProduct(with id: ProductIdentifier) throws {
        do {
            try repository.removeProduct(with: id)
        }
        catch {
            throw DBError.unableToUpdateProduct
        }
    }
    
    
    public func controller(
        _ controller: NSFetchedResultsController<any NSFetchRequestResult>,
        didChangeContentWith newSnapshot: NSDiffableDataSourceSnapshotReference
    ) {

        let newSnapshot = newSnapshot as ProductsSnapshot
               
        let changeType: ChangeType
        if let oldSnapshot = snapshot {
            changeType = oldSnapshot.itemIdentifiers != newSnapshot.itemIdentifiers ? .collection : .item
        } else {
            changeType = .collection // Первый снимок всегда считается изменением коллекции
        }
        
        snapshot = newSnapshot
        
        switch changeType {
        case .collection:
            onCollectionUpdate?()
            break
        case .item:
            onItemUpdate?()
        }
    }
    
    private func updateRequest() {
        let fetchRequest = ProductsRepository.orderedFetchRequest()
        resultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: managedContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        resultsController.delegate = self
        try! resultsController.performFetch()
    }
}
