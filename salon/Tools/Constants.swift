//
//  OFCStrings.swift
//  OrangeFootballClub
//
//  Created by Alaa Taher on 11/15/16.
//  Copyright © 2016 Alaa Taher. All rights reserved.
//

import UIKit

let SITE_URL = "http://salon-tech.net/"
let BASE_URL = SITE_URL + "api/v2/"

let homeCellHeight:CGFloat = 230.0
let homeCellWidth:CGFloat = 300.0
let myOrderCellHeight = 140.0

let kInternetConnectionNotReachable: String = "NOT_REACHABLE"
let kInternetConnectionReachable: String = "REACHABLE"

let MAP_KEY = "AIzaSyCNOdXLbYetGyia1Yn0vPTKqNoVLSc1rLk"

let databasePath = "locations"

let connectionErrorMessage = "Check Your Internet Connection".localiz()

enum UIUserInterfaceIdiom : Int {
    case unspecified
    case phone // iPhone and iPod touch style UI
    case pad // iPad style UI
}

enum OrderStatus {
    static let INITIAL: String  = "initial"
    static let DONE: String  = "done"; // Confirmed
    static let CHANGE_TIME: String  = "waiting_time"
    static let CANCELED: String  = "cancel"
    static let BANK_AGREE: String  = "bank_admin_agree"
    static let END: String  = "end"
    static let PAYMENT_WAITING: String  = "waiting_for_payment"
}

enum Colors {
    static let greenColor = UIColor(red: 0.00, green: 0.53, blue: 0.26, alpha: 1.00)
    static let pinkColor = UIColor(red: 0.78, green: 0.26, blue: 0.28, alpha: 1.00)
    static let blueColor = UIColor(red: 0.22, green: 0.63, blue: 0.78, alpha: 1.00)
    static let orangeColor = UIColor(named: "orange")
}

enum PayMethods {
    static let ON_DELIVER: String  = "on_deliver"
    static let E_PAYMENT: String  = "e_payment"
    static let BANK: String  = "bank"
    static let WALLET: String  = "wallet"
}

enum StatusCode {
    static let StatusOK = 200
    static let StatusCreated = 201
    static let StatusNoContent = 204
    static let StatusNotfound = 404
}

enum AlertType: Int {
    case error = 1
    case success = 2
}

enum UserDefault {
    static let userData = "userData"
    static let userToken = "userToken"
    static let userID = "userID"
    static let userName = "userName"
    static let userImage = "userImage"
    static let userMobile = "userMobile"
    static let userEmail = "userEmail"
    static let userPoints = "userPoints"
    static let language = "language"
    static let activeStatus = "activeState"
    static let player_id = "player_id"
    
    static let notificationsCount = "notificationsCount"
    static let messagesCount = "messagesCount"
    static let ordersCount = "ordersCount"
    
    static let IS_PROVIDER = "IS_PROVIDER"
    
    static let userReservation = "userReservation"
    static let userSettings = "userSettings"
    static let userColors = "userColors"
}

enum Storyboards {
    static let authentication = "Authentication"
    static let main = "Main"
    static let user = "User"
    static let reservation = "Reservation"
    static let provider = "Provider"
}

enum PucherConstants {
    static let CLIENT_ID: Int = 883775
    static let CLIENT_SECRET: String = "c206ef6190ce7c3d68bc"
    static let CLIENT_KEY: String = "af9be97dd59fcfcd6477"
    static let CHATKIT_INSTANCE_LOCATOR: String = "CHATKIT_INSTANCE_LOCATOR"
    static let CLUSTER: String = "eu"
}

enum Urls {
    //Register
    static let CLIENT_REGISTER = BASE_URL + "client-register"
    static let PROVIDER_REGISTER = BASE_URL + "provider-register"
    // Login
    static let LOGIN = BASE_URL + "login"
    static let SOCIAL_LOGIN = BASE_URL + "social-login"
    static let DELETE_ACCOUNT = BASE_URL + "delete-account"
    
