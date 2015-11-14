//
//  ListViewController.swift
//  MyMovie2
//
//  Created by Mac on 2015. 11. 14..
//  Copyright © 2015년 Mac. All rights reserved.
//

import UIKit

class ListViewController : UITableViewController {
	
//	var currentIndexPath : NSIndexPath?
	
	// 스크롤을 하단으로 하기 위해
	@IBOutlet var tv: UITableView! // movieTable
	var page = 1
	
	var list = [MovieVO]()
//	var list = Array<MovieVO>()
	
	@IBOutlet var moreBtn: UIButton!
	
	// 향후에는 버튼이 아니라 제스처로 바꾸면 좋음, 원리는 똑같음.
	@IBAction func more(sender: AnyObject) {
		// 현재 페이지의 다음 페이지 정보를 요청해야 하므로
		self.page++
		
		// 영화차트 API 호출
		self.callMovieAPI()
		
		// 데이터를 다시 읽어오도록 테이브 뷰를 갱신한다.
		self.tv.reloadData()
	}
	
	func callMovieAPI() {
		// 1. URI 생성 (get방식일때는 헤더도 파라미터로 붙이면 됨)
		let urlStrig = "http://apis.skplanetx.com/hoppin/movies?order=releasedateasc&count=20&page=\(self.page)&genreId=&version=1&appKey=ba8997a8-a439-398f-af06-d354b61d249e"
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
			let movies = hoppin["movies"] as! NSDictionary
			let movie = movies["movie"] as! NSArray
			
			
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
			
			// 8. 전체 카운트를 얻는다
			let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
			
			// 9. totalCount가 읽어온 데이터 사이즈와 같거나 클 경우 더보기 버튼을 막는다.
			if (self.list.count >= totalCount) {
				self.moreBtn.hidden = true
			}
			
		} catch {
			NSLog("Parse Error!!")
		}
	}

	override func viewDidLoad() {
		callMovieAPI()
		
		// 화면에 다 뿌린 다음 (indexPath를 확인 한 후에 원하는 위치로 이동)
		// 테이블뷰 를 아울렛 변수로 추가 - 잘 안됨 (확인필요)
//		if currentIndexPath?.row == list.count - 1 {
//			tv.scrollToRowAtIndexPath(currentIndexPath!, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
//		}
	}
	
	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.list.count
	}

	// 이 안에서는 시간이 걸리는 복잡한 작업을 수행하면 안됨.
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let mvo = self.list[indexPath.row]
		
		NSLog("제목: \(mvo.title!), 호출된 행번호 : \(indexPath.row)")
		
		// 이런식으로 프로토타입셀을 여러가지 형태로 구성하고 원하는 형태로 선택 사용 가능
//		let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! MovieCell
		let cell = tableView.dequeueReusableCellWithIdentifier("imageCell") as! MovieCell
		
		cell.title?.text = mvo.title
		cell.desc?.text = mvo.description
		cell.rating?.text = String(mvo.rating!)
		
////////////////////////////////////////////////////////////////////////////
// 이 부분을 비동기처리로 변경 (웹에서 이미지를 읽어오는 부분이 이 함수 안에 있으면 버벅거림)
/*
		// 웹 상에 있는 이미지를 읽어온 다음 UIImage 객체로 생성
		let url = NSURL(string: mvo.thumbnail!)
		let imageData = NSData(contentsOfURL: url!)
		cell.thumbnail.image = UIImage(data: imageData!)
*/

		// 어싱크로 변경
		dispatch_async(dispatch_get_main_queue(), {
			cell.thumbnail.image = self.getThumbnailImage(indexPath.row)
		})
////////////////////////////////////////////////////////////////////////////
		
		// 구성된 셀을 리턴함
		return cell
	}
	
	func getThumbnailImage(index : Int) -> UIImage {
		
		// 인자값으로 받은 인덱스를 기반으로 해당하는 배열 데이터를 읽어옴
		let mvo = self.list[index]
		
		// 메모이제이션 처리 : 저장된 이미지가 있을 경우 이를 리턴하고, 없을 경우 다운로드받아 저장한 후 리턴함.
		if let savedImage = mvo.thumbnailImage {
			return savedImage
		}
		else {
			let url = NSURL(string: mvo.thumbnail!)
			let imageData = NSData(contentsOfURL: url!)
			mvo.thumbnailImage = UIImage(data: imageData!) // UIImage를 생성. MovieVO 객체에 저장함
			
			return mvo.thumbnailImage! // 저장된 이미지를 리턴
		}
	}
	
}

