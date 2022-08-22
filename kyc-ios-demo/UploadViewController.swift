//
//  UploadViewController.swift
//  kyc-ios-demo
//
//  Created by push22 on 18.08.2022.
//

import Foundation

import UIKit
import kyc_sdk
import MobileCoreServices
import DotDocument
import UniformTypeIdentifiers



class UploadViewController: UIViewController {
    
    
    @IBOutlet weak var OpenLinkButton: UIButton!
    @IBOutlet public weak var label: UILabel!
    public func setLink(link: String) {
        DispatchQueue.main.async {
            self.OpenLinkButton.isHidden = false
            self.label.text = link
        }
        
        
    }
    
    override func viewDidLoad() {
        OpenLinkButton.isHidden = true
        self.label.text = "Loading..."
    }
    
    
    
    
    @IBAction func openLink(_ sender: Any) {
        guard let text = self.label.text else {return}
        if let url = URL(string: text) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    
}
