//
//  NoteDetailsViewController.swift
//  DataPersistance
//
//  Created by Levan Loladze on 05.11.23.
//

import UIKit

// MARK: Protocol

protocol EditNoteDelegate: AnyObject {
    func editNote(index: Int, with note: Note)
}

class NoteDetailsViewController: UIViewController {
    
    // MARK: Properties
    
    private var titleFieldEditable: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.heightAnchor.constraint(equalToConstant: 52).isActive = true
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        return textField
    }()
    
    private var noteFieldEditable: UITextView = {
        let textField = UITextView()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        return textField
    }()
    
    var indexOfNote: Int = 0
    
    // MARK: ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    weak var delegate: EditNoteDelegate?
    
    
    @objc func didClickSave() {
        delegate?.editNote(index: indexOfNote, with: .init(title: titleFieldEditable.text ?? String(), note: noteFieldEditable.text))
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: Setup UI
    
    private func setupUI() {
        setupFieldsEditable()
        setupNoteFieldEditable()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .done, target: self, action: #selector(didClickSave))
    }
    
    private func setupFieldsEditable() {
        view.addSubview(titleFieldEditable)
        
        NSLayoutConstraint.activate([
            titleFieldEditable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            titleFieldEditable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleFieldEditable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30)
        ])
    }
    
    private func setupNoteFieldEditable() {
        view.addSubview(noteFieldEditable)
        
        NSLayoutConstraint.activate([
            noteFieldEditable.topAnchor.constraint(equalTo: titleFieldEditable.bottomAnchor, constant: 40),
            noteFieldEditable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            noteFieldEditable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            noteFieldEditable.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)
        ])
    }
    
    // MARK: Configuration Method
    
    func configure(index: Int, with model: Note) {
        noteFieldEditable.text = model.note
        titleFieldEditable.text = model.title
        indexOfNote = index
    }
    
}
