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
        tableView.backgroundColor = K.shared.mainColorBackground
        tableView.register(UserPrefCell.self, forCellReuseIdentifier: CellID.CellID)
        return tableView
    }()
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.setTitle("Déconnexion", for: .normal)
        button.setUpButton()
        return button
    }()
    private lazy var dismissButton: UIButton = {
        let button = UIButton()
        button.setTitle("Enregistrer", for: .normal)
        button.setUpButton()
        return button
    }()
    private lazy var deleteAccountbutton: UIButton = {
        let button = UIButton()
        button.setTitle("Supprimer le compte", for: .normal)
        if traitCollection.userInterfaceStyle == .light {
            button.setTitleColor(.black, for: .normal)
        } else {
            button.setTitleColor(.lightGray, for: .normal)
        }
        
        return button
    }()
    
    private var logInManager: LogInManager?
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

        self.view.isOpaque = true
        self.view.backgroundColor = K.shared.mainColorBackground
        
        dataBaseManager.delegate = self
        dataBaseManager.loadDataForUser()
        
        addTitleView()
        addTableView()
        addDismissButton()
        addLogOutButton()
        addDeleteAccountButton()
        
        tableView.reloadData()
        
    }
    private func addDeleteAccountButton() {
        
        self.view.addSubview(deleteAccountbutton)
        
        //view
        let fromView = deleteAccountbutton
        //relative to
        let toView = self.logOutButton
            
        fromView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([fromView.leadingAnchor.constraint(equalTo: toView.leadingAnchor, constant: 0),
                                     fromView.trailingAnchor.constraint(equalTo: toView.trailingAnchor, constant: 0),
                                     fromView.topAnchor.constraint(equalTo: toView.bottomAnchor, constant: 0),
                                     fromView.heightAnchor.constraint(equalTo: toView.heightAnchor,constant: 30)])
        
        deleteAccountbutton.addTarget(self, action: #selector(deleteAccountPressed), for: .touchUpInside)
        
    }
    @IBAction private func deleteAccountPressed() {
        
        let alert = UIAlertController(title: "Supprimer le compte", message: "Etes-vous certain de vouloir supprimer votre compte?", preferredStyle: .alert)
        
        let deleteAction = UIAlertAction(title: "Supprimer", style: .destructive) { (action) in
            let logInManager = LogInManager()
            logInManager.delegate = self
            logInManager.deleteAccount()
            
            defaults.set(false, forKey: K.shared.loggedIn)
            
            self.dismiss(animated: true) {
                self.delegate?.didLogOut()
            }
        }
        let cancelAction = UIAlertAction(title: "Annuler", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.present(alert, animated: true, completion: nil)
        
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
                                     fromView.bottomAnchor.constraint(equalTo: toView.bottomAnchor,constant: -220)])
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
        label.text = "Qu'aimeriez vous lire?"
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
        return K.shared.categoriesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let categories = K.shared.categoriesArray.sorted { $0 < $1 }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CellID.CellID, for: indexPath) as! UserPrefCell
        
        for pref in preferences {
            
            if pref == categories[indexPath.row] {
                print("match : \(pref) & \(categories[indexPath.row]) & indexpath \(indexPath.row)")
                cell.cellState = .pressed
                cell.markFill.alpha = 1.0
                break
            }else{
                print("No match : \(pref) & \(categories[indexPath.row]) & indexpath \(indexPath.row)")
                cell.cellState = .free
                cell.markFill.alpha = 0.0
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
extension UserSettingsVC: LogInManagerDelegate {
    func didGetAnError(error: Error) {
        print(error)
    }
    
    func didDeleteAccount() {
        
    }
}
