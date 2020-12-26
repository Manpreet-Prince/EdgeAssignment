//
//  APIHelper.swift
//  NYTimes
//
//  Created by Manpreet on 25/12/2020.
//

import Foundation
import SystemConfiguration

import KRProgressHUD

class APIHelper {
	
	static let shared = APIHelper()
	
	let jsonDecoder = JSONDecoder()
	
	private init() {
		
		jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
	}
	
	// MARK:- Send Request
	
	private func sendRequest(endPoint:      String,
							 showHud:       Bool,
							 method:        HTTP_METHOD,
							 params:        [String: Any],
							 completion:    @escaping (_ success: Bool, _ data: Data?, _ errorMsg: String?) -> Void) {
		
		if internetNotAvailable() {
			
			if showHud {
				
				KRProgressHUD.showInfo(withMessage: CONST_STRING.noInternetMessage)
			}
			
			completion(false, nil, nil)
			
			return
		}
		
		if showHud {
			
			KRProgressHUD.show()
		}
		
		var reqURL = "\(BASE_URL)/\(endPoint)"
		
		var request = URLRequest(url: URL(string: reqURL)!)
		
		request.httpMethod = method.rawValue
		
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
		
		request.setValue("XMLHttpRequest", forHTTPHeaderField: "X-Requested-With")
		
		if method == .get {
			
			reqURL += buildQueryString(fromDictionary:params as! [String : String])
			
			request.url = URL(string: reqURL)!
			
		} else if method == .post {
			
			guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
				
				return
			}
			
			request.httpBody = httpBody
		}
		
		URLSession.shared.dataTask(with: request) { (data, response, error) in
			
			if error != nil || data == nil {
				
				if showHud {
					
					KRProgressHUD.dismiss()
				}
				
				completion(false, nil, error.debugDescription)
				
				return
			}
			
			guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
				
				do {
					
					if showHud {
					
						let faultObj = try self.jsonDecoder.decode(Parser.Fault.self, from: data!)
						
						KRProgressHUD.showError(withMessage: faultObj.fault.faultstring)
					}
					
					completion(false, nil, CONST_STRING.serverErrorStr)
					
				} catch {
					
					print("Response Error")
				}
				
				return
			}
			
			guard let mime = response.mimeType, mime == "application/json" else {
				
				if showHud {
					
					KRProgressHUD.dismiss()
				}
				
				completion(false, nil, "Mime Error")
				
				return
			}
			
			if showHud {
				
				KRProgressHUD.dismiss()
			}
			
			completion(true, data, nil)
			
		}.resume()
	}
	
	// MARK:- Private Functions
	
	private func internetNotAvailable() -> Bool {
		
		var zeroAddress = sockaddr_in()
		
		zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
		
		zeroAddress.sin_family = sa_family_t(AF_INET)
		
		let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
			
			$0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
				
				SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
			}
		}
		
		var flags = SCNetworkReachabilityFlags()
		
		if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
			
			return false
		}
		
		let isReachable = flags.contains(.reachable)
		
		let needsConnection = flags.contains(.connectionRequired)
		
		return !(isReachable && !needsConnection)
	}
	
	private func buildQueryString(fromDictionary parameters: [String: String]) -> String {
		
		var urlVars: [String] = []
		
		for (key, value) in parameters {
			
			if let encodedValue = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
				
				urlVars.append(key + "=" + encodedValue)
			}
		}
		
		return urlVars.isEmpty ? "" : "?" + urlVars.joined(separator: "&")
	}
	
	// MARK:- Public Functions
	
	func fetchArticles(_ duration: String, _ completion: @escaping (_ success: Bool, _ articleArr: [Parser.Viewed.Article]?, _ errorMsg: String?) -> Void) {
		
		let params = ["api-key" : API_KEY]
		
		sendRequest(endPoint : duration + ".json",
					showHud : true,
					method : .get,
					params : params) { (success, data, errorStr) in
			
			if success {
				
				do {
					
					let obj = try self.jsonDecoder.decode(Parser.Viewed.self, from: data!)
					
					if obj.status == "OK" {
					
						completion(true, obj.results, nil)
						
					} else {
						
						completion(false, nil, "API issue")
					}
					
				} catch {
					
					completion(false, nil, error.localizedDescription)
				}
				
			} else {
				
				completion(false, nil, errorStr)
			}
		}
	}
}
