import Foundation
import UIKit
import kyc_sdk
import MobileCoreServices
import DotDocument

class UploadViewController: UIViewController {
    
    @IBOutlet public weak var openLinkButton: UIButton!
    @IBOutlet public weak var uploadButton: UIButton!
    @IBOutlet public weak var label: UILabel!
    
    override func viewDidLoad() {
        DispatchQueue.main.async {
            self.label.text = ""
            self.uploadButton.isHidden = false
            self.openLinkButton.isHidden = true
        }
    }
    
    @IBAction func openLink(_ sender: UIButton) {
        guard let text = self.label.text else {return}
        if let url = URL(string: text) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func onUploadPress(_ sender: UIButton) {
        DispatchQueue.main.async {
            let controller = FilePicker(documentTypes: FILE_TYPES)
            controller.modalPresentationStyle = .fullScreen
            controller.delegate = self
            self.present(controller, animated: true)
        }
    }
}

extension UploadViewController: FilePickerDelegate {
    func filePickerSuccess(_ controller: kyc_sdk.FilePicker, _ urls: [URL]) {
        DispatchQueue.main.async {
            self.openLinkButton.isHidden = false
            self.uploadButton.isHidden = true
            self.label.text = urls[0].absoluteString
        }
    }
    
    func filePickerFailed(_ controller: kyc_sdk.FilePicker, error: kyc_sdk.BaeError) {
        toggleUploadingButtonStatus(false)
    }
    
    func filePickerUploadingStarted(_ controller: kyc_sdk.FilePicker) {
        toggleUploadingButtonStatus(true)
    }
    
    func toggleUploadingButtonStatus(_ uploading: Bool) {
        if uploading {
            DispatchQueue.main.async {
                self.uploadButton.isEnabled = false
                self.uploadButton.setTitle("Uploading...", for: .normal)
            }
        } else {
            DispatchQueue.main.async {
                self.uploadButton.isEnabled = true
                self.uploadButton.setTitle("Upload", for: .normal)
            }
        }
    }
}

