import UIKit

protocol TransparentNavBarService: class {
}

extension TransparentNavBarService where Self: UIViewController {
    func transparentNavigationBar(shadowImage: UIImage? = nil) {
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .done, target: nil, action: nil)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = (shadowImage == nil) ? UIImage() : shadowImage
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.clear.cgColor
    }
}

/*
class ViewController: UIViewController, TransparentNavBarService {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.transparentNavigationBar()
    }
}
*/
