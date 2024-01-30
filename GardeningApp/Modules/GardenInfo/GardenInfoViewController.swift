//
// GardeningApp
// GardenInfoViewController.swift
//
// Created by Alexander Kist on 15.12.2023.
//

import UIKit
import SnapKit

protocol GardenInfoViewProtocol: AnyObject {
    func showPlantInfo(plant: PlantViewModel)
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
        view.backgroundColor = Constants.contentViewColor
        return view
    }()

    private let plantNameLabel = CustomLabel(fontName: Constants.nameFont, textColor: Constants.textColor, textAlignment: .left)
    private let plantAgeLabel = CustomLabel(fontName: Constants.ageFont, textColor: Constants.lightTextColor, textAlignment: .left)
    private let plantDescription = CustomLabel(fontName: Constants.descriptionFont, text: "" ,textColor: Constants.lightTextColor, textAlignment: .left)
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
    
    private enum Constants {
        static let topInset: CGFloat = 20
        static let horizontalInsets: CGFloat = 20
        static let bottomInset: CGFloat = 10
        static let imageViewWidthConstraint: CGFloat = 150
        static let contentViewColor: UIColor = .light
        static let imageHeightDivider: CGFloat = 2.5
        static let viewDivider: CGFloat = 2
        static let nameFont: UIFont = .largeTitle()
        static let ageFont: UIFont = .body()
        static let descriptionFont: UIFont = .body()
        static let textColor: UIColor = .dark
        static let lightTextColor: UIColor = .dark.withAlphaComponent(0.6)

    }

    func initialize() {
        view.backgroundColor = Constants.contentViewColor
        setupViews()
    }

    private func setupViews() {
        emptyView.backgroundColor = .clear

        let textStackView = UIStackView(arrangedSubviews: [plantNameLabel, plantAgeLabel, plantDescription])
        textStackView.axis = .vertical
        textStackView.distribution = .fill
        textStackView.alignment = .leading
        textStackView.spacing = 10

        [imageView, scrollView].forEach { item in
            view.addSubview(item)
        }

        view.sendSubviewToBack(imageView)

        [emptyView, containerView].forEach { item in
            scrollView.addSubview(item)
        }

        containerView.addSubview(textStackView)

        imageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().dividedBy(Constants.imageHeightDivider)
        }

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        emptyView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalToSuperview().dividedBy(Constants.viewDivider)

        }
        containerView.snp.makeConstraints { make in
            make.top.equalTo(emptyView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
            make.width.equalToSuperview()
        }

        textStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.topInset)
            make.horizontalEdges.equalToSuperview().inset(Constants.horizontalInsets)
            make.bottom.equalToSuperview().inset(Constants.bottomInset)
        }
    }
}

// MARK: - GardenInfoViewProtocol
extension GardenInfoViewController: GardenInfoViewProtocol {
    func showPlantInfo(plant: PlantViewModel) {
        self.imageView.image = plant.image
        self.plantNameLabel.text = plant.name
        self.plantAgeLabel.text = plant.age
        self.plantDescription.text = plant.description
    }
}
