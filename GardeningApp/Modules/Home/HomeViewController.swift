//
// GardeningApp
// HomeViewController.swift
//
// Created by Alexander Kist on 10.12.2023.
//

import UIKit
import SnapKit

protocol HomeViewProtocol: AnyObject {
    func setCells(_ items: [TableViewCellItemModel])
    func showCurrentWeatherData(with weather: WeatherViewModel)
    func setPlants(with plants: [PlantViewModel])
}

class HomeViewController: UITableViewController {
    // MARK: - Public
    var presenter: HomePresenterProtocol?

    private var items = [TableViewCellItemModel]()


    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter?.viewDidLoad()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupScroll()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: items[indexPath.row].identifier) as? HomeTableViewCellItem
        cell?.config(with: items[indexPath.row])
        cell?.delegate = self
        return cell as? UITableViewCell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}

// MARK: - Private functions
private extension HomeViewController {
    func initialize() {
        setupViews()
        registerCells()
    }
    
    private func setupViews(){
        view.backgroundColor = .light
        title = "Home"
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
    }

    private func registerCells(){
        tableView.register(ButtonsTableViewCell.self, forCellReuseIdentifier: "\(ButtonsTableViewCellModel.self)")
        tableView.register(GreetingsTableViewCell.self, forCellReuseIdentifier: "\(GreetingsTableViewCellModel.self)")
        tableView.register(ImageTableViewCell.self, forCellReuseIdentifier: "\(ImageTableViewCellModel.self)")
        tableView.register(WeatherInfoTableViewCell.self, forCellReuseIdentifier: "\(WeatherInfoTableViewCellModel.self)")
        tableView.register(GardenHeaderTableViewCell.self, forCellReuseIdentifier: "\(GardenHeaderTableViewCellModel.self)")
        tableView.register(UserPlantCollectionTableViewCell.self, forCellReuseIdentifier: "\(UserPlantCollectionTableViewCellModel.self)")
    }

    private func setupScroll(){
        let contentHeight = tableView.contentSize.height
        if contentHeight < tableView.frame.size.height{
            tableView.isScrollEnabled = false
        }
    }
}



extension HomeViewController: HomeTableViewCellItemDelegate {
    func didTapOpenTaskList(_ cell: ImageTableViewCell) {
        presenter?.didTapTaskManagerButton()
    }
    
    func didTapOpenGardenInfo(_ cell: UserPlantCollectionTableViewCell, plant: PlantViewModel) {
        presenter?.didTapOpenGardenInfo(with: plant)
    }
    
    func didTapAddNewPlantButton(_ cell: GardenHeaderTableViewCell) {
        presenter?.didTapAddNewPlant()
    }
    
    func didTapSearchButton(_ cell: ButtonsTableViewCell) {
        print("Search tapped")
    }
    func didTapNotificationButton(_ cell: ButtonsTableViewCell) {
        print("Notif tapped")
    }
}

// MARK: - HomeViewProtocol
extension HomeViewController: HomeViewProtocol {

    func setCells(_ items: [TableViewCellItemModel]) {
        self.items = items
        tableView.reloadData()
    }


    func showCurrentWeatherData(with weather: WeatherViewModel) {
        if let weatherInfoIndex = items.firstIndex(where: { $0 is WeatherInfoTableViewCellModel }),
           let weatherInfoCellModel = items[weatherInfoIndex] as? WeatherInfoTableViewCellModel {
            weatherInfoCellModel.weatherData = weather
            let indexPath = IndexPath(row: weatherInfoIndex, section: 0)
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }

    func setPlants(with plants: [PlantViewModel]) {
        if let plantsCollectionIndex = items.firstIndex(where: { $0 is UserPlantCollectionTableViewCellModel }),
           let plantsCollectionModel = items[plantsCollectionIndex] as? UserPlantCollectionTableViewCellModel {
            plantsCollectionModel.plants = plants
            let indexPath = IndexPath(row: plantsCollectionIndex, section: 0)
            DispatchQueue.main.async {
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            }
        }
    }
}
