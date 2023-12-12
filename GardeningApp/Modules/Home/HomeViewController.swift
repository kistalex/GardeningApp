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
}

class HomeViewController: UIViewController {
    // MARK: - Public
    var presenter: HomePresenterProtocol?



    private let buttonView = ButtonView()
    private let greetingsView = GreetingsView()
    private lazy var shadowImageView = ShadowImageView()
    private let weatherInfoView = WeatherInfoView()
    private let gardenHeader = GardenHeader(frame: .zero)
    private let taskManagerButton = CustomButton(imageName: "list.number", configImagePointSize: 40, bgColor: .accent)
    private lazy var gardenCollectionView = UICollectionView()

    var plants: [Plant] = [
        Plant(image: "noImage", name: "Fern", age: "2 years"),
        Plant(image: "noImage", name: "Sunflower", age: "3 months"),
        Plant(image: "noImage", name: "Fern", age: "2 years"),
        Plant(image: "noImage", name: "Sunflower", age: "3 months"),
        Plant(image: "noImage", name: "Fern", age: "2 years"),
        Plant(image: "noImage", name: "Sunflower", age: "3 months"),
    ]

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
        view.backgroundColor = .background

        view.addSubview(buttonView)
        view.addSubview(greetingsView)
        view.addSubview(shadowImageView)
        view.addSubview(weatherInfoView)
        view.addSubview(taskManagerButton)
        view.addSubview(gardenHeader)

        buttonView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        greetingsView.snp.makeConstraints { make in
            make.top.equalTo(buttonView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }


        shadowImageView.snp.makeConstraints { make in
            make.top.equalTo(greetingsView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.size.equalTo(175).multipliedBy(2)
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
        }
    }

    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)

        gardenCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        gardenCollectionView.register(PlantCell.self, forCellWithReuseIdentifier: "\(PlantCell.self)")
        gardenCollectionView.backgroundColor = .background
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
        return plants.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(PlantCell.self)", for: indexPath) as? PlantCell else {
            return UICollectionViewCell()
        }
        let plant = plants[indexPath.row]
        cell.configureCell(with: plant)
        return cell
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width / 2
        let height = collectionView.bounds.height - 20
        return CGSize(width: width, height: height)
    }
}

extension HomeViewController: HomeModuleEventsDelegate {
    func didTapButton(sender: GardenHeader) {
        print("Нажали добавить новое растение")
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
}
