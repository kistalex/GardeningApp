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
        contentView.backgroundColor = Constants.contentViewBgColor
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        setupPanButtonGesture()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private enum Constants {
        static let shadowViewTopInset: CGFloat = 10
        static let shadowViewBottomInset: CGFloat = 10
        static let shadowViewSize: CGFloat = 200
        static let shadowViewShadowOpacity: Float = 0.8
        static let shadowViewShadowRadius: CGFloat = 10
        static let shadowViewShadowOffset: CGSize = CGSize(width: 0, height: 5)
        static let shadowPathCornerRadius: CGFloat = 5
        static let taskButtonWidthConstraint: CGFloat = 35
        static let taskButtonHeightConstraint: CGFloat = 35
        static let taskButtonMinWidthConstraint: CGFloat = 30
        static let taskButtonMaxWidthConstraint: CGFloat = 150
        static let iconImageViewCornerRadius: CGFloat = 10
        static let contentViewBgColor: UIColor = .light
    }

    private let shadowView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()

    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = Constants.iconImageViewCornerRadius
        iv.layer.masksToBounds = true
        return iv
    }()
    

    private let taskManagerButton = CustomImageButton(imageName: "", configImagePointSize: 40, bgColor: .dark)

    private var widthConstraint: Constraint?

    private func setupViews(){
        contentView.addSubview(taskManagerButton)
        contentView.addSubview(shadowView)
        shadowView.addSubview(iconImageView)

        shadowView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.shadowViewTopInset)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(Constants.shadowViewBottomInset)
            make.size.equalTo(Constants.shadowViewSize)
        }

        iconImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        taskManagerButton.snp.makeConstraints { make in
            make.centerY.equalTo(shadowView.snp.centerY)
            make.trailing.equalToSuperview()
            widthConstraint = make.width.equalTo(Constants.taskButtonWidthConstraint).constraint
            make.height.equalTo(Constants.taskButtonHeightConstraint)
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
            let minWidth: CGFloat = Constants.taskButtonMinWidthConstraint
            let maxWidth: CGFloat = Constants.taskButtonMaxWidthConstraint
            if let currentWidth = widthConstraint?.layoutConstraints.first?.constant {
                let newWidth = min(maxWidth, max(minWidth, currentWidth - translation.x))
                widthConstraint?.update(offset: newWidth)
                self.contentView.layoutIfNeeded()
            }
            gesture.setTranslation(.zero, in: taskManagerButton)
        case .ended, .cancelled:
            widthConstraint?.update(offset: Constants.taskButtonWidthConstraint)
            UIView.animate(withDuration: 0.3, animations: {
                self.contentView.layoutIfNeeded()
            })
        default:
            break
        }
    }

    private func setupShadow(){
        shadowView.layer.shadowColor = UIColor.dark.cgColor
        shadowView.layer.cornerRadius = Constants.shadowPathCornerRadius
        shadowView.layer.shadowOpacity = Constants.shadowViewShadowOpacity
        shadowView.layer.shadowRadius = Constants.shadowViewShadowRadius
        shadowView.layer.shadowOffset = Constants.shadowViewShadowOffset

        let cornerRadius: CGFloat = Constants.shadowPathCornerRadius
        let shadowPath = UIBezierPath(roundedRect: shadowView.bounds, cornerRadius: cornerRadius)

        shadowView.layer.shadowPath = shadowPath.cgPath

        shadowView.layer.shouldRasterize = true
        shadowView.layer.rasterizationScale = UIScreen.main.scale
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setupShadow()
        iconImageView.layer.cornerRadius = Constants.iconImageViewCornerRadius
    }
}

