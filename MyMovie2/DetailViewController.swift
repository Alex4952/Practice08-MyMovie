//
//  DetailViewController.swift
//  MyMovie2
//
//  Created by Mac on 2015. 11. 14..
//  Copyright © 2015년 Mac. All rights reserved.
//

import UIKit

// 웹뷰를 내비게이션바 영역까지 전체를 덮어야 함.
// 호핀에서 반응형 웹페이지 제공
class DetailViewController : UIViewController {
	
	
	@IBOutlet var naviBar: UINavigationItem!
	
	@IBOutlet var wv: UIWebView!
	
	// 목록에서 넘겨주는 영화 데이터를 받을 변수
	var mvo : MovieVO? = nil
	
	
	override func viewDidLoad() {
		
		// 내비게이션 바의 타이틀에 영화명 출력
		self.naviBar.title = self.mvo?.title
		
		// 웹 뷰에 페이지를 출력
		let req = NSURLRequest(URL: NSURL(string: (self.mvo?.detail)!)!)
		self.wv.loadRequest(req)
	}
	
}
