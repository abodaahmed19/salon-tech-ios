/* 
Copyright (c) 2020 Swift Models Generated from JSON powered by http://www.json4swift.com

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

For support, please feel free to contact me at https://www.linkedin.com/in/syedabsar

*/

import Foundation
import ObjectMapper

struct Reservation : Mappable {
	var reservation_lat : String?
	var reservation_provider_name : String?
	var reservation_money_pay : String?
	var reservation_cancel_reason : String?
	var reservation_provider_id : String?
	var reservation_address : String?
	var reservation_client_name : String?
	var reservation_status : String?
	var reservation_id : Int?
	var reservation_net : String?
	var reservation_paymentType : String?
	var reservation_client_image : String?
	var reservation_rest : String?
	var reservation_client_id : String?
	var reservation_provider_image : String?
	var reservation_total : String?
	var reservation_lon : String?
	var reservation_date : String?
	var reservation_addedValue  : Int?
	var reservation_time : String?
	var reservation_addValue : String?
	var reservation_if_provider_end : Bool?
	var reservation_if_client_end : Bool?
	var reservation_comment : String?

	init?(map: Map) {

	}

	mutating func mapping(map: Map) {
		reservation_lat <- map["reservation_lat"]
		reservation_provider_name <- map["reservation_provider_name"]
		reservation_money_pay <- map["reservation_money_pay"]
		reservation_cancel_reason <- map["reservation_cancel_reason"]
		reservation_provider_id <- map["reservation_provider_id"]
		reservation_address <- map["reservation_address"]
		reservation_client_name <- map["reservation_client_name"]
		reservation_status <- map["reservation_status"]
		reservation_id <- map["reservation_id"]
		reservation_net <- map["reservation_net"]
		reservation_paymentType <- map["reservation_paymentType"]
		reservation_client_image <- map["reservation_client_image"]
		reservation_rest <- map["reservation_rest"]
		reservation_client_id <- map["reservation_client_id"]
		reservation_provider_image <- map["reservation_provider_image"]
		reservation_total <- map["reservation_total"]
		reservation_lon <- map["reservation_lon"]
		reservation_date <- map["reservation_date"]
		reservation_addedValue  <- map["reservation_addedValue "]
		reservation_time <- map["reservation_time"]
		reservation_addValue <- map["reservation_addValue"]
		reservation_if_provider_end <- map["reservation_if_provider_end"]
		reservation_if_client_end <- map["reservation_if_client_end"]
		reservation_comment <- map["reservation_comment"]
	}

}
