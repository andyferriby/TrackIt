//
//  ColorManager.swift
//  TrackIt
//
//  Created by Jason Ji on 5/3/16.
//  Copyright © 2016 Jason Ji. All rights reserved.
//

import UIKit
//import ChameleonFramework

@objc class ColorManager: NSObject {
    
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
    
    @objc class func moneyColor() -> UIColor {
        return UIColor(red: 3/255.0, green: 166/255.0, blue: 120/255.0, alpha: 1.0)
    }
    
    @objc class func colorForIndex(_ index: Int) -> UIColor {
        if index < 0 || index >= colors.count {
            return UIColor.gray
        }
        
        return colors[index]
    }
    
    @objc class func firstAvailableColorIndex(_ tags: [Tag]) -> Int {
        for i in 0..<colors.count {
            let tagsUsingColor = tags.filter { $0.colorIndex?.intValue == i }
            if tagsUsingColor.count == 0 {
                return i
            }
        }
        return -1
    }
}

// Copied from ChameleonFramework, which is temporarily removed while they resolve an issue with iOS 10: https://github.com/ViccAlexander/Chameleon/issues/156

extension UIColor {
    static func hsb(_ hue: CGFloat, _ saturation: CGFloat, _ brightness: CGFloat) -> UIColor {
        return UIColor(hue: hue / 360.0, saturation: saturation / 100.0, brightness: brightness / 100.0, alpha: 1.0)
    }
    static func flatSkyBlue() -> UIColor {
        return hsb(204, 76, 86)
    }
    static func flatRed() -> UIColor {
        return hsb(6, 74, 91)
    }
    static func flatYellow() -> UIColor {
        return hsb(48, 99, 100)
    }
    static func flatGreen() -> UIColor {
        return hsb(144, 77, 80)
    }
    static func flatOrange() -> UIColor {
        return hsb(28, 85, 90)
    }
    static func flatPink() -> UIColor {
        return hsb(324, 49, 96)
    }
    static func flatLime() -> UIColor {
        return hsb(74, 70, 78)
    }
    static func flatMaroon() -> UIColor {
        return hsb(5, 65, 47)
    }
    static func flatMagenta() -> UIColor {
        return hsb(283, 51, 71)
    }
    static func flatNavyBlue() -> UIColor {
        return hsb(210, 45, 37)
    }
    static func flatGray() -> UIColor {
        return hsb(184, 10, 65)
    }
    static func flatSand() -> UIColor {
        return hsb(42, 24, 94)
    }
    static func flatTeal() -> UIColor {
        return hsb(195, 55, 51)
    }
    static func flatMint() -> UIColor {
        return hsb(168, 86, 74)
    }
    static func flatForestGreen() -> UIColor {
        return hsb(138, 45, 37)
    }
    static func flatPurple() -> UIColor {
        return hsb(253, 52, 77)
    }
    static func flatBrown() -> UIColor {
        return hsb(24, 45, 37)
    }
    static func flatPlum() -> UIColor {
        return hsb(300, 45, 37)
    }
    static func flatWatermelon() -> UIColor {
        return hsb(356, 53, 94)
    }
    static func flatCoffee() -> UIColor {
        return hsb(25, 31, 64)
    }
    static func flatPowderBlue() -> UIColor {
        return hsb(222, 24, 95)
    }
    static func flatBlue() -> UIColor {
        return hsb(224, 50, 63)
    }
    static func flatBlack() -> UIColor {
        return hsb(0, 0, 17)
    }
    static func flatGreenColorDark() -> UIColor {
        return hsb(145, 78, 68)
    }
    
    
}
