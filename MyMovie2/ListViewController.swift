//
//  ListViewController.swift
//  MyMovie2
//
//  Created by Mac on 2015. 11. 14..
//  Copyright © 2015년 Mac. All rights reserved.
//

import UIKit

class ListViewController : UITableViewController {
	
	@IBOutlet var tv: UITableView!
	var list = [MovieVO]()
//	var list = Array<MovieVO>()
	
	func callMovieAPI() {
		// 1. URI 생성 (get방식일때는 헤더도 파라미터로 붙이면 됨)
		let urlStrig = "http://apis.skplanetx.com/hoppin/movies?order=releasedateasc&count=10&page=1&genreId=&version=1&appKey=ba8997a8-a439-398f-af06-d354b61d249e"
		let apiURI = NSURL(string: urlStrig)
		
		// 2. REST API 호출 (NSData가 내부적으로 호출하는 기능 있음, NSURLRequest/NSMutableURLRequest도 가능)
		// 포스트방식은 NSURLRequest를 이용
		let apidata :  NSData? = NSData(contentsOfURL: apiURI!)
		
		// 3. 응답 출력
		NSLog("API Result=%@", NSString(data: apidata!, encoding: NSUTF8StringEncoding)!)
		
		// 4. JSON 객체를 파싱하여 NSDictionary, NSArray 객체로 받음
		// (NSDictionary로 받는 이유는 타입이 달라도 가능하기 때문)
		do {
			let result = try NSJSONSerialization.JSONObjectWithData(apidata!, options: []) as! NSDictionary
			
			// 5. 데이터 구조에 따라 차례대로 캐스팅하며 읽어온다.
			let hoppin = result["hoppin"] as! NSDictionary
			let totalCount = hoppin["totalCount"]
			let movies = hoppin["movies"] as! NSDictionary
			let movie = movies["movie"] as! NSArray
			
			print("+++++ totalCount: \(totalCount)")
			
			// 6. 테이블 뷰 리스트를 구성할 데이터 형식
			var mvo : MovieVO
			
			// 7. Iterator 처리를 하면서 API 데이터를 MovieVO 객체에 저장한다.
			for row in movie {
				mvo = MovieVO()
				
				mvo.title = row["title"] as? String
				mvo.description = row["genreNames"] as? String
				mvo.thumbnail = row["thumbnailImage"] as? String
				mvo.detail = row["linkUrl"] as? String
				mvo.rating = (row["ratingAverage"] as? NSString)!.floatValue
				
				self.list.append(mvo)
			}
			
		} catch {
			NSLog("Parse Error!!")
		}
	}

	override func viewDidLoad() {
		callMovieAPI()
		
		// 화면에 다 뿌린 다음 (indexPath를 확인 한 후에 원하는 위치로 이동)
		// 테이블뷰 를 아울렛 변수로 추가
//		tv.scrollToRowAtIndexPath(<#T##indexPath: NSIndexPath##NSIndexPath#>, atScrollPosition: <#T##UITableViewScrollPosition#>, animated: <#T##Bool#>)
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.list.count
	}

	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let mvo = self.list[indexPath.row]
		let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! MovieCell
		
		cell.title?.text = mvo.title
		cell.desc?.text = mvo.description
		cell.rating?.text = String(mvo.rating!)
		
		return cell
	}
	

	
}
