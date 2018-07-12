//
//  DAppManager.swift
//  Multi
//
//  Created by Andrew Gold on 7/9/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import CoreData
import Foundation
import UIKit

extension Notification.Name {
    static let didUpdateDAppIcon = Notification.Name("DidUpdateDAppIcon")
}

class DAppManager: NSObject {
    private static var sharedManagerInstance: DAppManager?
    public static var sharedManager: DAppManager? {
        get {
            return sharedManagerInstance
        }
        set (newSharedManager) {
            assert(sharedManagerInstance == nil)
            sharedManagerInstance = newSharedManager
        }
    }
    private let iconFetcher = DAppIconFetcher()
    private let defaultDAppsVersionKey = "DefaultDAppsVersion"
    private let versionKey = "version"
    private let dAppsKey = "dApps"
    private let nameKey = "name"
    private let urlKey = "url"
    private let managedObjectContext: NSManagedObjectContext
    public private(set) lazy var dApps: [DApp] = {
        return fetchDApps()
    }()
    private var dAppToIconMap = [String:UIImage]()
    private var iconsDirectoryURL: URL?
    
    init(managedObjectContext: NSManagedObjectContext) {
        self.managedObjectContext = managedObjectContext
        super.init()
    }
    
    public func foundPotentialIconsForDApp(_ dApp: DApp, url: URL, potentialIcons: [[String:String]]) {
        guard let iconURL = iconFetcher.getBestIconForURL(url, potentialIcons: potentialIcons) else { return }
        dApp.iconURL = iconURL.absoluteString
        fetchIconForDApp(dApp, iconURL: iconURL)
    }
    
    public func iconForDApp(_ dApp: DApp) -> UIImage? {
        return dAppToIconMap[dApp.name!]
    }
    
    private func fetchIconForDApp(_ dApp: DApp, iconURL: URL) {
        iconFetcher.fetchIconForAtURL(iconURL) { (data) in
            if let iconData = data {
                self.didFetchIconData(iconData, iconURL: iconURL, dApp: dApp)
            }
        }
    }
    
    private func didFetchIconData(_ iconData: Data, iconURL: URL, dApp: DApp) {
        dAppToIconMap[dApp.name!] = UIImage(data: iconData)
        NotificationCenter.default.post(name: .didUpdateDAppIcon, object: self)
        let fileName = fileNameForIcon(iconURL: iconURL, dApp: dApp)
        let filePath = iconsDirectory()!.appendingPathComponent(fileName)
        try? iconData.write(to: filePath)
        dApp.iconFileName = fileName
    }
    
    private func iconsDirectory() -> URL? {
        if iconsDirectoryURL != nil {
            return iconsDirectoryURL
        }
        
        let iconPath = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!).appendingPathComponent("icons")
        var isDirectory = ObjCBool(true)
        if !FileManager.default.fileExists(atPath: iconPath.path, isDirectory: &isDirectory) {
            do {
                try FileManager.default.createDirectory(atPath: iconPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
                return nil
            }
        }
        
        iconsDirectoryURL = iconPath
        return iconPath
    }
    
    private func fileNameForIcon(iconURL: URL, dApp: DApp) -> String {
        return dApp.name! + "_icon." + (iconURL.absoluteString as NSString).pathExtension
    }
    
    private func fetchDApps() -> [DApp] {
        storeDefaultDAppsIfNeeded()

        guard let dApps = try? managedObjectContext.fetch(NSFetchRequest<DApp>(entityName: "DApp")) else {
            return Array()
        }
        
        for dApp in dApps {
            if let iconFileName = dApp.iconFileName {
                let path = iconsDirectory()!.appendingPathComponent(iconFileName).path
                if let image = UIImage(contentsOfFile: path) {
                    dAppToIconMap[dApp.name!] = image
                }
            } else if let iconURL = dApp.iconURL {
                fetchIconForDApp(dApp, iconURL: URL(string: iconURL)!)
            }
        }
        
        return dApps
    }
    
    private func storeDefaultDAppsIfNeeded() {
        guard let defaults = defaultDApps() else {
            assertionFailure()
            return
        }

        let userDefaults = UserDefaults.standard
        let version = defaults[versionKey] as! Int
        if userDefaults.integer(forKey: defaultDAppsVersionKey) >= version {
            return
        }
    
        for dictionary in defaults[dAppsKey] as! [[String:String]] {
            managedObjectContext.insert(defaultDAppForDictionary(dictionary: dictionary))
        }
        
        userDefaults.set(version, forKey: defaultDAppsVersionKey)
    }
    
    private func defaultDApps() -> [String:Any]? {
        guard let path = Bundle.main.url(forResource: "DefaultDApps", withExtension: "plist"),
            let data: Data = try? Data(contentsOf: path),
            let dictionary = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as! [String:Any] else {
            assertionFailure()
            return nil
        }

        return dictionary
    }
    
    private func defaultDAppForDictionary(dictionary: [String:String]) -> DApp {
        let dApp = DApp(context: managedObjectContext)
        dApp.name = dictionary[nameKey]
        dApp.url = dictionary[urlKey]
        dApp.isDefault = true
        return dApp
    }
}
