
import UIKit
import kyc_sdk
import DotDocument
import UniformTypeIdentifiers
import AVFoundation


class ViewController: UIViewController {

    var uploadController: UploadViewController!
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isTranslucent = true
    }
    var ob:Onboarding?
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "KYC SDK Demo"
        let storyBoard : UIStoryboard = UIStoryboard(name: "Upload", bundle:nil)
        
        self.uploadController = storyBoard.instantiateViewController(withIdentifier: "Upload") as! UploadViewController
        UINavigationBar.appearance().tintColor = UIColor(red:0x32, green: 0x90 , blue: 0xff)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red:0x32, green: 0x90 , blue: 0xff)]
        if let url = Bundle.main.url(forResource: "iengine", withExtension: "lic") {
            do {
                let license = try Data(contentsOf: url)
                ob = Onboarding(license:license, baseURL: URL(string: "https://bl4-dev-02.baelab.net/api/BAF3E974-52AA-7598-FF04-56945EF93500/48EE4790-8AEF-FEA5-FFB6-202374C61700")!)
                ob?.initialize()
            } catch {
                return
            }
        }
    }
}


extension ViewController:
    DocumentScanFrontViewControllerDelegate,
    DocumentScanBackViewControllerDelegate,
    SelfieAutoCaptureViewControllerDelegate
{
    @IBAction func press(_ sender: UIButton) {
        
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        if status == AVAuthorizationStatus.authorized {
            firstStep()
        } else if status == AVAuthorizationStatus.notDetermined {
            self.askPermission()
        }
        else {
            let alert = UIAlertController(title: "No Camera Permission", message: "Go to settings, enable permission and then try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    
    func askPermission(){
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) -> Void in
            DispatchQueue.main.async{
                if granted {
                    self.firstStep()
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        })
    }
    
    func firstStep(){
        let controller = DocumentScanFrontViewController()
        controller.delegate = self
        
        controller.navigationItem.title =  "Scan Front of you ID"
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func documentScanFrontSuccess(_ controller: DocumentScanFrontViewController) {
        DispatchQueue.main.async {
            let controller = DocumentScanBackViewController()
            controller.navigationItem.title =  "Scan Back of you ID"
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    func documentScanFrontFailed(_ controller: DocumentScanFrontViewController,_ error: BaeError) {
        DispatchQueue.main.async {
            controller.restart()
        }
    }
    
    func documentScanBackSuccess(_ controller: DocumentScanBackViewController) {
        DispatchQueue.main.async {
            let controller = SelfieAutoCaptureViewController();
            controller.navigationItem.title =  "Please take a selfie"
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
            
            
        }
    }
    func documentScanBackFailed(_ controller: DocumentScanBackViewController,_ error: BaeError) {
        DispatchQueue.main.async {
            controller.restart()
            return
        }
    }
    
    func selfieAutoCaptureSuccess(_ controller: SelfieAutoCaptureViewController) {
        
        DispatchQueue.main.async {
            self.ob?.inspectDocument(){ res, err in
                
                DispatchQueue.main.async {
                    
                    do {
                        let encoder = JSONEncoder()
                        encoder.outputFormatting = .prettyPrinted
                        let data = try encoder.encode(res)
                        
                        // The JSON data is in bytes. Let's printit as a JSON string.
                        guard let jsonString = String(data: data, encoding: .utf8) else { return }
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Scanner", bundle:nil)
                        let scannerViewController = storyBoard.instantiateViewController(withIdentifier: "Scanner") as! ScannerViewController

                        self.navigationController?.pushViewController(scannerViewController, animated: true)
                        self.navigationController?.navigationBar.topItem?.backButtonTitle = "KYC SDK Demo"
                       

                        scannerViewController.delegate = self.firstStep
                        scannerViewController.labelText = jsonString
                        let count = self.navigationController?.viewControllers.count ?? 0
                        
                        self.navigationController?.viewControllers.removeSubrange(1...(count - 2))
                    } catch {
                        print("Failed to encode JSON")
                    }
                }
            }
        }
    }
    
    func selfieAutoCaptureFailed(_ controller: SelfieAutoCaptureViewController,_ error: BaeError) {
        DispatchQueue.main.async {
            controller.restart()
            return
        }
    }
}

extension ViewController:FilePickerDelegate {
    
    
    @IBAction func pressUpload(_ sender: UIButton) {
        let types:  [UTType] = [
            UTType.image,
            UTType(filenameExtension: "pdf")!,
            UTType(filenameExtension: "jpg")!,
            UTType(filenameExtension: "jpeg")!,
            UTType(filenameExtension: "png")!,
            UTType(filenameExtension: "doc")!,
            UTType(filenameExtension: "docx")!,
            UTType(filenameExtension: "csv")!,
            
        ]
        let controller = FilePicker(documentTypes: types)
        controller.modalPresentationStyle = .fullScreen
        controller.delegate = self
        self.present(controller, animated: true)
        self.navigationController?.pushViewController(self.uploadController, animated: true)
    }
    
    func filePickerSuccess(_ controller: FilePicker, _ urls: [URL]) {
        DispatchQueue.main.async {
            self.uploadController.setLink(link: urls[0].absoluteString)
            print(urls)
        }
    }
    
    
    func filePickerUploadingStarted(_ controller: FilePicker) {
        DispatchQueue.main.async {
            
        }
    }
    
    
    func filePickerFailed(_ controller: FilePicker, error: BaeError) {
        DispatchQueue.main.async {
            self.uploadController?.label.text = error.localizedDescription
        }
    }
}

extension ViewController: VideoViewControllerDelegate {
    func videoViewRecordFailed(_ controller: kyc_sdk.VideoViewController, _ error: kyc_sdk.BaeError) {}
    
    
    @IBAction func onRecordVideoPress(_ sender: Any) {
        let controller = VideoViewController()
        controller.delegate = self
        controller.navigationItem.title =  "Please hold the button for 5 seconds"
        
        self.navigationController?.pushViewController(controller, animated: true)
        navigationController?.navigationBar.barStyle = .black
    }
    
    
    func videoViewRecordSuccess(_ controller: VideoViewController, _ url: String) {
        DispatchQueue.main.async {
            
            self.navigationController?.pushViewController(self.uploadController, animated: true)
            self.navigationController?.navigationBar.topItem?.backButtonTitle = "KYC SDK Demo"
            self.navigationController?.viewControllers.remove(at: 1)
            self.uploadController.setLink(link: url)
            
        }
    }
  
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
