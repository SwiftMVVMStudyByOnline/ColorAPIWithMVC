//
//  ColorCell.swift
//  ColorMVVM
//
//  Created by Seokho on 2020/03/28.
//

import UIKit


class ColorCell: UITableViewCell {
    
    private(set) weak var previewColor: UIView?
    private(set) weak var titleLabel: UILabel?
    private(set) weak var hexCodeLabel: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let previewColor = UIView()
        previewColor.layer.cornerRadius = 12
        contentView.addSubview(previewColor)
        previewColor.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            previewColor.widthAnchor.constraint(equalTo: previewColor.heightAnchor),
            previewColor.leadingAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leadingAnchor),
            previewColor.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 4),
            previewColor.bottomAnchor.constraint(equalTo: contentView.layoutMarginsGuide.bottomAnchor, constant: -4)
        ])
        self.previewColor = previewColor
        
        /*
         Self-Sizeing Cell 구현시 셀의 높이가 constant면 에러가 발생할 때 해결하는 방법
         -> 우선순위 조정
         */
        let heightAnchor = previewColor.heightAnchor.constraint(equalToConstant: 64)
        heightAnchor.priority = .defaultHigh
        heightAnchor.isActive = true
        
        let titleLabel = UILabel()
        titleLabel.font = .systemFont(ofSize: 16)
        titleLabel.textColor = ColorLists.label
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: previewColor.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: previewColor.trailingAnchor, constant: 12)
        ])
        self.titleLabel = titleLabel

        let hexCodeLabel = UILabel()
        hexCodeLabel.font = .systemFont(ofSize: 16)
         hexCodeLabel.textColor = ColorLists.label
        contentView.addSubview(hexCodeLabel)
        hexCodeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            hexCodeLabel.bottomAnchor.constraint(equalTo: previewColor.bottomAnchor),
            hexCodeLabel.leadingAnchor.constraint(equalTo: previewColor.trailingAnchor, constant: 12)
        ])
        self.hexCodeLabel = hexCodeLabel

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func inputData(_ color: Color) {
        self.previewColor?.backgroundColor = UIColor(hex: color.hex)
        self.titleLabel?.text = color.name
        self.hexCodeLabel?.text = color.hex
    }
    
    
    
}
