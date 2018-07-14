//
//  StringUtilities.swift
//  Multi
//
//  Created by Andrew Gold on 7/13/18.
//  Copyright © 2018 Distributed Systems, Inc. All rights reserved.
//

import Foundation

extension String {
    func numbersOnly() -> String {
        return self.filter { (character) -> Bool in
            return character >= "0" && character <= "9"
        }
    }
}
