//
//  CoinLayout.swift
//  WeatherBB
//
//  Created by Mustafa Saeed on 8/4/17.
//  Copyright © 2017 Mustafa Saeed. All rights reserved.
//

import UIKit

class CoinLayout: UICollectionViewFlowLayout {
    
    var offsetX = CGFloat(0)
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        
        // Make the layout center cells and paging per cell
        if let collectionView = collectionView {
            
            let bounds = collectionView.bounds
            let width = collectionView.width
            let proposedContentOffsetCenterX = proposedContentOffset.x + (width / 2)
            
            if let attributesForVisibleCells = layoutAttributesForElements(in: bounds) as [UICollectionViewLayoutAttributes]? {
                
                var candidateAttributes: UICollectionViewLayoutAttributes?
                for attributes in attributesForVisibleCells {
                    
                    if let candAttrs = candidateAttributes {
                        
                        let a = attributes.center.x - proposedContentOffsetCenterX
                        let b = candAttrs.center.x - proposedContentOffsetCenterX
                        
                        if fabsf(Float(a)) < fabsf(Float(b)) {
                            candidateAttributes = attributes
                        }
                        
                    } else {
                        candidateAttributes = attributes
                        continue
                    }
                }
                
                if let candidateAttributes = candidateAttributes {
                    return CGPoint(x : candidateAttributes.center.x - (width / 2) - offsetX, y : proposedContentOffset.y)
                } else {
                    return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
                }
                
            }
        }
        
        // Fallback
        return super.targetContentOffset(forProposedContentOffset: proposedContentOffset, withScrollingVelocity: velocity)
    }
    
}

