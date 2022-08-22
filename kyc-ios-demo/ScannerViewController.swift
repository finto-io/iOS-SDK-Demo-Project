//
//  ScannerViewController.swift
//  kyc-ios-demo
//
//  Created by push22 on 18.08.2022.
//

import Foundation
import UIKit
import kyc_sdk
import MobileCoreServices
import UniformTypeIdentifiers
import AVFoundation



class ScannerViewController: UIViewController
                             
{
    @IBOutlet weak var button: UIButton!
    public var labelText: String = ""
    public var delegate: (()->Void)? = nil
    
    public var ob:Onboarding?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.label.text = self.labelText
    }



    @IBAction func onRescan(_ sender: UIButton) {
        guard let delegate = self.delegate else {return}
        delegate()
    }
    @IBOutlet public weak var label: UITextView!
    
}

