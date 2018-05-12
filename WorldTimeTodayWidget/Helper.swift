// Copyright 2014-present Max von Webel. All Rights Reserved.

import Foundation

func with<T>(object: T, block: (_ object: T) -> ()) -> T {
    block(object)
    return object
}
