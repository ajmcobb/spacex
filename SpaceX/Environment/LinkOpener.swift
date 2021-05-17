//
//  LinkOpener.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 16/05/2021.
//

import UIKit

struct LinkOpener {
    var open: (String) -> Void
}

extension LinkOpener {
    static var live: LinkOpener {
        LinkOpener(open: { string in
            if let link = URL(string: string),
               UIApplication.shared.canOpenURL(link) {
                UIApplication.shared.open(link)
            }
        })
    }
}
