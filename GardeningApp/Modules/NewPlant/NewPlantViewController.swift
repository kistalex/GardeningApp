//
// GardeningApp
// NewPlantViewController.swift
//
// Created by Alexander Kist on 12.12.2023.
//

import UIKit
import PhotosUI
import SnapKit

protocol NewPlantViewProtocol: AnyObject {
    func displayImage(_ image: UIImage)
}

class NewPlantViewController: UIViewController {
    // MARK: - Public
    var presenter: NewPlantPresenterProtocol?
    private lazy var plantImageView = CustomImageView(imageName: "pickerPlaceholder")
    private let nameTField = CustomTextField(tFieldType: .name)
    private let ageTField = CustomTextField(tFieldType: .age)
    private let recommendationLabel = CustomLabel(fontName: UIFont.body(), text: "If you want, you can add a description of your plant or some personal observations.", textColor: .accentLight)
    private let descriptionTView = CustomTextView()
    private let saveButton = CustomTextButton(text: "Save", bgColor: .accentLight)
    private let contentView = UIView()

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

// MARK: - Private functions
private extension NewPlantViewController {
    func initialize() {
        view.backgroundColor = .accentDark
        setupViews()
        setupGesture()
    }

    private func setupViews(){

        view.addSubview(contentView)

        [plantImageView, nameTField, recommendationLabel ,ageTField, descriptionTView, saveButton].forEach { item in
            contentView.addSubview(item)
        }

        contentView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.keyboardLayoutGuide.snp.top).inset(20)
        }

        plantImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().dividedBy(3.5)
            make.width.equalTo(plantImageView.snp.height)
        }

        nameTField.snp.makeConstraints { make in
            make.top.equalTo(plantImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalToSuperview().dividedBy(15)
        }

        ageTField.snp.makeConstraints { make in
            make.top.equalTo(nameTField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalToSuperview().dividedBy(15)
        }

        recommendationLabel.snp.makeConstraints { make in
            make.top.equalTo(ageTField.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }

        descriptionTView.snp.makeConstraints { make in
            make.top.equalTo(recommendationLabel.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalToSuperview().dividedBy(5)
        }

        saveButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionTView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(150)
        }
        saveButton.addTarget(self, action: #selector(saveButtonTapped), for: .touchUpInside)
    }

    private func setupGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(openImagePicker))
        plantImageView.isUserInteractionEnabled = true
        plantImageView.addGestureRecognizer(tap)
    }

    //MARK: - Selectors

    @objc private func openImagePicker() {
        presenter?.didTapOpenImagePicker()
    }
    
    @objc private func saveButtonTapped() {
        guard  let image = plantImageView.image,
               let name = nameTField.text, !name.isEmpty,
               let age = ageTField.text, !age.isEmpty,
               let description = descriptionTView.text else { return }
        presenter?.didTapSavePlant(image: image, name: name, age: age, description: description)
    }
}
extension NewPlantViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true, completion: nil)
        presenter?.didFinishPickingImage(results: results)
    }
}

// MARK: - NewPlantViewProtocol
extension NewPlantViewController: NewPlantViewProtocol {
    func displayImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.plantImageView.image = image
        }
    }
}


