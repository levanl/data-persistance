//
//  NoteCellTableViewCell.swift
//  DataPersistance
//
//  Created by Levan Loladze on 05.11.23.
//

import UIKit

class NoteCellTableViewCell: UITableViewCell {

    let noteStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Helvetica-Bold", size: 18)
        label.textColor = .black
        return label
    }()
    
    let note: UITextField = {
        let textField = UITextField()
        return textField
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupNoteStackView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupNoteStackView() {
        addSubview(noteStackView)
        
        noteStackView.addArrangedSubview(titleLabel)
        noteStackView.addArrangedSubview(note)
        
        NSLayoutConstraint.activate([
            noteStackView.topAnchor.constraint(equalTo: self.topAnchor),
            noteStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            noteStackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            noteStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            
        ])
    }
    
    func configure(with model: Note) {
        titleLabel.text = model.title
        note.text = model.note
    }
    

}
