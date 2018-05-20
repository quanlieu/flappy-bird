//
//  Random.swift
//  Flappy Bird
//
//  Created by Quan Lieu on 5/19/18.
//  Copyright © 2018 Quan Lieu. All rights reserved.
//

import Foundation
import CoreGraphics

public extension CGFloat {
    
    public static func randomNumberBetween(min: CGFloat, max: CGFloat) -> CGFloat {
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(min - max) + min;
    }
    
}
