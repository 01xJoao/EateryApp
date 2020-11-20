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
        appearance.titleTextAttributes = [.foregroundColor: UIColor.Theme.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.Theme.white, .shadow: _textShadow()]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        let backButtonAppearance = UIBarButtonItemAppearance()
        backButtonAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.clear]
        
        UINavigationBar.appearance().standardAppearance.backButtonAppearance = backButtonAppearance
        UINavigationBar.appearance().compactAppearance?.backButtonAppearance = backButtonAppearance
        UINavigationBar.appearance().scrollEdgeAppearance?.backButtonAppearance = backButtonAppearance
        
        UIBarButtonItem.appearance().setTitleTextAttributes([.foregroundColor: UIColor.Theme.white], for: .normal)
        UIBarButtonItem.appearance().tintColor = UIColor.Theme.white
        
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    static private func _textShadow() -> NSShadow {
        let textShadow = NSShadow()
        textShadow.shadowColor = UIColor.Theme.black
        textShadow.shadowBlurRadius = 1.2
        textShadow.shadowOffset = CGSize(width: 0.6, height: 0.6)
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

protocol Reusable {
    static var reuseIdentifier: String { get }
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

class TopAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)?.map { $0.copy() } as? [UICollectionViewLayoutAttributes]

        attributes?.reduce([CGFloat: (CGFloat, [UICollectionViewLayoutAttributes])]()) {
            guard $1.representedElementCategory == .cell else { return $0 }
            return $0.merging([ceil($1.center.y): ($1.frame.origin.y, [$1])]) {
                ($0.0 < $1.0 ? $0.0 : $1.0, $0.1 + $1.1)
            }
        }.values.forEach { minY, line in
            line.forEach {
                $0.frame = $0.frame.offsetBy(
                    dx: 0,
                    dy: minY - $0.frame.origin.y
                )
            }
        }

        return attributes
    }
}

extension UIImage {
    func addFilter(_ filter: FilterType) -> UIImage {
        let filter = CIFilter(name: filter.rawValue)
        
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
            
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        return UIImage(cgImage: cgImage!)
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
