//
//  UserSettingsVC.swift
//  ThePaper
//
//  Created by Gautier Billard on 01/04/2020.
//  Copyright © 2020 Gautier Billard. All rights reserved.
//

import UIKit
import Firebase
protocol UserSettingsDelegate {
    func didLogOut()
}
class UserSettingsVC: UIViewController {

    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UserPrefCell.self, forCellReuseIdentifier: CellID.CellID)
        return tableView
    }()
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Log Out", for: .normal)
        button.setUpButton()
        return button
    }()
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setUpButton()
        return button
    }()
    
    private var dataBaseManager = DataBaseManager()
    private var preferences = [String]()
    
    var delegate: UserSettingsDelegate?
    
    struct CellID {
        static let CellID = "CellID"
    }
    override func viewWillDisappear(_ animated: Bool) {
        
        let name = Notification.Name(rawValue: K.shared.userSettingDidChangeNotificationName)
        
        NotificationCenter.default.post(name: name, object: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        dataBaseManager.delegate = self
        dataBaseManager.loadDataForUser()
        
        self.view.backgroundColor = K.shared.mainColorBackground
        
        addTitleView()
        addTableView()
        addDismissButton()
        addLogOutButton()
        
    }
    private func addTableView() {
        self.view.addSubview(tableView)
        
        //view
        let fromView = tableView
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 60),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: -150)])
    }
    fileprivate func addLogOutButton() {
        self.view.addSubview(logOutButton)
        
        //view
        let button = logOutButton
        let toView = self.dismissButton
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([button.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     button.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     button.heightAnchor.constraint(equalToConstant: 50),
                                     button.topAnchor.constraint(equalTo: toView.bottomAnchor,constant: 10)])
        
        self.logOutButton.addTarget(self, action: #selector(logOutPressed(_:)), for: .touchUpInside)
        
        logOutButton.backgroundColor = .white
        logOutButton.setTitleColor(.black, for: .normal)
        
        
    }
    private func addDismissButton() {
        
        self.view.addSubview(dismissButton)
        
        //view
        let fromView = dismissButton
        //relative to
        let toView = self.tableView
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 20),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -20),
                                     fromView.topAnchor.constraint(equalTo: toView.bottomAnchor, constant: 10),
                                     fromView.heightAnchor.constraint(equalToConstant: 50)])
        
        self.dismissButton.addTarget(self, action: #selector(dismissButtonPressed(_:)), for: .touchUpInside)
    }
    @IBAction private func dismissButtonPressed(_ sender: UIButton!){
        self.dismiss(animated: true, completion: nil)
    }
    private func addTitleView() {
        
        let view = UIView()
        view.backgroundColor = K.shared.mainColorTheme
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 60)
        
        self.view.addSubview(view)
        
        let label = UILabel()
        label.text = "What do you like to read?"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: K.shared.fontSizeTitle)
        
        self.view.addSubview(label)
        
        //view
        let fromView = label
        //relative to
        let toView = view
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 30),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -10),
                                     fromView.centerYAnchor.constraint(equalTo: toView.centerYAnchor, constant: 0)])
        
    }
    @IBAction func logOutPressed(_ sender: UIButton!) {
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
            defaults.set(false, forKey: K.shared.loggedIn)
            delegate?.didLogOut()
        }catch{
            print("\(#function) problem when logging out")
        }
    }

}
extension UserSettingsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categories = K.shared.categoriesArray.sorted { $0 < $1 }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.CellID, for: indexPath) as! UserPrefCell
        
        for pref in preferences {
            if pref == categories[indexPath.row] {
                cell.cellState = .pressed
                cell.markFill.alpha = 1.0
            }else{
                cell.cellState = .free
            }
        }
        
        cell.selectionStyle = .none
        cell.label.text = categories[indexPath.row]
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! UserPrefCell
        
        switch cell.cellState {
        case .pressed:
            cell.cellState = .free
            cell.markFill.alpha = 0.0
            
            let preference = cell.label.text!

            dataBaseManager.erasePreference(preference: preference)
            
            cell.markFill.alpha = 0.0
        case .free:
            cell.cellState = .pressed
            cell.markFill.alpha = 1.0
            
            let preference = cell.label.text!
            
            dataBaseManager.savePreferences([preference])
            
            cell.markFill.alpha = 1.0
        }
    }
    
}
extension UserSettingsVC: DataBaseManagerDelegate {
    func didFetchData(preferences: [String]) {
        
        self.preferences = preferences
        self.tableView.reloadData()
        
    }

}
