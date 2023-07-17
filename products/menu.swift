import UIKit
import SnapKit

class MenuViewController: UIViewController {
    
    let homeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.setTitle("Главный экран", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(home), for: .touchUpInside)
        return button
    }()
    let buyButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.setTitle("Список покупок", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buy), for: .touchUpInside)
        return button
    }()
    let settingButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray6
        button.setTitle("Настойки", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(settingButtonTapped), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        view.addSubview(homeButton)
        view.addSubview(buyButton)
        view.addSubview(settingButton)
        makeConstraints()
        setupButtonIcons()

        if #available(iOS 13.0, *) {
            homeButton.setTitleColor(UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ? .white : .black
            }, for: .normal)
            buyButton.setTitleColor(UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ? .white : .black
            }, for: .normal)
            settingButton.setTitleColor(UIColor { (traits) -> UIColor in
                return traits.userInterfaceStyle == .dark ? .white : .black
            }, for: .normal)
        } else {
            homeButton.setTitleColor(.black, for: .normal)
            buyButton.setTitleColor(.black, for: .normal)
            settingButton.setTitleColor(.black, for: .normal)
        }
    }
    func makeConstraints() {
        homeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-85)
            make.top.equalToSuperview().offset(20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        buyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-80)
            make.top.equalTo(homeButton.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        settingButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-105)
            make.top.equalTo(buyButton.snp.bottom).offset(20)
            make.width.equalTo(200)
            make.height.equalTo(50)
        }
        
        
    }
    func setupButtonIcons() {
        let homeIcon = UIImage(systemName: "house")
        homeButton.setImage(homeIcon, for: .normal)
        homeButton.imageView?.contentMode = .scaleAspectFit
        homeButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
        
        
        let buyIcon = UIImage(systemName: "cart")
        buyButton.setImage(buyIcon, for: .normal)
        buyButton.imageView?.contentMode = .scaleAspectFit
        buyButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 40)
        
        
        let settingIcon = UIImage(systemName: "gearshape")
        settingButton.setImage(settingIcon, for: .normal)
        settingButton.imageView?.contentMode = .scaleAspectFit
        settingButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 42)
        
        
    }
    
    
    
    @objc func home() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func buy() {
        let viewController = TableViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
    
    @objc func settingButtonTapped() {
        let viewController = SettingsViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true, completion: nil)
    }
}
