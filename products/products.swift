import UIKit
import SnapKit
import Foil

class TableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    let tableView = UITableView()
    let searchBar = UISearchBar()
    var filteredProducts: [String] = []
    var selectedProducts: Set<Int> = []
    static var cellSpacing: CGFloat = 10.0
    let totalPriceLabel = UILabel()
    let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 2
        return formatter
    }()
    private func updateTotalPriceLabel() {
        let totalPrice = calculateTotalPrice()
        let formattedPrice = numberFormatter.string(from: NSNumber(value: totalPrice)) ?? "0.00"
        totalPriceLabel.text = "Итоговая цена: \(formattedPrice)"
    }

override func viewDidLoad() {
    super.viewDidLoad()
    if let cellSpacing = UserDefaults.standard.value(forKey: "CellSpacing") as? CGFloat {
        TableViewController.cellSpacing = cellSpacing
    }
    setupNavigationBar()
    setupNotificationObserver()
    setupTableView()
    setupSearchBar()
    setupTotalPriceLabel()
    tableView.separatorStyle = .none
    tableView.rowHeight = UITableView.automaticDimension
    tableView.estimatedRowHeight = 44.0
    tableView.contentInset = UIEdgeInsets(top: TableViewController.cellSpacing, left: 0, bottom: TableViewController.cellSpacing, right: 0)
    NotificationCenter.default.addObserver(self, selector: #selector(cellSpacingChanged), name: NSNotification.Name("CellSpacingChanged"), object: nil)
    tableView.reloadData()
}

private func setupNotificationObserver() {
    NotificationCenter.default.addObserver(self, selector: #selector(cellSpacingChanged), name: NSNotification.Name("CellSpacingChanged"), object: nil)
}

@objc private func cellSpacingChanged() {
    if let cellSpacing = UserDefaults.standard.value(forKey: "CellSpacing") as? CGFloat {
        TableViewController.cellSpacing = cellSpacing
        tableView.reloadData()
    }
}

private func setupNavigationBar() {
    let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
    navigationItem.rightBarButtonItem = addButton

    let backButton = UIBarButtonItem(title: "Назад", style: .plain, target: self, action: #selector(backButtonTapped))
    navigationItem.leftBarButtonItem = backButton
    navigationItem.title = "Список покупок"
}

private func setupTableView() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.frame = view.bounds
    view.addSubview(tableView)
}

private func setupSearchBar() {
    searchBar.delegate = self
    searchBar.showsCancelButton = true
    searchBar.placeholder = "Поиск"
    searchBar.searchBarStyle = .minimal
    searchBar.sizeToFit()
    tableView.tableHeaderView = searchBar
}

private func setupTotalPriceLabel() {
    view.addSubview(totalPriceLabel)
    totalPriceLabel.font = UIFont.systemFont(ofSize: 18)
    totalPriceLabel.textColor = .black
    totalPriceLabel.snp.makeConstraints { (make) in
        make.centerX.equalToSuperview()
        make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
    }
    updateTotalPriceLabel()
}

private func calculateTotalPrice() -> Double {
    var totalPrice = 0.0
    for productJSONString in AppDefaults.shared.shoppingList {
        guard let product = JSONHelper.convertJSON(productJSONString) else { continue }
        totalPrice += product.price * Double(product.amount)
    }
    return totalPrice
}

func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if searchBar.text != "" {
        return filteredProducts.count
    } else {
        return AppDefaults.shared.shoppingList.count
    }
}

private func setProductLabelColor(for cell: UITableViewCell, product: Product) {
    if #available(iOS 13.0, *) {
        if self.traitCollection.userInterfaceStyle == .dark {
            cell.textLabel?.textColor = .white
        } else {
            cell.textLabel?.textColor = .black
        }
    } else {
        cell.textLabel?.textColor = product.selected ? .black : .white
    }
}

