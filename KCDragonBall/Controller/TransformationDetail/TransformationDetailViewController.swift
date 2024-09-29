//
//  TransformationDetailViewController.swift
//  KCDragonBall
//
//  Created by Juan Carlos Rubio Casas on 25/9/24.
//

import UIKit

class TransformationDetailViewController: UIViewController {
    @IBOutlet weak var transformationImage: UIImageView!
    @IBOutlet weak var transformationNameLabel: UILabel!
    @IBOutlet weak var transformationDescriptionLabel: UILabel!
    
    
    private let transformation: Transformation
    
    init(transformation: Transformation) {
        self.transformation = transformation
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    
    
}

private extension TransformationDetailViewController {
    func configureView() {
        transformationNameLabel.text = transformation.name
        transformationDescriptionLabel.text = transformation.description
        
        guard let imageURL = URL(string: transformation.photo) else {
            return
        }
        transformationImage.setImage(url: imageURL)
    }

}
