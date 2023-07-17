import UIKit
import SnapKit

class SettingsViewController: UIViewController {
    let spacingLabel = UILabel()
    let spacingSlider = UISlider()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupSpacingSlider()
        setupNavigationBar()
        setupSpacingLabel()
    }
    
    private func setupNavigationBar() {
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonTapped))
        navigationItem.rightBarButtonItem = saveButton
        
        let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
        
        navigationItem.title = "Настройки"
    }
    
    @objc private func saveButtonTapped() {
        UserDefaults.standard.set(TableViewController.cellSpacing, forKey: "CellSpacing")
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupSpacingLabel(){
        spacingLabel.text = "Изменить расстояние между товарами"
        view.addSubview(spacingLabel)
        spacingLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(spacingSlider.snp.top).offset(-16)
        }
    }
    
    private func setupSpacingSlider() {
        spacingSlider.minimumValue = 0
        spacingSlider.maximumValue = 20
        spacingSlider.value = Float(TableViewController.cellSpacing)
        spacingSlider.addTarget(self, action: #selector(spacingSliderValueChanged), for: .valueChanged)
        
        view.addSubview(spacingSlider)
        spacingSlider.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }
    }
    
    @objc private func spacingSliderValueChanged() {
        TableViewController.cellSpacing = CGFloat(spacingSlider.value)
        NotificationCenter.default.post(name: NSNotification.Name("CellSpacingChanged"), object: nil)
        
        if let menuViewController = presentingViewController as? MenuViewController {
            menuViewController.buyButton.setNeedsLayout()
        }
    }
}
