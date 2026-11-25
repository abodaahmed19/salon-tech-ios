/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct ProviderDetailsData : Mappable {
	var user_id : Int?
	var user_name : String?
	var user_image : String?
	var user_address : String?
	var verified : Bool?
	var verified_user : Bool?
	var rate : Int?
	var imageIdentity : String?
	var discount : String?
	var listImages : [String]?
	var bio : String?
	var cover : String?
	var cover_type : String?
	var isFav : Bool?
	var certified_status : Bool?
	var certifiedFrom : String?
	var certified_image : String?
	var reservations_ended_count : Int?
	var work_places : [Work_places]?
	var sub_departments : [Sub_departments]?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {

		user_id <- map["user_id"]
		user_name <- map["user_name"]
		user_image <- map["user_image"]
		user_address <- map["user_address"]
		verified <- map["verified"]
		verified_user <- map["verified_user"]
		rate <- map["rate"]
		imageIdentity <- map["imageIdentity"]
		discount <- map["discount"]
		listImages <- map["listImages"]
		bio <- map["bio"]
		cover <- map["cover"]
		cover_type <- map["cover_type"]
		isFav <- map["isFav"]
		certified_status <- map["certified_status"]
		certifiedFrom <- map["certifiedFrom"]
		certified_image <- map["certified_image"]
		reservations_ended_count <- map["reservations_ended_count"]
		work_places <- map["work_places"]
		sub_departments <- map["sub_departments"]
	}

}