//
//  ListViewController.swift
//  RickAndMorty
//
//  Created by Alpay Calalli on 20.10.25.
//

import UIKit

class CharactersVC: UIViewController {
   
   private enum Section: Hashable {
      case main
   }
   
   private var dataSource: UICollectionViewDiffableDataSource<Section, Character>?
   
   var collectionView: UICollectionView!
   var filtersStackView = UIStackView()
   
   let networkManager = NetworkManager.shared
   var characters: [Character] = []

    override func viewDidLoad() {
        super.viewDidLoad()
       configureCollectionView()
       configureDataSource()
       navigationItem.title = "Characters"
       Task {
          await exampleRequest()
       }
    }

   
   private func configureCollectionView() {
      collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UIHelper.createThreeColumnFlowLayout(in: view))
              view.addSubview(collectionView)

              collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseId)
              collectionView.delegate = self
   }
   
   private func configureDataSource() {
       dataSource = UICollectionViewDiffableDataSource<Section, Character>(collectionView: collectionView, cellProvider: { (collectionView, indexPath, character) -> UICollectionViewCell? in
           let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CharacterCell.reuseId, for: indexPath) as! CharacterCell
           cell.set(character: character)
           return cell
       })
   }
   
   private func updateData(_ data: [Character]) {
       var snapshot = NSDiffableDataSourceSnapshot<Section, Character>()
       snapshot.appendSections([.main])
       snapshot.appendItems(data)
       
       guard let dataSource else { return }
       DispatchQueue.main.async {
           dataSource.apply(snapshot, animatingDifferences: true)
       }
   }

   
   private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {

       return UICollectionViewCompositionalLayout { section, env -> NSCollectionLayoutSection? in
           switch section {
           case 0: return self.createFirstSection()
//           case 1: return self.createSecondSection()
           default: return self.createFirstSection()
           }
       }
   }
   
   private func createFirstSection() -> NSCollectionLayoutSection {
           let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1.0))
           
           let item = NSCollectionLayoutItem(layoutSize: itemSize)
           item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 60, trailing: 5)
           
           let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.50), heightDimension: .fractionalHeight(0.55))
                   
           let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
           group.contentInsets = .init(top: 0, leading: 15, bottom: 0, trailing: 2)
           
           let section = NSCollectionLayoutSection(group: group)
           section.orthogonalScrollingBehavior = .paging
           
           return section
       }
   
   func exampleRequest() async {
      let urlString = "https://rickandmortyapi.com/api/character"
      guard let url = URL(string: urlString) else { return }
      
      let urlRequest = URLRequest(url: url)

      do {
         let response = try await networkManager.fetch(CharacterResponse.self, url: urlRequest)
         let characters = response.results
         self.characters = characters
         DispatchQueue.main.async {
            self.updateData(characters)
         }
      } catch {
         print("Error", error.localizedDescription)
      }
      
   }
}

extension CharactersVC: UICollectionViewDelegate {
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      let character = characters[indexPath.row]
      let destinationVC = CharacterDetailVC(character: character)
      navigationController?.pushViewController(destinationVC, animated: true)
   }
}

//private func configureCollectionView() {
//    collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createCompositionalLayout() )
//    view.addSubview(collectionView)
//   view.addSubview(filtersStackView)
//   
//    collectionView.delegate = self
//    
//    collectionView.register(CharacterCell.self, forCellWithReuseIdentifier: CharacterCell.reuseId)
//            
//    collectionView.translatesAutoresizingMaskIntoConstraints = false
//   filtersStackView.translatesAutoresizingMaskIntoConstraints = false
//    NSLayoutConstraint.activate([
//      filtersStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
//        filtersStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//      filtersStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//      filtersStackView.heightAnchor.constraint(equalToConstant: 40),
//        
//        collectionView.topAnchor.constraint(equalTo: filtersStackView.bottomAnchor, constant: 15),
//        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
//        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
//        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
//    ])
//}
