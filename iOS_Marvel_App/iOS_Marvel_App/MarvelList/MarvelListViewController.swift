//
//  MarvelListViewController.swift
//  iOS_Marvel_App
//
//  Created by Ankit Sharma on 28/10/23.
//

import UIKit

protocol MediaListViewModelProtocol {
    var marvelCharacterList: [MarvelCharacterUIModel] { get }
    var textFieldActionCompletion: ((String) -> Void)? { get set }
    var baseUrl: URL { get }
    func fetchMediaList()
    func observeSearchBarTypingEvent()
}

class MarvelListViewController: UIViewController {
    
    @IBOutlet weak var marvelTableView: UITableView!
    
    @IBOutlet weak var searchTextField: UITextField!
    
    var viewModel: MediaListViewModelProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel?.observeSearchBarTypingEvent()
        setupMediaTableView()
        setUpSearchTextField()
        viewModel?.fetchMediaList()
    }
    
    private func setUpSearchTextField() {
        searchTextField.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
    }
    
    private func setupMediaTableView() {
        marvelTableView.delegate = self
        marvelTableView.dataSource = self
        let nib = UINib(nibName: "MarvelListTableViewCell", bundle: .main)
        marvelTableView.register(nib, forCellReuseIdentifier: "MarvelListTableViewCell")
    }
    
    @objc func textFieldEditingChanged(sender: UITextField) {
        if sender.text?.isEmpty ?? true {
            searchTextField.becomeFirstResponder()
        } else {
            sender.rightView?.isHidden = false
        }
        viewModel?.textFieldActionCompletion?(sender.text ?? "")
    }
}

extension MarvelListViewController: MarvelListDiplayLogic {
    
    func refreshUI() {
        DispatchQueue.main.async {
            self.marvelTableView.isHidden = false
            self.marvelTableView.reloadData()
        }
    }
    
    func showError(error: ErrorModel) {
        // Implement Error Handling
    }
}

extension MarvelListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.marvelCharacterList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MarvelListTableViewCell", for: indexPath) as? MarvelListTableViewCell
        let data = viewModel?.marvelCharacterList[indexPath.row]
        cell?.configureData(data: data)
        return cell ?? MarvelListTableViewCell()
    }
}

extension MarvelListViewController: UITextFieldDelegate {
    
}

