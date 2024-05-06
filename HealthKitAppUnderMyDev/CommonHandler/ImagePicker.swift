
import Foundation
import UIKit

public protocol ImagePickerDelegate: class {
    func didSelect(image: UIImage?)
	func didSelectVideo(url: NSURL?)
}

open class ImagePicker: NSObject {
    private let pickerController: UIImagePickerController
    private weak var presentationController:UIViewController?
    private weak var delegate: ImagePickerDelegate?
    
    public init(presentationController: UIViewController, delegate: ImagePickerDelegate) {
        self.pickerController = UIImagePickerController()
        
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.image" , "public.movie"]
    }
    
    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.pickerController.sourceType = type
            self.presentationController?.present(self.pickerController, animated: true)
            }
    }
    
    public func present() {
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera Roll") {
            alertController.addAction(action)
        }
        
        if let action = self.action(for: .photoLibrary, title: "Photo Library"){
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.presentationController?.present(alertController, animated: true)
        
    }
    
    public func present(MediaType: String) {
        if MediaType == "IMAGES" {
            self.pickerController.mediaTypes = ["public.image"]
        } else if MediaType == "VIDEOS" {
            self.pickerController.mediaTypes = ["public.movie"]
        } else {
            self.pickerController.mediaTypes = ["public.image" , "public.movie"]
        }
        
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        if let action = self.action(for: .camera, title: "Take photo") {
            alertController.addAction(action)
        }
        
        if let action = self.action(for: .savedPhotosAlbum, title: "Camera Roll") {
            alertController.addAction(action)
        }
        
        if let action = self.action(for: .photoLibrary, title: "Photo Library"){
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.presentationController?.present(alertController, animated: true)
        
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
        controller.dismiss(animated: true, completion: nil)
        self.delegate?.didSelect(image: image)
    }
}

extension ImagePicker: UIImagePickerControllerDelegate {
    
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        
		if let mediaType = info[UIImagePickerController.InfoKey.mediaType] as? String {
            //kupe code Start,,,,,
            /*if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                let fileName = url.lastPathComponent
                let fileType = url.pathExtension
                print("fileName_fileType===>> \(fileName) & \(fileType)")
            }*/
            //kupe code End,,,,,
            
			if mediaType  == "public.image" {
				print("Image Selected")
				guard let image = info[.editedImage] as? UIImage else {
					return self.pickerController(picker, didSelect: nil)
				}
				self.pickerController(picker, didSelect: image)
			}

			if mediaType == "public.movie" {
				print("Video Selected")
				let videoURL = info[.mediaURL] as? NSURL
                print("videoURL===>>", videoURL ?? "--")
				self.delegate?.didSelectVideo(url: videoURL)
			}
		}
		picker.dismiss(animated: true, completion: nil)
        
    }
}

extension ImagePicker: UINavigationControllerDelegate {
    
}
