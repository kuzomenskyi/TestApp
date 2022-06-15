//
//  Constants.swift
//  BeatyApp
//
//  Created by Sergey Kovalchyk on 7/5/19.
//

import Foundation
import UIKit

typealias JSONObject = Dictionary<String,Any>

public enum Completions {
    public typealias FlagResult = (Bool, Error?) -> Void
    public typealias ModelResult<M> = (M?, Error?) -> Void
    public typealias ArrayResult<M> = ([M]?, Error?) -> Void
    public typealias Empty = () -> Void
    public typealias ValueResult<T> = ((T?) -> Void)

    public typealias ThrowableModelResult<M> = (M?, Error?) throws -> Void
    public typealias ThrowableArrayResult<M> = ([M]?, Error?) throws -> Void
}

public extension Notification.Name {
    
}
