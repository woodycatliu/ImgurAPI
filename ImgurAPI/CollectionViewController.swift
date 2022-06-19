//
//  CollectionViewController.swift
//  ImgurAPI
//
//  Created by Woody on 2022/6/20.
//

import UIKit
import Combine

class CollectionViewController: UICollectionViewController {
    private var bag = Set<AnyCancellable>()

    lazy var viewModel: ViewModel = {
        return ViewModel(UseCase())
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(Cell.self, forCellWithReuseIdentifier: Cell.description())
        self.collectionView!.register(BigCell.self, forCellWithReuseIdentifier: BigCell.description())

        viewModel.$images.sink(receiveValue: {_ in
            self.collectionView.reloadData()
        }).store(in: &bag)
        viewModel.fetchFirstPage()
        
        viewModel.$style.sink(receiveValue: { [weak self] in
            self?.collectionView.collectionViewLayout = makeCollectionViewFlowlayout($0)
            self?.collectionView.reloadData()
        }).store(in: &bag)
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8 ) {
            self.viewModel.togleStyle()
        }
    }

   
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numbersOfSection
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  viewModel.style == .list ? Cell.description() : BigCell.description(), for: indexPath) as! Cell
        let data = viewModel.dataModelFoRowAt(indexPath)
        cell.setImage(data)
        return cell
    }

}

private func makeCollectionViewFlowlayout(_ style: CollectionViewStyle)-> UICollectionViewLayout {
    let collectionViewLayout = UICollectionViewFlowLayout()
    let width = UIScreen.main.bounds.width
    let itemSize = style == .list ? CGSize(width: (width - 12) / 3, height: (width - 12) / 3) : CGSize(width: width, height: width - 80)
    collectionViewLayout.minimumInteritemSpacing = style == .list ? 1 : 0
    collectionViewLayout.minimumLineSpacing = style == .list ? 3 : 20
    collectionViewLayout.itemSize = itemSize
    
    return collectionViewLayout
}
