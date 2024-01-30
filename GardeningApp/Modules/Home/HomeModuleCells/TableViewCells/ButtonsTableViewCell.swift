//
//
// GardeningApp
// ButtonsTableViewCell.swift
// 
// Created by Alexander Kist on 23.01.2024.
//


import UIKit
import SnapKit

class ButtonsTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: ButtonsTableViewCellModel.self)

    var searchIconName: String
    var notifyIconName: String
    var imagePointSize: CGFloat

    init(searchIconName: String, notifyIconName: String, imagePointSize: CGFloat) {
        self.searchIconName = searchIconName
        self.notifyIconName = notifyIconName
        self.imagePointSize = imagePointSize
    }

}

class ButtonsTableViewCell: UITableViewCell, HomeTableViewCellItem {
    weak var delegate: HomeTableViewCellItemDelegate?

    func config(with data: Any) {
        guard let data = data as? ButtonsTableViewCellModel else { return }
        let configuration = UIImage.SymbolConfiguration(pointSize: data.imagePointSize)
        contentView.backgroundColor = Constants.contentViewBgColor
        searchButton.setImage(UIImage(systemName: data.searchIconName, withConfiguration: configuration), for: .normal)
        notificationButton.setImage(UIImage(systemName: data.notifyIconName, withConfiguration: configuration), for: .normal)
    }

    private enum Constants {
        static let greetingTextFont = UIFont.title()
        static let stackHorizontalInsets: CGFloat = 20
        static let stackBottomInset: CGFloat = 10
        static let contentViewBgColor: UIColor = .light
    }

    private let searchButton = UIButton(type: .system)
    private let notificationButton = UIButton(type: .system)
    private var buttonStack = UIStackView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews() {


        [searchButton, notificationButton].forEach { item  in
            item.tintColor = .dark
            buttonStack.addArrangedSubview(item)}

        buttonStack.axis = .horizontal
        buttonStack.distribution = .equalSpacing

        contentView.addSubview(buttonStack)

        buttonStack.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(Constants.stackHorizontalInsets)
            make.bottom.equalToSuperview().inset(Constants.stackBottomInset)
        }

        searchButton.addTarget(self, action: #selector(handleSearchButtonTap), for: .touchUpInside)
        notificationButton.addTarget(self, action: #selector(handleNotificationButtonTap), for: .touchUpInside)
    }

    //MARK: - Selectors
    @objc private func handleSearchButtonTap(){
        delegate?.didTapSearchButton(self)
    }

    @objc private func handleNotificationButtonTap(){
        delegate?.didTapNotificationButton( self)
    }
}