    // Home
    static let HOME = BASE_URL + "home"
    // Cities
    static let CITIES = BASE_URL + "cities"
    static let DISTRICTS = BASE_URL + "districts/%@"
    // All Departments
    static let DEPARTMENTS = BASE_URL + "departments"
    // Sub Departments
    static let SUB_DEPARTMENT = BASE_URL + "sub_departments/%@"
    //Full Departments with sub
    static let ALL_DEPARTMENTS = BASE_URL + "all-departments"
    // Check Coupon
    static let CHECK_COUPON = BASE_URL + "check-coupon"
    // Adds
    static let ADDS_SETTING = BASE_URL + "settings"
    // Providers Of Specific City And Department
    static let SPECIFIC_PROVIDERS = BASE_URL + "get-providers"
    // Reservation
    static let RESERVATION = BASE_URL + "reservation"
    static let RESERVATION_PAYMENT = BASE_URL + "reservation-payment"
    static let CONVERT_TO_BANK = BASE_URL + "convert-to-bank"
    
    // Client Orders
    static let CLIENT_ORDERS = BASE_URL + "orders-client"
    static let CANCEL_ORDER = BASE_URL + "order-cancel-client/%@"
    static let SUBMIT_NEW_DATE = BASE_URL + "orders-approved-time-reservation"
    static let PREVIOUS_ORDERS = BASE_URL + "reservations_of_end"
    static let END_RESERVATION_CLIENT = BASE_URL + "end-reservation-client"
    
    // Provider Orders
    static let PROVIDER_ORDERS = BASE_URL + "orders-provider"
    static let CANCEL_ORDER_PROVIDER = BASE_URL + "order-cancel-provider"
    static let SUGGEST_TIMES = BASE_URL + "suggest-times"
    static let APPROVE_ORDER = BASE_URL + "approved-reservation-provider"
    static let END_CASH_ORDER = BASE_URL + "end-reservation"
    
    // Auth
    static let FORGET_PASSWORD = BASE_URL + "forget-password"
    static let RESET_PASSWORD = BASE_URL + "reset-password"
    static let ACTIVATE_ACCOUNT = BASE_URL + "active-account"
    
    // Articles
    static let ARTICLES = BASE_URL + "articles"
    static let SINGLE_ARTICLE = BASE_URL + "article/%@"
    
    // Places
    static let GET_PLACES = BASE_URL + "get-places"
    static let SAVE_PLACE = BASE_URL + "add-places"
    static let REMOVE_PLACE = BASE_URL + "remove-place/%@"
    
    // Chat
    static let ALL_CHATS = BASE_URL + "all-chat"
    static let CHAT = BASE_URL + "chat/%@"
    static let OPEN_CHAT = BASE_URL + "open-chat/%@"
    static let SEND_CHAT = BASE_URL + "send-chat/%@"
    
    
    // Provider Commissions
    static let UP_PAID_COMMISSIONS = BASE_URL + "commissions-not-paid"
    static let PAID_COMMISSIONS = BASE_URL + "commissions-paid"
    static let PAY_COMMISSION = BASE_URL + "pay-commission"
    static let COMMISSION_DISCOUNT_REQUEST = BASE_URL + "add-discount-request"
    
    
    // Provider Details
    static let PROVIDER_DETAILS = BASE_URL + "provider-details/%@"
    
    
    // Favourites
    static let FAVOURITES = BASE_URL + "favorites"                              // All Favourites
    static let ADD_TO_FAVOURITE = BASE_URL + "add-favorite"                     // Add To Favourite
    static let REMOVE_FROM_FAVOURITE = BASE_URL + "delete-favorite/%@"        // Remove From Favourite
    
    
    // All Providers
    static let ALL_PROVIDERS = BASE_URL + "get-all-providers"
    static let EDIT_CLIENT_PROFILE = BASE_URL + "edit-client-profile"
    static let EDIT_PROVIDER_PROFILE = BASE_URL + "edit-provider-profile"
    static let UPDATE_CLIENT_PROFILE = BASE_URL + "update-client-profile"
    static let UPDATE_PROVIDER_PROFILE = BASE_URL + "update-provider-profile"
    static let CHANGE_PASSWORD = BASE_URL + "change-password"
    
    static let SHOW_WALLET = BASE_URL + "show-wallet"
    static let PROVIDER_WALLET_TRANSACTIONS = BASE_URL + "provider-wallet-transactions"
    static let CLIENT_WALLET_TRANSACTIONS = BASE_URL + "client-wallet-transactions"
    
    // Rate
    static let RATE = BASE_URL + "rate"
    
    //  Comments Provider
    static let PROVIDER_COMMENTS = BASE_URL + "provider-comments"
    static let OBJECT_COMMENT_PROVIDER = BASE_URL + "provider-objection/%@"
    
    static let PROVIDER_DETAILS_COMMENTS = BASE_URL + "provider-details-comments/%@"
    
