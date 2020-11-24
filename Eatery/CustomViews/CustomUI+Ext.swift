//
//  CustomUI+Ext.swift
//  Eatery
//
//  Created by João Palma on 17/11/2020.
//

import UIKit

enum CustomUIAppearance {
    static func setNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor.Theme.mainGreen
        appearance.titleTextAttributes = [.foregroundColor: UIColor.Theme.white, .shadow: _textShadow()]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.Theme.white, .shadow: _textShadow()]
        appearance.shadowColor = .clear
        appearance.shadowImage = UIImage()
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.Theme.white], for: .normal)
        UIBarButtonItem.appearance().tintColor = UIColor.Theme.white
        
        [ UINavigationBar.appearance().standardAppearance,
          UINavigationBar.appearance().compactAppearance,
          UINavigationBar.appearance().scrollEdgeAppearance
        ].forEach {
            $0?.backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        }
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    static private func _textShadow() -> NSShadow {
        let textShadow = NSShadow()
        textShadow.shadowColor = UIColor.Theme.black.withAlphaComponent(0.8)
        textShadow.shadowBlurRadius = 1
        textShadow.shadowOffset = CGSize(width: 0.5, height: 0.5)
        return textShadow
    }
}

extension UIColor {
    func fromRGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: (red/255), green: (green/255), blue: (blue/255), alpha: alpha)
    }
    
    struct Theme {
        static var mainGreen = UIColor().fromRGBA(red: 49, green: 129, blue: 74, alpha: 1)
        static var backgroundColor = UIColor.systemBackground
        static var white = UIColor().fromRGBA(red: 255, green: 255, blue: 255, alpha: 1)
        static var black = UIColor().fromRGBA(red: 0, green: 0, blue: 0, alpha: 1)
        static var darkGrey = UIColor.systemGray //UIColor().fromRGBA(red: 29, green: 30, blue: 33, alpha: 1)
        static var lightGrey = UIColor.systemGray3
        static var transparentBlack = UIColor().fromRGBA(red: 0, green: 0, blue: 0, alpha: 0.4)
        static var blue = UIColor.systemBlue //UIColor().fromRGBA(red: 62, green: 154, blue: 255, alpha: 1)
        static var green = UIColor.systemGreen //UIColor().fromRGBA(red: 65, green: 169, blue: 75, alpha: 1)
        static var red = UIColor.systemRed //UIColor().fromRGBA(red: 206, green: 63, blue: 64, alpha: 1)
        static var yellow = UIColor.systemYellow //UIColor().fromRGBA(red: 255, green: 216, blue: 48, alpha: 1)
        static var orange = UIColor.systemOrange //UIColor().fromRGBA(red: 224, green: 149, blue: 34, alpha: 1)
    }
}

extension UIImage {
    func addFilter(_ filter: ImageFilterType) -> UIImage {
        let filter = CIFilter(name: filter.rawValue)
        
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
            
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        
        return UIImage(cgImage: cgImage!)
    }
    
    func resizedImage(for size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        
        return renderer.image { (context) in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

enum UIWidgets {
    static func setActivityIndicatoryInto(view: UIView) -> UIActivityIndicatorView {
        let activityView = UIActivityIndicatorView(style: .large)
        activityView.center = view.center
        activityView.startAnimating()
        activityView.isHidden = true
        view.addSubview(activityView)

        return activityView
    }
}
