//
//  UIFont+Extension.swift
//  BaseAppV2
//
//  Created by Emanuel  Guerrero on 4/11/17.
//  Copyright © 2017 SilverLogic. All rights reserved.
//

import Foundation

// MARK: - Default Fonts Enum

/// An enum representing default app fonts.
enum DefaultFonts: String {
    case light = "HelveticaNeue-Light"
    case regular = "HelveticaNeue-Regular"
    case bold = "HelveticaNeue-Bold"

    /// Gets the size and return the selected font.
    ///
    /// - Parameter size: A `CGFloat` representing the font size.
    /// - Returns: An `UIFont` object containing the font generated with `size`.
    func font(of size: CGFloat) -> UIFont {
        guard let font = UIFont(name: self.rawValue, size: size) else {
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}


// MARK: - Default Font Size Enum

/// An enum representing default app font sizes.
enum DefaultFontSizes: CGFloat {
    case small = 10.0
    case medium = 17.0
    case large = 25.0

    /// Gets the size and return the selected font.
    ///
    /// - Parameter name: A `String` representing the font name.
    /// - Returns: An `UIFont` object containing the font generated with `size`.
    func font(of name: String) -> UIFont {
        guard let font = UIFont(name: name, size: self.rawValue) else {
            return UIFont.systemFont(ofSize: UIFont.systemFontSize)
        }
        return font
    }
}


// MARK: - Application Fonts
extension UIFont {
    
    /// Main light font used in the application with small font size.
    static var mainLightSmall: UIFont { return main(.light, .small) }
    
    /// Main regular font used in the application with small font size.
    static var mainRegularSmall: UIFont { return main(.regular, .small) }
    
    /// Main bold font used in the application with small font size.
    static var mainBoldSmall: UIFont { return main(.bold, .small) }

    /// Main light font used in the application with medium font size.
    static var mainLightMedium: UIFont { return main(.light, .medium) }

    /// Main regular font used in the application with medium font size.
    static var mainRegularMedium: UIFont { return main(.regular, .medium) }

    /// Main bold font used in the application with medium font size.
    static var mainBoldMedium: UIFont { return main(.bold, .medium) }

    /// Main light font used in the application with large font size.
    static var mainLightLarge: UIFont { return main(.light, .large) }

    /// Main regular font used in the application with large font size.
    static var mainRegularLarge: UIFont { return main(.regular, .large) }

    /// Main bold font used in the application with large font size.
    static var mainBoldLarge: UIFont { return main(.bold, .large) }
    
    /// Returns main UIFont with selected default parameters.
    ///
    /// - Parameters:
    ///   - font: A `DefaultFonts` representing default font name.
    ///   - size: A `DefaultFontSizes` representing default font size.
    /// - Returns: An `UIFont` with selected default parameters.
    class func main(_ font: DefaultFonts, _ size: DefaultFontSizes) -> UIFont {
        return font.font(of: size.rawValue)
    }
}
