//
//  ListViewController.swift
//  MyMovie2
//
//  Created by Mac on 2015. 11. 14..
//  Copyright © 2015년 Mac. All rights reserved.
//

import UIKit

class ListViewController : UITableViewController {
	
	var list = [MovieVO]()
//	var list = Array<MovieVO>()
	
	func callMovieAPI() {
		// 1. URI 생성 (get방식일때는 헤더도 파라미터로 붙이면 됨)
		let urlStrig = "http://apis.skplanetx.com/hoppin/movies?order=releasedateasc&count=10&page=1&genreId=&version=1&appKey=ba8997a8-a439-398f-af06-d354b61d249e"
		let apiURI = NSURL(string: urlStrig)
		
		// 2. REST API 호출 (NSData가 내부적으로 호출하는 기능 있음, NSURLRequest도 가능)
		// 포스트방식은 NSURLRequest를 이용
		let apidata :  NSData? = NSData(contentsOfURL: apiURI!)
		
		// 3. 응답 출력
		NSLog("API Result=%@", NSString(data: apidata!, encoding: NSUTF8StringEncoding)!)
	}

	override func viewDidLoad() {
		callMovieAPI()
	}
	
}
