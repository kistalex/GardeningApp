//
//
// GardeningApp
// ImageTableViewCell.swift
//
// Created by Alexander Kist on 23.01.2024.
//


import UIKit
import SnapKit

class ImageTableViewCellModel: NSObject, TableViewCellItemModel {
    var identifier: String = String(describing: ImageTableViewCellModel.self)

    var image: UIImage

    init(image: UIImage){
        self.image = image
    }
}

class ImageTableViewCell: UITableViewCell, HomeTableViewCellItem {

    weak var delegate: HomeTableViewCellItemDelegate?

    func config(with data: Any) {
        guard let data = data as? ImageTableViewCellModel else { return }
        iconImageView.image = data.image
        contentView.backgroundColor = .light
    }
    
    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()


    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 10
        iv.layer.masksToBounds = true
        return iv
    }()
    

    private let taskManagerButton = CustomImageButton(imageName: "", configImagePointSize: 40, bgColor: .dark)

    private var widthConstraint: Constraint?


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupPanButtonGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupViews(){
        contentView.addSubview(taskManagerButton)
        contentView.addSubview(shadowView)
        shadowView.addSubview(iconImageView)

        shadowView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(10)
            make.size.equalTo(200)
        }

        iconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        taskManagerButton.snp.makeConstraints { make in
            make.centerY.equalTo(shadowView.snp.centerY)
            make.trailing.equalToSuperview()
            widthConstraint = make.width.equalTo(35).constraint
            make.height.equalTo(35)
        }
    }

    private func setupPanButtonGesture(){
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        taskManagerButton.addGestureRecognizer(panGesture)
        taskManagerButton.addTarget(self, action: #selector(taskButtonTapped), for: .touchUpInside)
    }

    @objc private func taskButtonTapped(){
        delegate?.didTapOpenTaskList(self)
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
                self.contentView.layoutIfNeeded()
            }
            gesture.setTranslation(.zero, in: taskManagerButton)
        case .ended, .cancelled:
            widthConstraint?.update(offset: 35)
            UIView.animate(withDuration: 0.3, animations: {
                self.contentView.layoutIfNeeded()
            })
        default:
            break
        }
    }

    private func setupShadow(){
        shadowView.layer.shadowColor = UIColor.dark.cgColor

        shadowView.layer.shadowOpacity = 0.8
        shadowView.layer.shadowRadius = 10
        shadowView.layer.shadowOffset = CGSize(width: 0, height: 5)

        let cornerRadius: CGFloat = 5
        let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: cornerRadius)

        shadowView.layer.shadowPath = shadowPath.cgPath

        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadow()
        shadowView.layer.cornerRadius = 10
        iconImageView.layer.cornerRadius = 10
    }
}

