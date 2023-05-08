//
//  NewPostViewController.swift
//  fronend
//
//  Created by Yosi Faroh Zada on 08/05/2023.
//

import UIKit
import CoreLocation
import PhotosUI
import ProgressHUD

final class NewPostViewController: UIViewController {
    
    private var post: Post?
    private var postLocation: CLLocationCoordinate2D? = nil
    private var postImage: UIImage? = nil
    
    init(post: Post? = nil) {
        self.post = post
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var titleTextField = {
        let tf = UITextField()
        
        tf.placeholder = "Enter post title"
        tf.delegate = self
        
        return tf
    }()
    
    private lazy var descriptionTextField = {
        let tf = UITextField()
        
        tf.placeholder = "Enter post description"
        tf.delegate = self
        
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        updatePostData()
    }
    
    private func updatePostData() {
        guard let post = post else { return }
        
        titleTextField.text = post.title
        descriptionTextField.text = post.description
        
        if let latitude = post.latitude, let longitude = post.longitude {
            postLocation = .init(latitude: latitude, longitude: longitude)
        }
    }
    
    private func configureView() {
        if post == nil {
            title = "New Post"
        } else {
            title = "Edit Post"
        }
        
        view.backgroundColor = .white
        
        let scrollView = UIScrollView()
        
        view.addSubview(scrollView)
        
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.safeAreaLayoutGuide.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.safeAreaLayoutGuide.trailingAnchor)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.heightAnchor.constraint(greaterThanOrEqualTo: scrollView.heightAnchor)
        ])
        
        let setImageButton = {
            let btn = UIButton()
            
            btn.setTitle("Select Image", for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.addTarget(self, action: #selector(didPressSelectImageButton), for: .touchUpInside)
            
            if post != nil {
                btn.isHidden = true
            }
            
            return btn
        }()
        
        let setLocationButton = {
            let btn = UIButton()
            
            btn.setTitle("Select Location", for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.addTarget(self, action: #selector(didPressSelectLocationButton), for: .touchUpInside)
            
            return btn
        }()
        
        let saveButton = {
            let btn = UIButton()
            
            btn.setTitle("Save", for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.addTarget(self, action: #selector(didPressSaveButton), for: .touchUpInside)
            
            return btn
        }()
        
        let deleteButton = {
            let btn = UIButton()
            
            btn.setTitle("Delete post", for: .normal)
            btn.setTitleColor(.black, for: .normal)
            btn.addTarget(self, action: #selector(didPressDeleteButton), for: .touchUpInside)
            
            if post == nil {
                btn.isHidden = true
            }
            
            return btn
        }()
        
        contentView.addSubviews([titleTextField, descriptionTextField, setImageButton, setLocationButton, saveButton, deleteButton])
        
        titleTextField.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        descriptionTextField.anchor(top: titleTextField.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        setImageButton.anchor(top: descriptionTextField.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        setLocationButton.anchor(top: setImageButton.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        saveButton.anchor(top: setLocationButton.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        deleteButton.anchor(top: saveButton.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: .init(top: 20, left: 20, bottom: 20, right: 20))
        
        ProgressHUD.animationType = .circleStrokeSpin
    }
}

extension NewPostViewController {
    @objc private func didPressSelectLocationButton() {
        let locationVC = SetMapViewController(delegate: self, location: postLocation)
        navigationController?.pushViewController(locationVC, animated: true)
    }
    
    @objc private func didPressSelectImageButton() {
        var configuration = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        configuration.filter = .images
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    @objc private func didPressSaveButton() {
        if post == nil {
            createNewPost()
        } else {
            updatePost()
        }
    }
    
    @objc private func didPressDeleteButton() {
        guard let post = post else { return }
        let alert = UIAlertController(title: "Delete", message: "Are you sure?", preferredStyle: .alert)
        alert.addAction(.init(title: "Delete", style: .destructive) { _ in
            
            ProgressHUD.show("Loading...")
            ServerService.shared.deletePost(postPayload: post) { [weak self] result in
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    ProgressHUD.dismiss()
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        })
        alert.addAction(.init(title: "Cancel", style: .cancel))
        
        present(alert, animated: true)
    }
}

extension NewPostViewController {
    private func createNewPost() {
        guard let username = LoginService.shared.username,
            let titleText = titleTextField.text, !titleText.isEmpty,
              let descriptionText = descriptionTextField.text, !descriptionText.isEmpty,
              let image = postImage, let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        
        let post = PostUpload(username: username, title: titleText, description: descriptionText, longitude: postLocation?.longitude, latitude: postLocation?.latitude, image: imageData.base64EncodedString())
        
        ProgressHUD.show("Loading...")
        ServerService.shared.postNewPost(postPayload: post) { [weak self] result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                ProgressHUD.dismiss()
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func updatePost() {
        guard let username = LoginService.shared.username,
            let titleText = titleTextField.text, !titleText.isEmpty,
              let descriptionText = descriptionTextField.text, !descriptionText.isEmpty,
              let post = post else { return }
        
        let postEdit = PostEdit(id: post.id, username: username, title: titleText, description: descriptionText, longitude: postLocation?.longitude, latitude: postLocation?.latitude)
        
        ProgressHUD.show("Loading...")
        ServerService.shared.updatePost(postPayload: postEdit) { [weak self] result in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                ProgressHUD.dismiss()
                self?.navigationController?.popViewController(animated: true)
            }
        }
    }
}

extension NewPostViewController: UITextFieldDelegate {
    override var canResignFirstResponder: Bool {
        return true
    }
}

extension NewPostViewController: SetMapProtocol {
    func didSetLocation(location: CLLocationCoordinate2D?) {
        guard let location = location else { return }
        
        postLocation = location
    }
}

extension NewPostViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        if let result = results.first {
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] (image, error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    let alert = UIAlertController(title: "Error", message: "Failed to load image", preferredStyle: .alert)
                    alert.addAction(.init(title: "Ok", style: .default))
                    self?.present(alert, animated: true)
                } else if let image = image as? UIImage {
                    self?.postImage = image
                }
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
}
