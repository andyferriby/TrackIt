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
    
    private static let colors: [UIColor] = [
        UIColor.flatSkyBlueColor(),
        UIColor.flatRedColor(),
        UIColor.flatYellowColor(),
        UIColor.flatGreenColor(),
        UIColor.flatOrangeColor(),
        UIColor.flatPinkColor(),
        UIColor.flatLimeColor(),
        UIColor.flatMaroonColor(),
        UIColor.flatMagentaColor(),
        UIColor.flatNavyBlueColor(),
        UIColor.flatGrayColor(),
        UIColor.flatSandColor(),
        UIColor.flatTealColor(),
        UIColor.flatMintColor(),
        UIColor.flatForestGreenColor(),
        UIColor.flatPurpleColor(),
        UIColor.flatBrownColor(),
        UIColor.flatPlumColor(),
        UIColor.flatWatermelonColor(),
        UIColor.flatCoffeeColor(),
        UIColor.flatPowderBlueColor(),
        UIColor.flatBlueColor(),
        UIColor.flatBlackColor()
    ]
    
    class func moneyColor() -> UIColor {
        return UIColor(red: 3/255.0, green: 166/255.0, blue: 120/255.0, alpha: 1.0)
    }
    
    class func colorForIndex(index: Int) -> UIColor {
        if index < 0 || index >= colors.count {
            return UIColor.grayColor()
        }
        
        return colors[index]
    }
    
    class func firstAvailableColorIndex(tags: [Tag]) -> Int {
        for i in 0..<colors.count {
            let tagsUsingColor = tags.filter { $0.colorIndex == i }
            if tagsUsingColor.count == 0 {
                return i
            }
        }
        return -1
    }
}