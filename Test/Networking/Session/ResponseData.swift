//
//  ResponseData.swift
//  TelephonyApp
//
//  Created by Sergey Kovalchyk on 16.09.2021.
//

struct ResponseData<T: Decodable>: Decodable {
    var code: Int?
    var data: T?
    var error: ErrorValue?
    
    init(from decoder: Decoder) throws {
        do {
            guard let error = try? ErrorValue(from: decoder) else {
                self.data = try T(from: decoder)
                return
            }
            self.error = error
        } catch {
            // Temporary for quick debug model parsing issues
            assertionFailure("Parsing error: \(error)")
        }
    }
}
