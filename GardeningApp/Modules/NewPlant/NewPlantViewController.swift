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
    func setCells(with items: [TableViewCellItemModel])
}

class NewPlantViewController: UITableViewController {
    // MARK: - Public
    var presenter: NewPlantPresenterProtocol?

    private var items = [TableViewCellItemModel]()
    private var plantModel = PlantModel()


    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        presenter?.didFetchCells()
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: items[indexPath.row].identifier) as? AddPlantTableViewCellItem
        cell?.config(with: items[indexPath.row])
        cell?.delegate = self
        return cell as? UITableViewCell ?? UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}

// MARK: - Private functions
private extension NewPlantViewController {
    func initialize() {
        view.backgroundColor = .light
        registerCells()
        setupDismissKeyboardGesture()
        setupView()
    }

    private func setupView(){

        tableView.separatorInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = UITableView.automaticDimension
        tableView.showsVerticalScrollIndicator = false
        tableView.allowsSelection = false
    }

    private func setupDismissKeyboardGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        tableView.endEditing(true)
    }

    private func registerCells(){
        tableView.register(PlantImageTableViewCell.self, forCellReuseIdentifier: "\(PlantImageTableViewCellModel.self)")
        tableView.register(PlantNameTableCell.self, forCellReuseIdentifier: "\(PlantNameTableCellModel.self)")
        tableView.register(DatePlantCaringTableViewCell.self, forCellReuseIdentifier: "\(DatePlantCaringTableViewCellModel.self)")
        tableView.register(PlantDescriptionTableViewCell.self, forCellReuseIdentifier: "\(PlantDescriptionTableViewCellModel.self)")
        tableView.register(SavePlantButtonTableViewCell.self, forCellReuseIdentifier: "\(SavePlantButtonTableViewCellModel.self)")

    }
}
extension NewPlantViewController: AddPlantTableViewItemDelegate {
    func didTapOpenImagePicker(_ cell: PlantImageTableViewCell) {
        presenter?.didTapOpenImagePicker()
    }
    
    func didInputPlantName(_ cell: PlantNameTableCell, with name: String) {
        plantModel.name = name
    }
    
    func didChoseStartCaringDate(_ cell: DatePlantCaringTableViewCell, with date: Date) {
        plantModel.age = date
    }
    
    func didWriteDescription(_ cell: PlantDescriptionTableViewCell, with text: String) {
        plantModel.description = text
    }
    
    func didTapSaveButton(_ cell: SavePlantButtonTableViewCell) {
        presenter?.didTapSavePlant(for: plantModel)
    }
}
extension NewPlantViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        presenter?.didFinishPickingImage(results: results)
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - NewPlantViewProtocol
extension NewPlantViewController: NewPlantViewProtocol {
    func setCells(with items: [TableViewCellItemModel]) {
        self.items = items
    }

    func displayImage(_ image: UIImage) {
        if let index = items.firstIndex(where: { $0 is PlantImageTableViewCellModel }) {
            if let currentDateModel = items[index] as? PlantImageTableViewCellModel {
                currentDateModel.placeholderImage = image
                items[index] = currentDateModel
                let indexPath = IndexPath(row: index, section: 0)
                DispatchQueue.main.async {
                    self.tableView.reloadRows(at: [indexPath], with: .fade)
                }
                plantModel.image = image
            }
        }
    }
}
