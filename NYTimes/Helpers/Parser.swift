//
//  Parser.swift
//  NYTimes
//
//  Created by Manpreet on 25/12/2020.
//

import Foundation

class Parser {
	
	struct Fault : Codable {
		
		struct FaultSub : Codable {
			
			let faultstring : String
		}
		
		let fault : FaultSub
	}
	
	struct Viewed : Codable {
		
		struct Article : Codable {
			
			struct Media : Codable {
				
				struct MediaMetadata : Codable {
					
					let format : String
					let height : Int
					let url    : String
					let width  : Int
				}
				
				let approved  : Int?
				let caption   : String
				let copyright : String
				let media     : [MediaMetadata]
				let subtype   : String
				let type      : String
				
				enum CodingKeys : String, CodingKey {
					
					case approved = "approved_for_syndication"
					case caption
					case copyright
					case media    = "media-metadata"
					case subtype
					case type
				}
			}
			
			let abstract      : String
			let adxKeywords   : String
			let assetId       : Int
			let byline        : String
			let column        : String?
			let desFacet      : [String]
			let etaId         : Int
			let geoFacet      : [String]
			let id            : Int
			let media         : [Media]
			let nytdsection   : String
			let orgFacet      : [String]
			let perFacet      : [String]
			let publishedDate : String
			let section       : String
			let source        : String
			let subsection    : String
			let title         : String
			let type          : String
			let updated       : String
			let uri           : String
			let url           : String
		}
		
		let copyright  : String
		let numResults : Int
		let results    : [Article]
		let status     : String
	}
}
