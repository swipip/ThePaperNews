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
        
        self.view.addSubview(tableView)
        
        //view
        let fromView = tableView
        //relative to
        let toView = self.view!
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.topAnchor, constant: 0),
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: -150)])
        
        self.view.addSubview(logOutButton)
        
        //view
        let button = logOutButton
            
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([button.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 20),
                                     button.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: -20),
                                     button.heightAnchor.constraint(equalToConstant: 50),
                                     button.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: -50)])
        
        self.logOutButton.addTarget(self, action: #selector(logOutPressed(_:)), for: .touchUpInside)
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
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = K.shared.mainColorTheme
        headerView.frame.size = CGSize(width: self.view.frame.size.width, height: 60)
        
        let sectionLabel = UILabel()
        sectionLabel.font = UIFont.systemFont(ofSize: K.shared.fontSizeSubTitle)
        sectionLabel.textColor = .white
        sectionLabel.font = UIFont.systemFont(ofSize: K.shared.fontSizeSubTitle)
        sectionLabel.textAlignment = .center
        sectionLabel.text = "News Preferences"
        sectionLabel.sizeToFit()
        headerView.addSubview(sectionLabel)
        
        //view
        let fromView = sectionLabel
        //relative to
        let toView = headerView
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 10),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.centerYAnchor.constraint(equalTo: toView.centerYAnchor, constant: 0),
                                     fromView.heightAnchor.constraint(equalToConstant: 60)])
        
        return headerView
        
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
