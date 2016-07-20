//
//  UIFont.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

extension UIFont {
    
    /**
     size: 17.0
     */
    class func headline() -> UIFont {
        return UIFont.preferredFont(forTextStyle: UIFontTextStyleBody)
    }
    
    /**
     size: 15.0
     */
    class func subheadline() -> UIFont {
        return UIFont.preferredFont(forTextStyle: UIFontTextStyleSubheadline)
    }
    
    /**
     size: 17.0
     */
    class func body() -> UIFont {
        return UIFont.preferredFont(forTextStyle: UIFontTextStyleBody)
    }
    
    /**
     size: 16.0
     */
    class func callout() -> UIFont {
        return UIFont.preferredFont(forTextStyle: UIFontTextStyleCallout)
    }
    
    /**
     size: 12.0
     */
    class func caption1() -> UIFont {
        return UIFont.preferredFont(forTextStyle: UIFontTextStyleCaption1)
    }
    
    /**
     size: 11.0
     */
    class func caption2() -> UIFont {
        return UIFont.preferredFont(forTextStyle: UIFontTextStyleCaption2)
    }
    
    /**
     size: 28.0
     */
    class func title1() -> UIFont {
        return UIFont.preferredFont(forTextStyle: UIFontTextStyleTitle1)
    }
    
    /**
     size: 22.0
     */
    class func title2() -> UIFont {
        return UIFont.preferredFont(forTextStyle: UIFontTextStyleTitle2)
    }
    
    /**
     size: 20.0
     */
    class func title3() -> UIFont {
        return UIFont.preferredFont(forTextStyle: UIFontTextStyleTitle3)
    }
    
    /**
     size: 13.0
     */
    class func footnote() -> UIFont {
        return UIFont.preferredFont(forTextStyle: UIFontTextStyleFootnote)
    }
    
    var thin: UIFont {
        let size = self.pointSize
        let font = UIFont.systemFont(ofSize: size, weight: UIFontWeightThin)
        return font
    }
    
    var ultraLight: UIFont {
        let size = self.pointSize
        let font = UIFont.systemFont(ofSize: size, weight: UIFontWeightUltraLight)
        return font
    }
    
    var light: UIFont {
        let size = self.pointSize
        let font = UIFont.systemFont(ofSize: size, weight: UIFontWeightLight)
        return font
    }
    
    var medium: UIFont {
        let size = self.pointSize
        let font = UIFont.systemFont(ofSize: size, weight: UIFontWeightMedium)
        return font
    }
    
    var semibold: UIFont {
        let size = self.pointSize
        let font = UIFont.systemFont(ofSize: size, weight: UIFontWeightSemibold)
        return font
    }
    
    var bold: UIFont {
        let size = self.pointSize
        let font = UIFont.systemFont(ofSize: size, weight: UIFontWeightBold)
        return font
    }
    
    var heavy: UIFont {
        let size = self.pointSize
        let font = UIFont.systemFont(ofSize: size, weight: UIFontWeightHeavy)
        return font
    }
    
    var black: UIFont {
        let size = self.pointSize
        let font = UIFont.systemFont(ofSize: size, weight: UIFontWeightBlack)
        return font
    }
}
