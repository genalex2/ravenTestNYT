//
//  Strings+Extensions.swift
//  ravenTestNYT
//
//  Created by Genaro Alexis Nuño Valenzuela on 01/12/24.
//

import Foundation
import UIKit

extension String {
    
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
    
    func localized(comment: String = "") -> String {
        return NSLocalizedString(self, comment: comment)
    }
    
    func localized(formatArgs: CVarArg...) -> String {
        let stringArgs: [String] = formatArgs.map { String(describing: $0) }
        let cVarArgs: [CVarArg] = stringArgs.map { $0 as CVarArg }
        return withVaList(cVarArgs) {
            NSString(format: NSLocalizedString(self, comment: ""), arguments: $0)
        } as String
    }
    
    func localizedFromTable(table: String) -> String {
        return Bundle.main.localizedString(forKey: self, value: nil, table: table)
    }
}
