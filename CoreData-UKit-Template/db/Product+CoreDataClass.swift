//
//  Product+CoreDataClass.swift
//  SandboxUIKit
//
//  Created by Sergey Kozlov on 06.10.2026.
//
//

public import Foundation
public import CoreData

public typealias ProductCoreDataClassSet = NSSet

@objc(Product)
public class Product: NSManagedObject {
    var name: String {
        get {
            self.nameValue!
        }
        set {
            self.nameValue = newValue
        }
    }
    
    var price: Double {
        get {
            self.priceValue
        }
        set {
            self.priceValue = newValue
        }
    }
}
