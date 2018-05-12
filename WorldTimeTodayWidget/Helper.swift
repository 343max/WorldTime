//
//  Helper.swift
//  GiantPhotoCollection
//
//  Created by Max von Webel on 31/07/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

import Foundation

func with<T>(object: T, block: (_ object: T) -> ()) -> T {
    block(object)
    return object
}
