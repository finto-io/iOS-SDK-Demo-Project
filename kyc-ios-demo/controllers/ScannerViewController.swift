import Foundation
import UIKit
import kyc_sdk
import MobileCoreServices
import UniformTypeIdentifiers
import AVFoundation

class ScannerViewController: UIViewController {
    public var ob:Onboarding?
    public var labelText: String = ""
    public var delegate: (()->Void)? = nil

    @IBOutlet weak var button: UIButton!
    @IBOutlet public weak var label: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = self.labelText
    }

    @IBAction func onRescan(_ sender: UIButton) {
        guard let delegate = self.delegate else {return}
        delegate()
    }
}

