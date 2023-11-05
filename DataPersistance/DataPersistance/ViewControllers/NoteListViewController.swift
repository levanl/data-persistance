//
//  NoteListViewController.swift
//  DataPersistance
//
//  Created by Levan Loladze on 05.11.23.
//

import UIKit

class NoteListViewController: UIViewController {
    
    // MARK: - Properties
    
    let notesTableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var notes: [Note] = [
        Note(title: "ხაჭაპური", note: "ყველი, ცომი")
    ]
    
    // MARK: - ViewLifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    
    // MARK: - Setup UI
    
    func setupUI() {
        self.navigationItem.title = "Notes"
        setupTableView()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(didTapButton))
    }
    
    func setupTableView() {
        view.addSubview(notesTableView)
        
        NSLayoutConstraint.activate([
            notesTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            notesTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            notesTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            notesTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30)
        ])
        
        notesTableView.delegate = self
        notesTableView.dataSource = self
        notesTableView.register(NoteCellTableViewCell.self, forCellReuseIdentifier: "noteCell")
        
    }
    
    
    // MARK: Button Action
    
    @objc private func didTapButton() {
        let addNoteVC = AddNoteViewController()
        addNoteVC.delegate = self
        self.navigationController?.pushViewController(addNoteVC, animated: true)
    }
    
    func deleteButtonTapped(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Confirm Deletion", message: "Are you sure you want to delete this note?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] (_) in
            guard let self = self else { return }
            self.notes.remove(at: indexPath.row)
            self.notesTableView.deleteRows(at: [indexPath], with: .automatic)
        }))
        
        present(alert, animated: true, completion: nil)
    }
    
}


// MARK: - TableVIew DataSource & Delegate

extension NoteListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "noteCell") as? NoteCellTableViewCell {
            cell.configure(with: note)
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let noteDetailViewController =  NoteDetailsViewController()
        noteDetailViewController.configure(index: indexPath.row, with: notes[indexPath.row])
        noteDetailViewController.delegate = self
        navigationController?.pushViewController(noteDetailViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteButtonTapped(at: indexPath)
        }
    }
    
    
}

// MARK: - AddNewNoteDelegate

extension NoteListViewController: AddNewNoteDelegate {
    func addNewItem(with note: Note) {
        notes.append(note)
        notesTableView.reloadData()
    }
    
}

// MARK: - EditNoteDelegate

extension NoteListViewController: EditNoteDelegate {
    func editNote(index: Int, with note: Note) {
        notes[index].note = note.note
        notes[index].title = note.title
        notesTableView.reloadData()
    }
    
}
