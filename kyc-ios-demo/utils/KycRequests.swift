import Foundation
import kyc_sdk

class KycRequests {

    static func getSimilarity(cb: @escaping (_ value: Double) -> Void) {
        KYC_API.similarity { data, error in
            if let baeError = error {
                showAlert(title: "Can't get similarity value", message: baeError.message)
                return
            }
            guard let similarity = data else { return }
            cb(similarity)
        }
    }
    
    static func getDocumentFront(cb: @escaping (_ value: UIImage) -> Void) {
        KYC_API.getDocumentFront() { doc, error in
            if let baeError = error {
                showAlert(title: "Can't get document front", message: baeError.message)
                return
            }
            guard let safeDoc = doc else {return}
            let img: UIImage = convertBase64ToImage(imageString: safeDoc.data);
            cb(img)
        }
    }
    

    static func getDocumentBack(cb: @escaping (_ value: UIImage) -> Void) {
        KYC_API.getDocumentBack() { doc, error in
            if let baeError = error {
                showAlert(title: "Can't get document back", message: baeError.message)
                return
            }
            guard let safeDoc = doc else {return}
            let img: UIImage = convertBase64ToImage(imageString: safeDoc.data);
            cb(img)
        }
    }
    

    static func getPortrait(cb: @escaping (_ value: String) -> Void) {
        KYC_API.getDocumentPortrait { data, error in
            if let safeError = error {
                showAlert(title: "Can't get portrait image", message: safeError.message)
                return
            }
            guard let img = data?.data else { return }
            cb(img)
        }
    }
    
    static func getSelfie(cb: @escaping (_ value: String) -> Void) {
        KYC_API.getSelfieFace({ data, error in
            if let safeError = error {
                showAlert(title: "Can't get selfie image", message: safeError.message)
            }
            guard let img = data?.data else { return }
            cb(img)
        })
    }
    
       static func getDocumentsUrls() -> [String: String] {
        return Uploader.urls
    }
    
    static func getScannerResult(cb: @escaping (_ data: GetCustomerResponse) -> Void) {
        KYC_API.getDocumentFields({ docs, error in
            if let baeError = error {
                showAlert(title: "Can't get result data", message: baeError.message)
            }
            guard let result = docs else {return}
            cb(result)
        })
    }
}
