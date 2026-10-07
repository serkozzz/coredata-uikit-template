//
//  ProductsViewModel.swift
//  SandboxUIKit
//
//  Created by Sergey Kozlov on 06.10.2026.
//

import UIKit
import Combine
internal import CoreData

class ProductsViewModel {
    private let productsService: ProductsService
    
    var snapshot: ProductsSnapshot { productsService.snapshot }
    var onUpdate: (() -> Void)?
    var onError: ((String) -> Void)?
    var disableUpdate: Bool = false
    
    init(productsService: ProductsService) {

        self.productsService = productsService
        
        self.productsService.onCollectionUpdate = { [weak self]  in
            guard let self else { return }
            if (self.disableUpdate) { return }
            self.onUpdate?()
        }
        
        self.productsService.onItemUpdate = { [weak self]  in
            guard let self else { return }
            if (self.disableUpdate) { return }
            self.onUpdate?()
        }
    }

    
    func product(forId id: ProductIdentifier) -> Product {
        productsService.product(with: id)
    }
    
    func removeFirstProduct() {
        do {
            if let firstId = productsService.orderedProducts().first?.objectID {
                try productsService.removeProduct(with: firstId)
                return
            }
            onError?("Could not remove product")
        }
        catch {
            onError?("Could not remove product")
        }
    }
}
