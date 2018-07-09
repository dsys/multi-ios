//
//  DAppManager.swift
//  Multi
//
//  Created by Andrew Gold on 7/9/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import CoreData
import Foundation

class DAppManager: NSObject {
    private let hasStoredDefaultDAppsKey = "HasStoredDefaultDApps"
    private let nameKey = "name"
    private let urlKey = "url"

    private let managedObjectContext: NSManagedObjectContext
    public private(set) lazy var dApps: [DApp] = {
        return fetchDApps()
    }()
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        super.init()
    }
    
    private func fetchDApps() -> [DApp] {
        storeDefaultDAppsIfNeeded()

        guard let dApps = try? managedObjectContext.fetch(NSFetchRequest<DApp>(entityName: "DApp")) else {
            return Array()
        }
        
        return dApps
    }
    
    private func storeDefaultDAppsIfNeeded() {
        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: hasStoredDefaultDAppsKey) {
            return
        }
        
        storeDefaultDApps()
        userDefaults.set(true, forKey: hasStoredDefaultDAppsKey)
    }
    
    private func storeDefaultDApps() {
        guard let path = Bundle.main.url(forResource: "DefaultDApps", withExtension: "plist") else {
            assertionFailure()
            return
        }

        guard let data: Data = try? Data(contentsOf: path) else {
            assertionFailure()
            return
        }
        
        guard let array = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [[String:String]] else {
            assertionFailure()
            return
        }

        for dictionary in array {
            managedObjectContext.insert(dAppForDictionary(dictionary: dictionary))
        }
    }
    
    private func dAppForDictionary(dictionary: [String:String]) -> DApp {
        let dApp = DApp(context: managedObjectContext)
        dApp.name = dictionary[nameKey]
        dApp.url = dictionary[urlKey]
        return dApp
    }
}
