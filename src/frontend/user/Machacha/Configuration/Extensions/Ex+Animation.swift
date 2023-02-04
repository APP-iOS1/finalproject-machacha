//
//  Ex+Animation.swift
//  Machacha
//
//  Created by Sue on 2023/02/02.
//

import SwiftUI

extension Animation {
    static let openCard = Animation.spring(response: 1, dampingFraction: 0.7)
    static let closeCard = Animation.spring(response: 0.6, dampingFraction: 0.9)
}