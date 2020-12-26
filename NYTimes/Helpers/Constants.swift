//
//  Constants.swift
//  NYTimes
//
//  Created by Manpreet on 25/12/2020.
//

import Foundation


let BASE_URL = "http://api.nytimes.com/svc/mostpopular/v2/viewed/"

let API_KEY = "0sEMD741Q42E18UP4XgaL11nji7s1AHc"


let PERIOD_ARR = ["1", "7", "30"]


enum HTTP_METHOD: String {
	
	case get =  "GET"
	case post = "POST"
}

struct CONST_STRING {
	
	static let noInternetMessage =  "No internet connection found."
	
	static let apiErrorTitle =      "Warning"
	
	static let apiSuccessTitle =    "Success"
	
	static let serverErrorStr =     "Server Error"
	
	static let otherErrorStr =      "Something went wrong!"
}

func BG_THREAD(_ block: @escaping () -> Void) {
	
	DispatchQueue.global(qos: .default).async(execute: block)
}

func MAIN_THREAD(_ block: @escaping () -> Void) {
	
	DispatchQueue.main.async(execute: block)
}
