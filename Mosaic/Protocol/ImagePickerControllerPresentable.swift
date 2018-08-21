import Foundation
import UIKit

protocol ImagePickerControllerPresentable: class {
    func imagePickerController(_ picker: UIImagePickerController, selectedImage image: UIImage)
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
}

extension ImagePickerControllerPresentable where Self: UIViewController {
    func showImagePickerController() {
        ImagePickerController.Static.instance?.delegate = self
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = ImagePickerController.shared
        imagePicker.sourceType = ImagePickerController.sourceType
        imagePicker.allowsEditing = ImagePickerController.allowEditing
        self.present(imagePicker, animated: true, completion: nil)
    }
}

class ImagePickerController: NSObject {
    fileprivate struct `Static` {
        fileprivate static var instance: ImagePickerController?
    }
    
    class var shared: ImagePickerController {
        if ImagePickerController.Static.instance == nil {
            ImagePickerController.Static.instance = ImagePickerController()
        }
        return ImagePickerController.Static.instance!
    }
    
    weak var delegate: ImagePickerControllerPresentable?
    static var sourceType: UIImagePickerControllerSourceType = .photoLibrary
    static var allowEditing: Bool = false
    override init() {}
    
    func dispose(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        self.delegate = nil
//        ImagePickerController.Static.instance = nil
    }
}

extension ImagePickerController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dispose(picker)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image: UIImage = UIImage()
        if let originalImage: UIImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            image = originalImage
        } else if let editedImage: UIImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            image = editedImage
        }
        self.delegate?.imagePickerController(picker, selectedImage: image)
        defer {
            dispose(picker)
        }
    }
}
