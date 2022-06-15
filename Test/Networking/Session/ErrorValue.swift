//
//  ErrorValue.swift
//  TacitCoreSDK
//
//  Created by Sergey Kovalchyk on 20.09.2021.
//

import Foundation

// Based on code parse here another Decodable model if backend return not standart error model (with some additional fields)
enum ErrorValue: Decodable, Error {
    enum QuantumError: Error {
        case missingValue
    }
    
    case generic(model: GenericError)
    
    init(from decoder: Decoder) throws {
        // Parse GenericError model
        guard let genericError = try? decoder.singleValueContainer().decode(GenericError.self) else {
            throw QuantumError.missingValue
        }
        
        // Get code from GenericError model
        let code = (genericError.code?.digits ?? "").toInt
        switch code {
        
        default:
            self = .generic(model: genericError)
        }
    }
}
