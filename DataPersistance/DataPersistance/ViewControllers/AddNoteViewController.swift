//
//  AddNoteViewController.swift
//  DataPersistance
//
//  Created by Levan Loladze on 05.11.23.
//

import UIKit

// MARK: - protocol
protocol AddNewNoteDelegate: AnyObject {
    func addNewItem(with note: Note)
}


class AddNoteViewController: UIViewController {

    // MARK: - Properties
    
    private var titleField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        return textField
    }()
    
    private var noteField: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        return textField
    }()
    
    
    weak var delegate: AddNewNoteDelegate?
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        titleField.becomeFirstResponder()
        
        setupUI()
    }
    
   
    
    @objc func didClickSave() {
        delegate?.addNewItem(with: .init(title: titleField.text ?? String(), note: noteField.text))
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        setupFields()
        setupNoteField()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .done, target: self, action: #selector(didClickSave))
    }
    
    private func setupFields() {
        view.addSubview(titleField)
        
        NSLayoutConstraint.activate([
            titleField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
    
    private func setupNoteField() {
        view.addSubview(noteField)
        
        NSLayoutConstraint.activate([
            noteField.topAnchor.constraint(equalTo: titleField.bottomAnchor, constant: 40),
            noteField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            noteField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            noteField.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }

}
