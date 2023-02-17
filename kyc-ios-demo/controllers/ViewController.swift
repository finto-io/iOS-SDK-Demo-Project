import UIKit
import kyc_sdk
import DotDocument
import UniformTypeIdentifiers
import AVFoundation

let URL_STR = "https://bl4-dev-02.baelab.net/api/BAF3E974-52AA-7598-FF04-56945EF93500/48EE4790-8AEF-FEA5-FFB6-202374C61700"
let KYC_API = Api(URL(string: URL_STR))
let SIMILARITY_EDGE = 0.7

class ViewController: UIViewController {
    var ob: Onboarding?
    var spinnerVC = SpinnerViewController()
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.navigationBar.isTranslucent = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationItem()
        if let url = Bundle.main.url(forResource: "iengine", withExtension: "lic") {
            do {
                let license = try Data(contentsOf: url)
                ob = Onboarding(license:license, baseURL: URL(string: URL_STR)!)
                ob?.initialize()
            } catch {
                return
            }
        }
    }
    
    func setNavigationItem() {
        navigationItem.title = "KYC SDK Demo"
        navigationController?.navigationBar.tintColor = UIColor(red:0x32, green: 0x90 , blue: 0xff)
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red:0x32, green: 0x90 , blue: 0xff)]
    }
    
    @IBAction func pressUpload(_ sender: UIButton) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Upload", bundle:nil)
        let uploadViewController = storyBoard.instantiateViewController(withIdentifier: "Upload") as! UploadViewController
        uploadViewController.navigationItem.title = "Document uploader"
        self.navigationController?.pushViewController(uploadViewController, animated: true)
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
            askPermission()
        }
        else {
            showAlert(
                title: "No Camera Permission",
                message: "Go to settings, enable permission and then try again."
            )
        }
    }
    
    func askPermission(){
        AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) -> Void in
            if granted {
                DispatchQueue.main.async {
                    self.firstStep()
                }
            } else {
                DispatchQueue.main.async{
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        })
    }
    
    func firstStep(){
        let controller = DocumentScanFrontViewController()
        controller.delegate = self
        controller.navigationItem.title = "Scan Front of you ID"
        controller.view.layoutIfNeeded()

        DispatchQueue.main.async {
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func documentScanFrontSuccess(_ controller: DocumentScanFrontViewController) {
        let controller = DocumentScanBackViewController()
        controller.navigationItem.title = "Scan Back of you ID"
        controller.delegate = self
        DispatchQueue.main.async {
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
            controller.navigationItem.title = "Please take a selfie"
            controller.delegate = self
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    func documentScanBackFailed(_ controller: DocumentScanBackViewController,_ error: BaeError) {
        DispatchQueue.main.async {
            controller.restart()
        }
    }
    
    func selfieAutoCaptureSuccess(_ controller: SelfieAutoCaptureViewController) {
        self.spinnerVC.appear(controller: controller)
        self.ob?.inspectDocument(){ res, err in
            KycRequests.getSimilarity { value in
                self.spinnerVC.disappear()
                if (value < SIMILARITY_EDGE) {
                    self.navigateToSimilarity()
                } else {
                    self.navigateToResult()
                }
            }
        }
    }
    
    func selfieAutoCaptureFailed(_ controller: SelfieAutoCaptureViewController,_ error: BaeError) {
        DispatchQueue.main.async {
            controller.restart()
        }
    }
    
    func navigateToResult() {
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "ScannerResult", bundle:nil)
            let scannerViewController = storyBoard.instantiateViewController(withIdentifier: "ScannerResult") as! ScannerResultViewController
            self.navigationController?.pushViewController(scannerViewController, animated: true)
            scannerViewController.delegate = self.firstStep
            self.navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
            let count = self.navigationController?.viewControllers.count ?? 0
            self.navigationController?.viewControllers.removeSubrange(1...(count - 2))
        }
    }
    
    func navigateToSimilarity() {
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "Similarity", bundle:nil)
            let similarityViewController = storyBoard.instantiateViewController(withIdentifier: "Similarity") as! SimilarityViewController
            self.navigationController?.pushViewController(similarityViewController, animated: true)
            similarityViewController.navigationItem.title = "Similarity result"
            similarityViewController.navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
        }
    }
}


extension ViewController: VideoViewControllerDelegate {
    func videoViewRecordFailed(_ controller: kyc_sdk.VideoViewController, _ error: kyc_sdk.BaeError) {}
    
    @IBAction func onRecordVideoPress(_ sender: Any) {
        DispatchQueue.main.async {
            let controller = VideoViewController()
            controller.delegate = self
            controller.navigationItem.title = "Please hold the button for 5 seconds"
            self.navigationController?.pushViewController(controller, animated: true)
            self.navigationController?.navigationBar.barStyle = .black
        }
    }
    
    func videoViewRecordSuccess(_ controller: VideoViewController, _ url: String) {
        DispatchQueue.main.async {
            let storyBoard : UIStoryboard = UIStoryboard(name: "RecorderResult", bundle:nil)
            let recorderViewController = storyBoard.instantiateViewController(withIdentifier: "RecorderResult") as! RecorderResultViewController
            recorderViewController.navigationItem.title = "Record result"
            recorderViewController.navigationItem.backButtonTitle = "Back"
            recorderViewController.link = url
            self.navigationController?.pushViewController(recorderViewController, animated: true)
            self.navigationController?.viewControllers.remove(at: 1)
        }
    }
    
}

