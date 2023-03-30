
import Foundation
import UIKit

func showAlert(title: String, message: String) {
    DispatchQueue.main.async {
        if let viewController = UIApplication.getTopViewController() {
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}

func convertBase64ToImage(imageString: String) -> UIImage {
    let imageData = Data(
        base64Encoded: imageString,
        options: Data.Base64DecodingOptions.ignoreUnknownCharacters
    )
    return UIImage(data: imageData!)!
}



func convertCodableToString(docs: Codable) -> String {
    var string = ""
    do {
        // Encode the provided data to JSON.
        let data = try JSONEncoder().encode(docs)
        // Convert the JSON data to a JSON object.
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) else {
            return ""
        }
        // Convert the JSON object to a JSON string.
        if let theJSONData = try? JSONSerialization.data(
            withJSONObject: jsonObject,
            options: .prettyPrinted) {
            guard let theJSONText = String(data: theJSONData,
                                           encoding: .utf8) else { return "" }
            return theJSONText
        }
    } catch {
        showAlert(title: "Error", message: "Failed to encode result data")
    }
    return string
}



/// adjust the height of the label to fit the dynamic text
func adjustLabelHeight(label: UILabel) {
    let labelSize = label.frame.size
    let textSize = label.sizeThatFits(CGSize(width: labelSize.width, height: CGFloat.greatestFiniteMagnitude))
    var newFrame = label.frame
    newFrame.size.height = textSize.height
    label.frame = newFrame
}
