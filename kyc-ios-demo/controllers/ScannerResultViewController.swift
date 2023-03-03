import Foundation
import UIKit

class ScannerResultViewController: UIViewController {
    public var delegate: (()->Void)? = nil
    
    @IBOutlet public weak var frontImage: UIImageView!
    @IBOutlet public weak var backImage: UIImageView!
    @IBOutlet public weak var selfieImage: UIImageView!
    @IBOutlet public weak var scanInfoView: UILabel!
    
    override func viewDidLoad() {
        self.scanInfoView.text = ""
        setInfoData()
        setImages()
    }
    
    private func setImages() {
        let documentsUrls = KycRequests.getDocumentsUrls()
        DispatchQueue.main.async {
            self.frontImage.load(url: URL(string: documentsUrls["frontDocument"]!)!)
            self.backImage.load(url: URL(string: documentsUrls["backDocument"]!)!)
            self.selfieImage.load(url: URL(string: documentsUrls["selfie"]!)!)
        }
    }
    
    private func setInfoData() {
        KycRequests.getScannerResult { GetCustomerResponse in
            let data = convertCodableToString(docs: GetCustomerResponse)
            DispatchQueue.main.async {
                self.scanInfoView.text = data;
                adjustLabelHeight(label: self.scanInfoView)
            }
        }
    }
    
    @IBAction func onRescan(_ sender: UIButton) {
        guard let delegate = self.delegate else {return}
        delegate()
    }
}

