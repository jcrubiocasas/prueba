//
//  DetailHeroViewController.swift
//  KCDragonBall
//
//  Created by Juan Carlos Rubio Casas on 24/9/24.
//

import UIKit


final class DetailHeroViewController: UIViewController {
    // Outputs
    @IBOutlet weak var heroImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var transformationsButton: UIButton!
    
    // Variables
    private let hero: Hero
    private let transformations: [Transformation]
    
    init(hero: Hero, transformations: [Transformation]) {
        self.hero = hero
        self.transformations = transformations
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if transformations.count == 0 {
            transformationsButton.isHidden = true
        }
        configureView()
    }
    
    @IBAction func didTapTransformationButton(_ sender: Any) {
        DispatchQueue.main.async {
            let transformationHero = TransformationCollectionViewController(
                hero: self.hero,
                transformations: self.transformations)
            self.navigationController?.pushViewController(transformationHero, animated: true)
        }
    }
    
}

private extension DetailHeroViewController {
    func configureView() {
        nameLabel.text = hero.name
        descriptionLabel.text = hero.description
        guard let imageURL = URL(string: hero.photo) else {
            return
        }
        heroImage.setImage(url: imageURL)
    }
}
