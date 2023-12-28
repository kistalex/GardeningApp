//
// GardeningApp
// HomeViewController.swift
//
// Created by Alexander Kist on 10.12.2023.
//

import UIKit
import SnapKit

protocol HomeViewProtocol: AnyObject {
    func showImageForCurrentTime(image: UIImage?)
    func showGreetingForCurrentTime(text: String)
    func showCurrentWeatherData(with weather: WeatherData)
    func setPlants(with plants: [PlantObject])
}

class HomeViewController: UIViewController {
    // MARK: - Public
    var presenter: HomePresenterProtocol?

    private let buttonView = ButtonView()
    private let greetingsView = GreetingsView()
    private lazy var shadowImageView = ShadowImageView()
    private let weatherInfoView = WeatherInfoView()
    private let gardenHeader = GardenHeader(frame: .zero)
    private let taskManagerButton = CustomImageButton(imageName: "", configImagePointSize: 40, bgColor: .accentLight)
    private lazy var gardenCollectionView = UICollectionView()
    
    private var userPlants = [PlantObject]()
    private var widthConstraint: Constraint?

    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter?.viewDidLoad()
    }
}

// MARK: - Private functions
private extension HomeViewController {
    func initialize() {
        setupViews()
        setupCollectionView()
        setViewDelegate()
    }
    
    private func setViewDelegate(){
        gardenHeader.delegate = self
        buttonView.delegate = self
    }

    private func setupViews(){
        view.backgroundColor = .accentDark
        title = "Home"

        [buttonView, greetingsView, shadowImageView, weatherInfoView, taskManagerButton, gardenHeader].forEach { item in
            view.addSubview(item)
        }

        buttonView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        greetingsView.snp.makeConstraints { make in
            make.top.equalTo(buttonView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }

        shadowImageView.snp.makeConstraints { make in
            make.top.equalTo(greetingsView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalToSuperview().dividedBy(5)
            make.width.equalTo(shadowImageView.snp.height)
        }

        weatherInfoView.snp.makeConstraints { make in
            make.top.equalTo(shadowImageView.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        gardenHeader.snp.makeConstraints { make in
            make.top.equalTo(weatherInfoView.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalToSuperview().dividedBy(15)
        }

        taskManagerButton.snp.makeConstraints { make in
            make.centerY.equalTo(shadowImageView.snp.centerY)
            make.trailing.equalToSuperview()
            widthConstraint = make.width.equalTo(35).constraint
            make.height.equalTo(35)
        }
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        taskManagerButton.addGestureRecognizer(panGesture)
        taskManagerButton.addTarget(self, action: #selector(taskButtonTapped), for: .touchUpInside)
    }
    
    @objc private func taskButtonTapped(){
        presenter?.didTapTaskManagerButton()
    }

    @objc private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .changed:
            let translation = gesture.translation(in: taskManagerButton)
            let minWidth: CGFloat = 30
            let maxWidth: CGFloat = 150
            if let currentWidth = widthConstraint?.layoutConstraints.first?.constant {
                let newWidth = min(maxWidth, max(minWidth, currentWidth - translation.x))
                widthConstraint?.update(offset: newWidth)
                self.view.layoutIfNeeded()
            }
            gesture.setTranslation(.zero, in: taskManagerButton)
        case .ended, .cancelled:
            widthConstraint?.update(offset: 35)
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        default:
            break
        }
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)

        gardenCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        gardenCollectionView.register(PlantCell.self, forCellWithReuseIdentifier: "\(PlantCell.self)")
        gardenCollectionView.backgroundColor = .accentDark
        gardenCollectionView.showsVerticalScrollIndicator = false
        gardenCollectionView.showsHorizontalScrollIndicator = false

        gardenCollectionView.dataSource = self
        gardenCollectionView.delegate = self 

        view.addSubview(gardenCollectionView)

        gardenCollectionView.snp.makeConstraints { make in
            make.top.equalTo(gardenHeader.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(40)
        }
    }
}

//MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPlants.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PlantCell.self)", for: indexPath) as? PlantCell else {
            return UICollectionViewCell()
        }
        let plant = userPlants[indexPath.row]
        cell.configureCell(with: plant)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2
        let height = collectionView.bounds.height - 30
        return CGSize(width: width, height: height)
    }
}

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let plant = userPlants[indexPath.row]
        presenter?.didTapOpenGardenInfo(with: plant)
    }
}

extension HomeViewController: HomeModuleEventsDelegate {
    func didTapAddNewPlantButton(sender: GardenHeader) {
        presenter?.didTapAddNewPlant()
    }

    func didTapSearchButton(sender: ButtonView) {
        print("Нажали на поиск")
    }

    func didTapNotificationButton(sender: ButtonView) {
        print("Нажали на колокольчик")
    }
}

// MARK: - HomeViewProtocol
extension HomeViewController: HomeViewProtocol {
    func showImageForCurrentTime(image: UIImage?) {
        shadowImageView.setImage(with: image)
    }

    func showGreetingForCurrentTime(text: String) {
        greetingsView.setText(with: text)
    }

    func showCurrentWeatherData(with weather: WeatherData) {
        weatherInfoView.setInfo(with: weather)
    }

    func setPlants(with plants: [PlantObject]) {
        userPlants = plants
        gardenCollectionView.reloadData()
    }
}
