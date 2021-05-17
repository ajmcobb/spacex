//
//  LaunchCell.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 15/05/2021.
//

import UIKit

final class LaunchCell: UITableViewCell {
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .top
        stackView.spacing = 12
        return stackView
    }()
    
    lazy var missionPatchImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var successIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var infoStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()
    
    let missionNameView = InfoView()
    let dateTimeView = InfoView()
    let rocketView = InfoView()
    let daysView = InfoView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        missionPatchImageView.image = nil
    }
    
    func configure(with launch: Launch,
                   dateProvider: () -> Date,
                   dateFormatter: DateFormatter) {
        missionNameView.configure(info: "Mission".localized,
                                  description: launch.missionName)
        
        dateTimeView.configure(info: "DateTime".localized,
                               description: dateFormatter.string(from: launch.date))
        rocketView.configure(info: "Rocket".localized,
                             description: "\(launch.rocket.name) / \(launch.rocket.type)")
        let differenceInSecondsFromNow = launch.launchDateUNIX - dateProvider().timeIntervalSince1970
        let pastFutureIndicator = differenceInSecondsFromNow > 0 ? "FutureIndicator".localized : "PastIndicator".localized
        daysView.configure(info: "DaysFrom".localized(pastFutureIndicator),
                           description: launch.launchDateUNIX.daysDifference(to: dateProvider().timeIntervalSince1970))
        
        if let success = launch.launchSuccess {
            successIconView.image = success ? UIImage(systemName: "checkmark") : UIImage(systemName: "xmark")
            successIconView.tintColor = success ? .systemGreen : .systemRed
        }
    }
    
    func configure(withImage image: UIImage?) {
        missionPatchImageView.image = image
    }
}

extension LaunchCell {
    private func setupView() {
        contentView.addSubview(mainStackView)
        mainStackView.addArrangedSubview(missionPatchImageView)
        mainStackView.addArrangedSubview(infoStackView)
        mainStackView.addArrangedSubview(successIconView)
        [missionNameView, dateTimeView, rocketView, daysView].forEach {
            infoStackView.addArrangedSubview($0)
        }
        selectionStyle = .none
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            
            missionPatchImageView.widthAnchor.constraint(equalToConstant: 42),
            missionPatchImageView.heightAnchor.constraint(equalToConstant: 42),
            
            successIconView.widthAnchor.constraint(equalToConstant: 40),
            successIconView.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}

final class InfoView: UIView {
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(info: String, description: String) {
        infoLabel.text = info
        descriptionLabel.text = description
    }
    
    func setupView() {
        addSubview(stackView)
        stackView.addArrangedSubview(infoLabel)
        stackView.addArrangedSubview(descriptionLabel)
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            descriptionLabel.widthAnchor.constraint(equalTo: infoLabel.widthAnchor, multiplier: 1.3)
        ])
    }
}
