
import Foundation
import Foundation
import UIKit
import kyc_sdk
import MobileCoreServices
import DotDocument

class RecorderResultViewController: UIViewController {

    var link: String!
    
    @IBOutlet public weak var button: UIButton!
    @IBOutlet public weak var label: UILabel!
    
    @IBAction func openLink(_ sender: UIButton) {
        guard let text = self.label.text else {return}
        if let url = URL(string: text) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    override func viewDidLoad() {
        self.label.text = self.link
    }
}
