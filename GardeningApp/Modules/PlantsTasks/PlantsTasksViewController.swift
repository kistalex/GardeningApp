//
// GardeningApp
// PlantsTasksViewController.swift
//
// Created by Alexander Kist on 22.12.2023.
//

import UIKit
import SwiftUI

protocol PlantsTasksViewProtocol: AnyObject {
    func setDateLabel(with date: Date)
}

class PlantsTasksViewController: UIViewController {
    // MARK: - Public
    var presenter: PlantsTasksPresenterProtocol?
    private var datePickerHostingController: UIHostingController<DatePickerWeekView>?

    private let currentDateLabel = CustomLabel(fontName: UIFont.body(), textColor: .accentLight)
    private let todayButton = CustomTextButton(text: "Today", bgColor: .accentLight)
    private let addTaskButton = CustomImageButton(imageName: "plus.circle", configImagePointSize: 35)
    private var selectedDate: Date = Calendar.current.startOfDay(for: Date.now) {
        didSet {
            setDateLabel(with: selectedDate)
        }
    }
    private var currentPage: Int = 0

    private var dateBinding: Binding<Date> {
        Binding<Date> {
            self.selectedDate
        } set: { newDate in
            self.selectedDate = newDate
            self.setDateLabel(with: newDate)
            self.presenter?.didSelectDate(newDate)
        }
    }

    private var pageBinding: Binding<Int> {
        Binding<Int> {
            self.currentPage
        } set: { [weak self] newPage in
            self?.currentPage = newPage
        }
    }


    // MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

// MARK: - Private functions
private extension PlantsTasksViewController {
    func initialize() {
        view.backgroundColor = .accentDark
        title = "Plants Tasks"
        setupViews()
        setDateLabel(with: selectedDate)
    }


    private func setupViews(){
        let datePickerView = DatePickerWeekView(date: dateBinding, page: pageBinding)
        datePickerHostingController = UIHostingController(rootView: datePickerView)
        guard let datePickerView = datePickerHostingController?.view else { return }
        datePickerView.backgroundColor = .accentLight
        datePickerView.layer.borderWidth = 0.5
        datePickerView.layer.borderColor = UIColor.accentLight.cgColor
        datePickerView.layer.cornerRadius = 10
        datePickerView.layoutIfNeeded()
        addChild(datePickerHostingController!)
        datePickerHostingController?.didMove(toParent: self)

        [datePickerView, currentDateLabel, todayButton, addTaskButton].forEach { item in
            view.addSubview(item)
        }


        currentDateLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
        }

        todayButton.snp.makeConstraints { make in
            make.centerY.equalTo(currentDateLabel.snp.centerY)
            make.trailing.equalToSuperview().inset(15)
            make.width.equalTo(80)
        }


        datePickerView.snp.makeConstraints { make in
            make.top.equalTo(currentDateLabel.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(110)
        }

        addTaskButton.snp.makeConstraints { make in
            make.top.equalTo(datePickerView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(80)
        }

        todayButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }

    @objc private func buttonTapped() {
        self.selectedDate = Calendar.current.startOfDay(for: Date.now)
        self.currentPage = 0
    }}



// MARK: - PlantsTasksViewProtocol
extension PlantsTasksViewController: PlantsTasksViewProtocol {
    func setDateLabel(with date: Date) {
        self.currentDateLabel.text = date.toString(format: "MMMM d, yyyy")
    }
}
