//
//  ColorManager.swift
//  TrackIt
//
//  Created by Jason Ji on 5/3/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
import ChameleonFramework

class ColorManager: NSObject {
    
    fileprivate static let colors: [UIColor] = [
        UIColor.flatSkyBlue(),
        UIColor.flatRed(),
        UIColor.flatYellow(),
        UIColor.flatGreen(),
        UIColor.flatOrange(),
        UIColor.flatPink(),
        UIColor.flatLime(),
        UIColor.flatMaroon(),
        UIColor.flatMagenta(),
        UIColor.flatNavyBlue(),
        UIColor.flatGray(),
        UIColor.flatSand(),
        UIColor.flatTeal(),
        UIColor.flatMint(),
        UIColor.flatForestGreen(),
        UIColor.flatPurple(),
        UIColor.flatBrown(),
        UIColor.flatPlum(),
        UIColor.flatWatermelon(),
        UIColor.flatCoffee(),
        UIColor.flatPowderBlue(),
        UIColor.flatBlue(),
        UIColor.flatBlack()
    ]
    
    class func moneyColor() -> UIColor {
        return UIColor(red: 3/255.0, green: 166/255.0, blue: 120/255.0, alpha: 1.0)
    }
    
    class func colorForIndex(_ index: Int) -> UIColor {
        if index < 0 || index >= colors.count {
            return UIColor.gray
        }
        
        return colors[index]
    }
    
    class func firstAvailableColorIndex(_ tags: [Tag]) -> Int {
        for i in 0..<colors.count {
            let tagsUsingColor = tags.filter { $0.colorIndex?.intValue == i }
            if tagsUsingColor.count == 0 {
                return i
            }
        }
        return -1
    }
}