func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: .default, reuseIdentifier: nil)
    let productLabel = createProductLabel()
    cell.contentView.addSubview(productLabel)
    productLabel.snp.makeConstraints { (make) in
        make.trailing.equalTo(cell.contentView.snp.trailingMargin)
        make.centerY.equalTo(cell.contentView)
    }
    var productJSONString: String
    if searchBar.text != "" {
        productJSONString = filteredProducts[indexPath.row]
    } else {
        productJSONString = AppDefaults.shared.shoppingList[indexPath.row]
    }

    let product = JSONHelper.convertJSON(productJSONString)!
    cell.textLabel?.text = "\(product.name)"
    productLabel.text = "КОЛ-ВО: \(product.amount), ЦЕНА: \(product.price)"
    cell.accessoryType = product.selected ? .checkmark : .none
    cell.selectionStyle = .default
    setProductLabelColor(for: cell, product: product)
    return cell
}

private func createProductLabel() -> UILabel {
    let label = UILabel()
    label.textColor = .lightGray
    label.font = UIFont.boldSystemFont(ofSize: 16)
    return label
}

func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)

    var productJSONString: String
    if searchBar.text != "" {
        productJSONString = filteredProducts[indexPath.row]
    } else {
        productJSONString = AppDefaults.shared.shoppingList[indexPath.row]
    }

    let product = JSONHelper.convertJSON(productJSONString)!
    let newProduct = Product(name: product.name, amount: product.amount, selected: !product.selected, price: product.price)
    let newProductJSONString = JSONHelper.convertToJSONString(newProduct)!

    if searchBar.text != "" {
        filteredProducts[indexPath.row] = newProductJSONString
    } else {
        AppDefaults.shared.shoppingList[indexPath.row] = newProductJSONString
    }

    tableView.reloadRows(at: [indexPath], with: .automatic)
    updateTotalPriceLabel()
}

func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
        if searchBar.text != "" {
            filteredProducts.remove(at: indexPath.row)
        } else {
            AppDefaults.shared.shoppingList.remove(at: indexPath.row)
        }

        tableView.deleteRows(at: [indexPath], with: .fade)
        updateTotalPriceLabel()
    }
}

func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
}

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    filterProducts(searchText)
    tableView.reloadData()
}

func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
    searchBar.text = ""
    searchBar.resignFirstResponder()
    tableView.reloadData()
}

private func filterProducts(_ searchText: String) {
    filteredProducts = AppDefaults.shared.shoppingList.filter { productJSONString in
        guard let product = JSONHelper.convertJSON(productJSONString) else { return false }
        return product.name.lowercased().contains(searchText.lowercased())
    }
}

@objc private func addButtonTapped() {
    let alertController = UIAlertController(title: "Добавить товар", message: nil, preferredStyle: .alert)
    alertController.addTextField { (textField) in
        textField.placeholder = "Название товара"
    }
    alertController.addTextField { (textField) in
        textField.placeholder = "Количество"
        textField.keyboardType = .numberPad
    }
    alertController.addTextField { (textField) in
        textField.placeholder = "Цена"
        textField.keyboardType = .decimalPad
    }

    let addAction = UIAlertAction(title: "Добавить", style: .default) { (action) in
        if let nameTextField = alertController.textFields?[0],
           let amountTextField = alertController.textFields?[1],
           let priceTextField = alertController.textFields?[2],
           let name = nameTextField.text,
           let amountString = amountTextField.text,
           let priceString = priceTextField.text,
           let amount = Int(amountString),
           let price = Double(priceString) {
            let product = Product(name: name, amount: amount, selected: false, price: price)
            let productJSONString = JSONHelper.convertToJSONString(product)
            AppDefaults.shared.shoppingList.append(productJSONString!)
            self.tableView.reloadData()
            self.updateTotalPriceLabel()
        }
    }

    let cancelAction = UIAlertAction(title: "Отменить", style: .cancel, handler: nil)

    alertController.addAction(addAction)
    alertController.addAction(cancelAction)

    present(alertController, animated: true, completion: nil)
}

@objc func backButtonTapped() {
    dismiss(animated: true, completion: nil)
}
}
