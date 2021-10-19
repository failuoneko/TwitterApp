//
//  PagSselectorView.swift
//  TwitterApp
//
//  Created by L on 2021/10/13.
//

import UIKit

protocol PagSelectorViewDelegate: AnyObject {
    func pagSelectorView(_ view: PagSelectorView, didSelect indexPath: IndexPath)
}

class PagSelectorView: UIView {
    
    // MARK: - Properties
    
    weak var delegate: PagSelectorViewDelegate?
    
    lazy var collectionView: UICollectionView = {
        let cv = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        cv.backgroundColor = .white
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(PagSelectorCell.self, forCellWithReuseIdentifier: PagSelectorCell.id)
        
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: true, scrollPosition: .left)
        
        addSubview(collectionView)
        collectionView.snp.makeConstraints{ $0.edges.equalToSuperview() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    // MARK: - Selectors
    
    
    
    // MARK: - Helpers
    
    func configureUI() {
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension PagSelectorView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let count = CGFloat(PagSelectorViewOptions.allCases.count)
        return CGSize(width: frame.width / count, height: frame.height)

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: - UICollectionViewDelegate

extension PagSelectorView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.pagSelectorView(self, didSelect: indexPath)
    }
}

// MARK: - UICollectionViewDataSource

extension PagSelectorView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PagSelectorViewOptions.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PagSelectorCell.id, for: indexPath) as! PagSelectorCell
        
        let option = PagSelectorViewOptions(rawValue: indexPath.row)
        cell.option = option
        
        return cell
    }
}