    //  Comments Client
    static let CLIENT_COMMENTS = BASE_URL + "client-comments"
    static let OBJECT_COMMENT_CLIENT = BASE_URL + "client-objection/%@"
    
    // Notifications
    static let NOTIFICATIONS_CALL = BASE_URL + "notifications"
    static let READ_NOTIFICATION = BASE_URL + "notification-read"
    
    
    // Provider Balance
    static let PROVIDER_BALANCE = BASE_URL + "provider-balance-sheet"
    static let CLIENT_BALANCE = BASE_URL + "client-balance-sheet"
    
    
    // Contact Us
    static let CONTACT_INFO = BASE_URL + "contact-info"
    static let POLICY = BASE_URL + "policy"
    static let CONTACT_US = BASE_URL + "contact-us"
    
    // Verification Request
    static let SEND_VERFiCATION_REQUEST = BASE_URL + "send-verification-request"
    
    static let POINTS = BASE_URL + "points"
    static let CONVERT_TO_POINTS = BASE_URL + "convert-to-points"
    static let RECOVERY = BASE_URL + "recovery"
    static let MAKE_SATISFIED = BASE_URL + "make-satisfied"
    static let MANAGEMENT_REPORTING = BASE_URL + "management-reporting"
    static let PAYABLE = BASE_URL + "payable"
    static let BALANCES = BASE_URL + "balances"
    static let CONFIRM_PAYMENT_ADMIN = BASE_URL + "confirm-payment-from-admin"
    static let APP_COLORS = BASE_URL + "app_colors"
    static let accounts = BASE_URL + "bank-accounts"
    
    static let PAYMENT_BASE_URL = "https://apitest.myfatoorah.com/"
    
    static let PAYMENT_TOKEN = "rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL"
    
    static let BASE_URL_DIRECT_PAYMENT = "https://apidemo.myfatoorah.com/"
    static let EMAIL_DIRECT_PAYMENT = "apidirectpayment@myfatoorah.com" // Merchant Email
    static let PASSWORD_DIRECT_PAYMENT = "api12345*"
    
    static let E_PAYMENT = BASE_URL + "e-payment"
    static let PAYMENT_DATA = BASE_URL + "setup-payment"
    
    static let loginStatus = BASE_URL + "status"
    static let LOGOUT = BASE_URL + "logout"
    static let CHECK_VERIFICATION = BASE_URL + "verified"
}

/// Shared visual language for SalonTech's UIKit screens.
enum SalonDesign {
    static let primary = UIColor(red: 154/255, green: 56/255, blue: 87/255, alpha: 1)
    static let primarySoft = UIColor(red: 247/255, green: 234/255, blue: 240/255, alpha: 1)
    static let ink = UIColor(red: 38/255, green: 38/255, blue: 50/255, alpha: 1)
    static let secondary = UIColor(red: 117/255, green: 107/255, blue: 114/255, alpha: 1)
    static let canvas = UIColor(red: 250/255, green: 247/255, blue: 244/255, alpha: 1)
    static let line = UIColor(red: 233/255, green: 226/255, blue: 222/255, alpha: 1)

    static func text(_ ar: String, _ en: String) -> String {
        LanguageManger.shared.currentLanguage == .ar ? ar : en
    }

    static func font(_ size: CGFloat, bold: Bool = false) -> UIFont {
        let base = bold ? UIFont.systemFont(ofSize: size, weight: .semibold)
            : UIFont(name: "Tajawal-Medium", size: size) ?? UIFont.systemFont(ofSize: size)
        return UIFontMetrics.default.scaledFont(for: base)
    }

    static func navigation(_ bar: UINavigationBar) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = canvas
        appearance.shadowColor = .clear
        appearance.titleTextAttributes = [.font: font(19, bold: true), .foregroundColor: ink]
        appearance.largeTitleTextAttributes = [.font: font(30, bold: true), .foregroundColor: ink]
        bar.standardAppearance = appearance
        bar.scrollEdgeAppearance = appearance
        bar.compactAppearance = appearance
        bar.tintColor = primary
        bar.isTranslucent = false
    }

    static func install() {
        navigation(UINavigationBar.appearance())
        UISegmentedControl.appearance().selectedSegmentTintColor = primary
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: secondary, .font: font(14)], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor.white, .font: font(14, bold: true)], for: .selected)
        UITextField.appearance().tintColor = primary
        UITextView.appearance().tintColor = primary
        UIRefreshControl.appearance().tintColor = primary
    }
}
