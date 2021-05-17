//
//  FilterViewController.swift
//  SpaceX
//
//  Created by Aurelien Cobb on 16/05/2021.
//

import UIKit

final class FilterViewController: UIViewController {
    
    let viewModel: FilterViewModel
    
    lazy var backGroundControl: UIControl = {
        let control = UIControl()
        control.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        control.addTarget(self, action: #selector(close), for: .touchUpInside)
        return control
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 12
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    lazy var yearPicker: UIPickerView = {
        let picker = UIPickerView()
        picker.dataSource = self
        picker.delegate = self
        picker.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        return picker
    }()
    
    lazy var yearLabel: UILabel = {
        let label = UILabel()
        label.text = "FilterYear".localized
        return label
    }()
    
    lazy var successLabel: UILabel = {
        let label = UILabel()
        label.text = "FilterSuccess".localized
        return label
    }()
    
    lazy var successSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.addTarget(self, action: #selector(successSwitchChanged(_:)), for: .valueChanged)
        return switchView
    }()
    
    lazy var failedLabel: UILabel = {
        let label = UILabel()
        label.text = "FilterFailed".localized
        return label
    }()
    
    lazy var failedSwitch: UISwitch = {
        let switchView = UISwitch()
        switchView.addTarget(self, action: #selector(failedSwitchChanged(_:)), for: .valueChanged)
        return switchView
    }()
    
    lazy var sortOrderSegment: UISegmentedControl = {
        let control = UISegmentedControl(items: ["Ascending".localized,
                                                 "Descending".localized])
        
        control.addTarget(self, action: #selector(sortValueChanged(_:)), for: .valueChanged)
        return control
    }()
    
    init(viewModel: FilterViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        loadFilter()
    }
}

// MARK: - Target Action
extension FilterViewController {
    
    @objc func successSwitchChanged(_ sender: UISwitch) {
        viewModel.setSuccess(sender.isOn)
    }
    
    @objc func failedSwitchChanged(_ sender: UISwitch) {
        viewModel.setFailure(sender.isOn)
    }
    
    @objc func sortValueChanged(_ sender: UISegmentedControl) {
        if let sortOrder = FilterModel.SortOrder(rawValue: sender.selectedSegmentIndex)  {
            viewModel.set(sortOrder: sortOrder)
        }
    }
    
    @objc func close() {
        dismiss(animated: true, completion: nil)
    }
}

extension FilterViewController {
    
    func makeHorizontalStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        return stackView
    }
    
    func setupView() {
        view = backGroundControl
        view.addSubview(containerView)
        containerView.addSubview(stackView)
        
        let yearContainer = makeHorizontalStackView()
        yearContainer.addArrangedSubview(yearLabel)
        yearContainer.addArrangedSubview(yearPicker)
        
        let successContainer = makeHorizontalStackView()
        successContainer.addArrangedSubview(successLabel)
        successContainer.addArrangedSubview(successSwitch)
        
        let failedContainer = makeHorizontalStackView()
        failedContainer.addArrangedSubview(failedLabel)
        failedContainer.addArrangedSubview(failedSwitch)
        
        stackView.addArrangedSubview(yearContainer)
        stackView.addArrangedSubview(successContainer)
        stackView.addArrangedSubview(failedContainer)
        stackView.addArrangedSubview(sortOrderSegment)
        
        setupConstraints()
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            
            yearPicker.heightAnchor.constraint(equalToConstant: 100),
            
            stackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            stackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    func loadFilter() {
        successSwitch.isOn = viewModel.filterModel.success
        failedSwitch.isOn = viewModel.filterModel.failed
        
        yearPicker.selectRow(viewModel.filterModel.rowIndex, inComponent: 0, animated: true)
        sortOrderSegment.selectedSegmentIndex = viewModel.filterModel.sortOrder.rawValue
    }
}

extension FilterViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        viewModel.filterModel.validYears.count
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        viewModel.filterModel.validYears[row].label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.set(year: viewModel.filterModel.validYears[row])
    }
}
