//
//  GenericError.swift
//  TelephonyApp
//
//  Created by Sergey Kovalchyk on 16.09.2021.
//

import Foundation

struct GenericError: Decodable {
    let message: String
    let code: String?
   
    enum CodingKeys: String, CodingKey {
        case message = "Message"
        case code = "Code"
    }
}
