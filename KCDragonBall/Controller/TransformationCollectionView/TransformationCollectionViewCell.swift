//
//  TransformationCollectionViewCell.swift
//  KCDragonBall
//
//  Created by Juan Carlos Rubio Casas on 25/9/24.
//

import UIKit

class TransformationCollectionViewCell: UICollectionViewCell {
    // Conexiones
    @IBOutlet weak var transformationImageView: UIImageView!
    @IBOutlet weak var transformationNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: Configuration
    func configure(with transformation: Transformation) {
        // RawValue lo utilizamos para obtener
        // la representacion del String
        transformationNameLabel.text = transformation.name
        guard let url = URL(string: transformation.photo) else {
            print("URL no válida")
            return
        }
        transformationImageView.setImage(url: url)
    }

}
