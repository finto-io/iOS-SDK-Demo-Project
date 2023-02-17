import Foundation
import UIKit


class SpinnerViewController: UIViewController {
    
    // MARK: - Properties
    
    let spinner = UIActivityIndicatorView(style: .whiteLarge)
    var child: UIViewController?
    
    // MARK: - Methods
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .black
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)
    }
    
    func appear(controller: UIViewController) {
        DispatchQueue.main.async {
            self.child = controller
            controller.view.addSubview(self.view)
            self.view.frame = controller.view.frame
            self.didMove(toParent: controller)
            self.spinner.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor).isActive = true
            self.spinner.centerYAnchor.constraint(equalTo: controller.view.centerYAnchor).isActive = true
        }
    }
    
    func disappear() {
        DispatchQueue.main.async {
            if let child = self.child {
                self.willMove(toParent: nil)
                self.view.removeFromSuperview()
                self.removeFromParent()
                child.viewDidLoad()
            }
        }
    }
}
