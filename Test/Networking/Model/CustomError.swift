//
//  CustomError.swift
//  
//
//  Created by vladimir.kuzomenskyi on 15.05.2022.
//

import Foundation

class CustomError: NSError {
    var title: String?
    var errorDescription: String
    var errorCode: Int
    
    override var code: Int {
        return errorCode
    }
    
    override var description: String {
        return errorDescription
    }

    override var localizedDescription: String {
        return errorDescription
    }
    
    init(_ description: String, code: Int) {
        self.title = "Error"
        self.errorDescription = description
        self.errorCode = code
        super.init(domain: "", code: code, userInfo: nil)
    }
    
    init(_ description: String) {
        self.title = "Error"
        self.errorDescription = description
        let defaultCode = -1
        self.errorCode = defaultCode
        super.init(domain: "", code: defaultCode, userInfo: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
