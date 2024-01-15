//
//
// GardeningApp
// AddTaskButtonTableViewCell.swift
// 
// Created by Alexander Kist on 15.01.2024.
//


import Foundation
import UIKit
import SwiftUI

class AddTaskButtonTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: AddTaskButtonTableViewCellModel.self)

    var buttonImageName: String
    var imagePointSize: CGFloat

    init(imageName: String, imagePointSize: CGFloat) {
        self.buttonImageName = imageName
        self.imagePointSize = imagePointSize
    }
}

final class AddTaskButtonTableViewCell: UITableViewCell, PlantTaskTableViewCellItem {

    weak var delegate: PlantTaskTableViewItemDelegate?

    private let actionButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }

    private func setupButton() {
        contentView.addSubview(actionButton)
        actionButton.setImage(UIImage(systemName: "plus.circle"), for: .normal)
        actionButton.tintColor = .accentLight
        actionButton.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        actionButton.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
    }

    @objc private func actionButtonTapped(){
        delegate?.buttonCellDidTapped(self)
    }


    override func layoutIfNeeded() {
        super.layoutIfNeeded()
        actionButton.layer.cornerRadius = actionButton.frame.size.height / 2
    }

    func config(with data: Any) {
        guard let data = data as? AddTaskButtonTableViewCellModel else { return }
        let configuration = UIImage.SymbolConfiguration(pointSize: data.imagePointSize)
        contentView.backgroundColor = .accentDark
        actionButton.setImage(UIImage(systemName: data.buttonImageName, withConfiguration: configuration), for: .normal)
    }
}


struct AddTaskButtonContentViewPreview: PreviewProvider {
    struct AddTaskButtonContent: UIViewRepresentable {
        func makeUIView(context: Context) -> some UIView {
            AddTaskButtonTableViewCell()
        }
        func updateUIView(_ uiView: UIViewType, context: Context) {}
    }

    static var previews: some View {
        let size = UIScreen.main.bounds
        AddTaskButtonContent()
            .background(.accentDark)
            .padding(5)
            .frame(width: size.width, height: size.height / 5)
    }
}
