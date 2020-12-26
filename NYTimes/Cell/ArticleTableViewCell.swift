//
//  ArticleTableViewCell.swift
//  NYTimes
//
//  Created by Manpreet on 25/12/2020.
//

import UIKit

import Kingfisher

class ArticleTableViewCell: UITableViewCell {
	
	@IBOutlet fileprivate var imageV: UIImageView!
	
	@IBOutlet fileprivate var collectionL: [UILabel] = []
	
    override func awakeFromNib() {
		
        super.awakeFromNib()
    }
	
    override func setSelected(_ selected: Bool, animated: Bool) {
        
		super.setSelected(selected, animated: animated)
    }
	
	func configure(_ obj: Parser.Viewed.Article) {
		
		collectionL[0].text = obj.title
		
		collectionL[1].text = obj.byline
		
		collectionL[2].text = obj.publishedDate
		
		if obj.media.count > 0 {
			
			if obj.media[0].media.count > 0 {
				
				imageV.kf.setImage(with: URL(string: obj.media[0].media[0].url))
				
			} else {
				
				imageV.image = nil
			}
			
		} else {
			
			imageV.image = nil
		}
	}

}
