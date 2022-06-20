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
        collectionView!.register(Cell.self, forCellWithReuseIdentifier: Cell.description())
        collectionView!.register(BigCell.self, forCellWithReuseIdentifier: BigCell.description())
        collectionView.register(RefreshFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier:  RefreshFooterView.description())
        configureNavigationBar()
        Binding()
        viewModel.fetchFirstPage()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.isNavigationBarHidden = false
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

    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: RefreshFooterView.description(), for: indexPath) as! RefreshFooterView
        
        return footer
    }

}

private func makeCollectionViewFlowlayout(_ style: CollectionViewStyle, isShowFooter: Bool = true)-> UICollectionViewLayout {
    let collectionViewLayout = UICollectionViewFlowLayout()
    let width = UIScreen.main.bounds.width
    let itemSize = style == .list ? CGSize(width: (width - 12) / 3, height: (width - 12) / 3) : CGSize(width: width, height: width - 80)
    collectionViewLayout.minimumInteritemSpacing = style == .list ? 1 : 0
    collectionViewLayout.minimumLineSpacing = style == .list ? 3 : 20
    collectionViewLayout.itemSize = itemSize
    
    if isShowFooter {
        collectionViewLayout.footerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 70)
    }
    else {
        collectionViewLayout.footerReferenceSize = .zero
    }
    
    return collectionViewLayout
}

// MARK: Binding
extension CollectionViewController {
    fileprivate func Binding() {
        // images 更新刷 cv
        viewModel.$images
            .receive(on: RunLoop.main)
            .sink(receiveValue: {_ in
            self.collectionView.reloadData()
        }).store(in: &bag)

        // ffetchStatus 改為 finished 重整 cv 隱藏 footer
        viewModel.$fetchStatus
            .removeDuplicates()
            .filter {
                if case FetchStatus.finished = $0 { return true }
                return false
            }
            .sink(receiveValue: { [weak self] a in
                self?.collectionView.reloadData()
        }).store(in: &bag)

        // style 更改刷新頁面
        viewModel.$style.sink(receiveValue: { [weak self] _ in
            self?.collectionView.reloadData()
        }).store(in: &bag)
        
        // 觀察 scollview contentoffset 確認是否要讀取更多 img
        collectionView.publisher(for: \.contentOffset)
            .sink(receiveValue: { [weak self] in self?.loadMoreIfNeed($0)} )
            .store(in: &bag)
        
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        switch viewModel.fetchStatus {
        case .success, .fetchIng:
            return CGSize(width: collectionView.bounds.width, height: 70)
        default:
            return .zero


        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return viewModel.style == .list ? 1 : 0
       }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
           return viewModel.style == .list ? 3 : 20
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let style = viewModel.style
        let width = UIScreen.main.bounds.width
        let itemSize = style == .list ? CGSize(width: (width - 12) / 3, height: (width - 12) / 3) : CGSize(width: width, height: width - 80)
        return itemSize
    }
}

// MARK: logic
extension CollectionViewController {
    
    private func configureNavigationBar() {
        let itemButton = UIBarButtonItem(title: "ChangeStyle", style: .plain, target: self, action: #selector(rightBarButtonAction))
        navigationItem.rightBarButtonItem = itemButton
        navigationController?.navigationItem.rightBarButtonItem = itemButton
    }
    private func loadMoreIfNeed(_ point: CGPoint) {
        let offsetHeight = point.y
        if offsetHeight > collectionView.contentSize.height - collectionView.bounds.height {
            self.viewModel.nextPage()
        }
    }
    
    @objc private func rightBarButtonAction() {
        viewModel.togleStyle()
    }
}
