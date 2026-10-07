//
//  Field.swift
//  tic tac toe
//
//  Created by Sergey Kozlov on 19.04.2025.
//

internal import CoreData

class ProductsRepository {
    
    private var context: NSManagedObjectContext
    
    init (context: NSManagedObjectContext) {
        self.context = context
    }
    
    public func product(with id: NSManagedObjectID) throws -> Product? {
        return try context.existingObject(with: id) as? Product
    }
    
    public func orderedProducts() throws -> [Product] {
        try context.fetch(ProductsRepository.orderedFetchRequest())
    }
    
    public func setProductPrice(_ price: Double, for id: ProductIdentifier) throws {
        try self.product(with: id)?.price = price
        try context.save()
    }
    
    public func setProductName(_ name: String, for id: ProductIdentifier) throws {
        try self.product(with: id)?.name = name
        try context.save()
    }
    
    public func removeProduct(with id: ProductIdentifier) throws {
        if let product = try product(with: id) {
            context.delete(product)
        }
    }
    
    public static func orderedFetchRequest() -> NSFetchRequest<Product> {
        let req = Product.fetchRequest()
        req.sortDescriptors = [
            NSSortDescriptor(key: #keyPath(Product.nameValue), ascending: true)
        ]
        return req
    }
}
