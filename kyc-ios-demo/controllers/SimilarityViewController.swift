import Foundation
import kyc_sdk
import UIKit

class SimilarityViewController: UIViewController {
    
    @IBOutlet weak var documentImageView: UIImageView!
    @IBOutlet weak var selfieImageView: UIImageView!
    
    @IBAction func onScanIdAgain(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onScanSelfieAgain(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        KycRequests.getSelfie { [weak self] value in
            let img: UIImage = convertBase64ToImage(imageString: value);
            DispatchQueue.main.async {
                self?.selfieImageView.image = img
            }
        }
        
        KycRequests.getPortrait { [weak self] value in
            let img: UIImage = convertBase64ToImage(imageString: value);
            DispatchQueue.main.async {
                self?.documentImageView.image = img
            }
        }
    }
}

