//
// GardeningApp
// GardenInfoViewController.swift
//
// Created by Alexander Kist on 15.12.2023.
//

import UIKit

protocol GardenInfoViewProtocol: AnyObject {
    func showPlantInfo(plant: PlantObject)
}

class GardenInfoViewController: UIViewController {
    // MARK: - Public
    var presenter: GardenInfoPresenterProtocol?

    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "pickerPlaceholder")
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .accentDark
        return view
    }()

    private let plantNameLabel = CustomLabel(fontName: UIFont.largeTitle(), textColor: .accentLight, textAlignment: .left)
    private let plantAgeLabel = CustomLabel(fontName: UIFont.body(), textColor: .accentLight.withAlphaComponent(0.6), textAlignment: .left)
    private let plantDescription = CustomLabel(fontName: UIFont.body(),text: "Your observations and notes on flower care could have been here, but you didn't add them😔" ,textColor: .accentLight.withAlphaComponent(0.6), textAlignment: .left)
    private let scrollView = UIScrollView()
    private let emptyView = UIView()

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter?.viewDidLoad()
    }
}

// MARK: - Private functions
private extension GardenInfoViewController {
    func initialize() {
        view.backgroundColor = .accentDark
        setupViews()
    }

    private func setupViews() {

        [imageView, scrollView].forEach { item in
            view.addSubview(item)
        }
       
        view.sendSubviewToBack(imageView)

        [emptyView, containerView].forEach { item in
            scrollView.addSubview(item)
        }
        emptyView.backgroundColor = .clear

        [plantNameLabel, plantAgeLabel, plantDescription].forEach { item in
            containerView.addSubview(item)
        }

        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2.5)
        }

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        emptyView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalToSuperview().dividedBy(2)

        }
        containerView.snp.makeConstraints { make in
            make.top.equalTo(emptyView.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }

        plantNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        plantAgeLabel.snp.makeConstraints { make in
            make.top.equalTo(plantNameLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        plantDescription.snp.makeConstraints { make in
            make.top.equalTo(plantAgeLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - GardenInfoViewProtocol
extension GardenInfoViewController: GardenInfoViewProtocol {
    func showPlantInfo(plant: PlantObject) {
            self.imageView.image = plant.image
            self.plantNameLabel.text = plant.plantName
            self.plantAgeLabel.text = plant.plantAge
            self.plantDescription.text = plant.plantDescription
        }
    
}
