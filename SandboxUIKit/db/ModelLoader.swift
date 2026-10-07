//
//  ModelLoader.swift
//  SandboxUIKit
//
//  Created by Sergey Kozlov on 06.10.2026.
//

import Foundation
internal import CoreData

class ModelLoader {
    func createDBIfDoesntExist() {
        let context = CoreDataStack.shared.managedContext
        
        let request: NSFetchRequest<Product> = Product.fetchRequest()
        let count = try! context.count(for: request)
        if count > 0 {
            return
        }
        let p1 = Product(context: context)
        p1.name = "арбуз"
        p1.price = 100
        
        let p2 = Product(context: context)
        p2.name = "батон"
        p2.price = 80
        
        let p3 = Product(context: context)
        p3.name = "колбаса"
        p3.price = 380
        
        try! context.obtainPermanentIDs(for: [p1, p2, p3])
        try! context.save()
    }
}
