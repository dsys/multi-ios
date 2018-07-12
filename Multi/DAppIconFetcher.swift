//
//  DAppIconFetcher.swift
//  Multi
//
//  Created by Andrew Gold on 7/10/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import UIKit

struct IconCandidate {
    var url: URL?
    var fileType: String?
    var size: Int?
    
    func hasKnownFileType() -> Bool {
        return fileType == "png" || fileType == "jpeg" || fileType == "ico"
    }
}

extension String {
    func iconSizeFromSizeString() -> Int? {
        let components = self.split(separator: "x")
        for component in components {
            if let intValue = Int(component) {
                return intValue
            }
        }
        
        return nil
    }
    
    func iconSizeFromURLString() -> Int? {
        guard let regex = try? NSRegularExpression(pattern: "[0-9]+x[0-9]+", options: .caseInsensitive) else {
            return nil
        }
        
        let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        for match in matches {
            let range = match.range
            let substring = self[Index(encodedOffset: range.location)..<Index(encodedOffset: range.location + range.length)]
            if let size = String(substring).iconSizeFromSizeString() {
                return size
            }
        }
        
        return nil
    }
}

class DAppIconFetcher: NSObject {
    private let queue = DispatchQueue(label: "com.multi.DAppIconFetcher")
    private let idealIconSize: CGFloat = {
        return 72 * UIScreen.main.scale
    }()
    
    public func getBestIconForURL(_ url: URL, potentialIcons: [[String:String]]) -> URL? {
        var iconCandidate: IconCandidate?
        for dictionary in potentialIcons {
            var otherCandidate = IconCandidate()
            guard let relativeURL = dictionary["href"] else {
                break
            }
            
            otherCandidate.fileType = (relativeURL as NSString).pathExtension
            
            guard let url = URL(string: relativeURL, relativeTo: url) else {
                break
            }
            
            otherCandidate.url = url
            if let size = dictionary["size"]?.iconSizeFromSizeString() {
                otherCandidate.size = size
            } else if let size = url.absoluteString.iconSizeFromURLString() {
                otherCandidate.size = size
            }
            
            if let candidate = iconCandidate {
                iconCandidate = betterIconCandidate(firstIconCandidate: candidate, secondIconCandidate: otherCandidate)
            } else {
                iconCandidate = otherCandidate
            }
        }

        return iconCandidate?.url
    }
    
    public func fetchIconForAtURL(_ url: URL, completion: @escaping (Data?) -> Void) {
        queue.async {
            guard let data = try? Data(contentsOf: url) else {
                completion(nil)
                return
            }
            
            completion(data)
        }
    }
    
    private func betterIconCandidate(firstIconCandidate: IconCandidate, secondIconCandidate: IconCandidate) -> IconCandidate {
        if !firstIconCandidate.hasKnownFileType() {
            return secondIconCandidate
        }
        
        if !secondIconCandidate.hasKnownFileType() {
            return firstIconCandidate
        }
        
        if let firstSize = firstIconCandidate.size,
            let secondSize = secondIconCandidate.size {
            if abs(CGFloat(firstSize) - idealIconSize) < abs(CGFloat(secondSize) - idealIconSize) {
                return firstIconCandidate
            } else {
                return secondIconCandidate
            }
        } else {
            return firstIconCandidate
        }
        
    }
}
