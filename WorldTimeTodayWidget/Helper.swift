// Copyright 2014-present Max von Webel. All Rights Reserved.

import UIKit

func maximumColumns() -> Int {
    return UIScreen.main.bounds.width > 320 ? 3 : 2
}

func maximumLocationsCompactMode() -> Int {
    return maximumColumns() * 2
}
