import Foundation
import kyc_sdk


extension UIApplication {
    /// Returns the top-most view controller in the view hierarchy.
    class func getTopViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController)
        -> UIViewController? {
            if let nav = base as? UINavigationController {
                return getTopViewController(base: nav.visibleViewController)
            } else if let tab = base as? UITabBarController, let selected = tab.selectedViewController {
                return getTopViewController(base: selected)
            } else if let presented = base?.presentedViewController {
                return getTopViewController(base: presented)
            } else {
                return base
            }
    }
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        // Make sure the RGB values are between 0 and 255
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        // Convert the RGB values to CGFloats between 0 and 1
        let redFloat = CGFloat(red) / 255
        let greenFloat = CGFloat(green) / 255
        let blueFloat = CGFloat(blue) / 255
        
        // Initialize the UIColor object
        self.init(red: redFloat, green: greenFloat, blue: blueFloat, alpha: 1)
    }
    
    convenience init(rgb: Int) {
        // Convert the RGB value to its red, green, and blue components
        let red = (rgb >> 16) & 0xFF
        let green = (rgb >> 8) & 0xFF
        let blue = rgb & 0xFF
        
        // Initialize the UIColor object
        self.init(red: red, green: green, blue: blue)
    }
}


extension UIImageView {
    func load(url: URL) {
        DispatchQueue.global().async { [weak self] in
            //Download the image data from the given url
            if let data = try? Data(contentsOf: url) {
                //Turn the image data into an image
                if let image = UIImage(data: data) {
                    //Update the UI on the main thread
                    DispatchQueue.main.async {
                        //Assign the image to the UIImageView
                        if let strongSelf = self {
                            strongSelf.image = image
                        }
                    }
                }
            }
        }
    }
}
