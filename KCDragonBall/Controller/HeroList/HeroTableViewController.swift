//
//  HeroTableViewController.swift
//  KCDragonBall
//
//  Created by Juan Carlos Rubio Casas on 24/9/24.
//

import UIKit

final class HeroTableViewController: UITableViewController {
    // MARK: - Table View DataSource
    typealias DataSource = UITableViewDiffableDataSource<Int, Hero>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, Hero>
    
    // MARK: - Model
    // Creamos array de hero y lo inicializamos a vacio
    private var heroes: [Hero] = []
    private var trasformations: [Transformation] = []
    //private var transformations = [String: House]()
    // Al declarar una variable como nula, el compilador
    // infiere que su valor inicial es `nil`
    private var dataSource: DataSource?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Lista de heroes"
        
        
        // 1. Registrar la celda custom
        // Registramos la celda que hemos creado de forma personalizada
        tableView.register(
            // Instanciamos el archivo .xib a traves de su numbre
            UINib(nibName: HeroTableViewCell.identifier, bundle: nil),
            // Cada vez que TableView se encuentre este identificador
            // tiene que instanciar el .xib que le especificamos
            forCellReuseIdentifier: HeroTableViewCell.identifier
        )
        
        // 2. Configurar el data source
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, hero in
            // Obtenemos una celda reusable y la casteamos a
            // el tipo de celda que queremos representar
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: HeroTableViewCell.identifier,
                for: indexPath
            ) as? HeroTableViewCell else {
                // Si no podemos desempaquetarla
                // retornamos una celda en blanco
                return UITableViewCell()
            }
            //let foundHouse = self?.favouriteHouses[house.rawValue]
            //let isFavourite = foundHouse != nil
            //cell.configure(with: house, isFavourite: isFavourite)
            
            // Configuramos la celda con los datos del heroe
            cell.configure(with: hero)
            return cell
        }
        
        // 3. Añadir el data source al table view
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        // 4. Crear un snapshot con los objetos a representar
        var snapshot = Snapshot()
        
        NetworkModel.shared.getHeroes { result in
            switch result {
                case let .success(heroes):
                    DispatchQueue.main.async {
                        print("Heroes: \(heroes)")
                        self.heroes = heroes
                        // Añadimos los objetos a rerpesentar
                        snapshot.appendSections([0])
                        snapshot.appendItems(heroes)
                        // Aplicamos el SnapShot
                        self.dataSource?.apply(snapshot)
                        
                    }
                case let .failure(error):
                    print("Error: \(error)")
                    DispatchQueue.main.async {
                        // En caso de fallo, mostramos un mensaje de error
                        let alert = UIAlertController(title: "Error", message: "No se pudo obtener la lista de héroes", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
            }
        }
        /*
        NetworkModel.shared.getAllCharacters { result in
            switch result {
                case let .success(characters):
                    print(characters)
                case let .failure(error):
                    print(error)
            }
        }
         */
        
        
    }
    
}

// MARK: - Ajustes sobrel el TableView
extension HeroTableViewController {
    override func tableView(_ tableView: UITableView,heightForRowAt indexPath: IndexPath) -> CGFloat {100}
    
    
    // MARK: - Captura del metodo Delegate para detectar pulsaciones sobre las celdas
    override func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        let hero = heroes[indexPath.row]
        //let foundHouse = favouriteHouses[house.rawValue]
        //let isFavourite = foundHouse != nil
        //let detailViewController = HouseDetailViewController(house: house, isFavourite: isFavourite)
        //detailViewController.favouriteHouseDelegate = self
        
        NetworkModel.shared.getTransformations(for: hero) { result in
            switch result {
                case let .success(trasformations):
                    DispatchQueue.main.async {
                        print("Transformations: \(trasformations)")
                        self.trasformations = trasformations
                        // Ordenar el array transformations según el número al inicio de name
                        self.trasformations.sort { extractLeadingNumber(from: $0.name) < extractLeadingNumber(from: $1.name) }
                        
                        // Instanciamos HeroTableViewController y navegamos hacia él
                        DispatchQueue.main.async {
                            let detailHero = DetailHeroViewController(
                                hero: hero,
                                transformations: self.trasformations)//trasformations)
                            self.navigationController?.pushViewController(detailHero, animated: true)
                        }
                        
                    }
                case let .failure(error):
                    print("Error: \(error)")
                    DispatchQueue.main.async {
                        // En caso de fallo, mostramos un mensaje de error
                        let alert = UIAlertController(title: "Error", message: "No se pudo obtener la lista de transformaciones", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .default))
                        self.present(alert, animated: true)
                    }
            }
        }
        
        print("Click en celda \(hero.name)")
        //navigationController?.show(detailViewController, sender: self)
    }
}

