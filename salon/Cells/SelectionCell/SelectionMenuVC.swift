//
//  SelectionMenuVC.swift
//  salon
//
//  Created by Mahmoud Elzaiady on 11/01/2023.
//  Copyright © 2023 ALBadr. All rights reserved.
//

import UIKit

class SelectionMenuVC: UIViewController {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var tableView: UITableView!

    var citiesList: [CitiesData] = []
    var citiesFilterList: [CitiesData] = []
    var searching: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTF.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @IBAction func searchBtn_tapped(_ sender: Any) {
        
    }
}

extension SelectionMenuVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searching == true {
            return citiesFilterList.count
        }else{
            return citiesList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SelectionCell", for: indexPath) as? SelectionCell else {
            return UITableViewCell()
        }

        if searching == true {
            cell.configCell(item: citiesFilterList[indexPath.row])
        }else {
            cell.configCell(item: citiesList[indexPath.row])
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var id: Int = 0
        
        if searching == true {
            id = citiesFilterList[indexPath.row].city_id ?? 0
        }else {
            id = citiesList[indexPath.row].city_id ?? 0
        }
        
        print("id", id)
    }
}

extension SelectionMenuVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool{
        let searchText  = textField.text! + string
        
        citiesFilterList = self.citiesList.filter({ (item) -> Bool in
            var sText: NSString = ""
            if LanguageManger.shared.currentLanguage == .en {
                sText = (item.city_name_en ?? "") as NSString
            }else {
                sText = (item.city_name ?? "") as NSString
            }
            
            return (sText.range(of: searchText, options: NSString.CompareOptions.caseInsensitive).location) != NSNotFound
        })
        
        if citiesFilterList.count == 0 {
            searching = false
        }else{
            searching = true
        }
        
        tableView.reloadData()
        
        return true
    }
    
}
