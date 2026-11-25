//
//  AppDelegate.swift
//  salon
//
//  Created by AL Badr  on 5/17/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import MFSDK
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import FacebookCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    /*
     
     الفاير بيز بتاع صالون موجود على أكاونت الشركة
     
     "developer.badrsystems@gmail.com"
     
     */
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        LanguageManger.shared.defaultLanguage = .en
        SalonDesign.install()
        
        GMSServices.provideAPIKey(MAP_KEY)
        
//        MFSettings.shared.configure(token: Urls.PAYMENT_TOKEN, baseURL: Urls.PAYMENT_BASE_URL)
//
//        // you can change color and title of nvgigation bar
//        let them = MFTheme(navigationTintColor: .white,
//                           navigationBarTintColor: .lightGray,
//                           navigationTitle: "Payment",
//                           cancelButtonTitle: "Cancel")
//
//        MFSettings.shared.setTheme(theme: them)
        
        FirebaseApp.configure()

#if DEBUG
        // Opt-in visual review only. Normal app launches keep their existing flow.
        if DesignReviewCapture.isEnabled {
            DesignReviewCapture.start(appDelegate: self)
            return true
        }
#endif

        let pushManager = PushNotificationManager(userID: "currently_logged_in_user_id")
        pushManager.registerForPushNotifications()

        
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)

        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
//    
//    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//        return ApplicationDelegate.shared.application(
//            app,
//            open: url,
//            options: options
//        )
//    }
}


#if DEBUG
/// Reproducible, opt-in simulator screenshots of the real storyboard controllers.
/// Network calls are held during review; no login, booking or payment is submitted.
private final class DesignReviewOfflineProtocol: URLProtocol {
    override class func canInit(with request: URLRequest) -> Bool {
        guard ["http", "https"].contains(request.url?.scheme ?? "") else { return false }
        // Public image resources may load; API calls use a frozen, read-only snapshot.
        if request.url?.host == "salon-tech.net", request.url?.path.contains("/api/v2/") == false { return false }
        return true
    }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }
    override func startLoading() {
        guard let url = request.url else { return }
        let endpoint = url.path.components(separatedBy: "/api/v2/").last ?? ""
        let readOnlyPostEndpoints = ["show-wallet", "client-balance-sheet", "provider-balance-sheet", "reservations_of_end"]
        guard (request.httpMethod ?? "GET") == "GET" || readOnlyPostEndpoints.contains(endpoint) else { return }
        let file = DesignReviewCapture.fixtureDirectory.appendingPathComponent(endpoint.replacingOccurrences(of: "/", with: "--") + ".json")
        guard let data = try? Data(contentsOf: file),
              let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: ["Content-Type": "application/json"]) else { return }
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        client?.urlProtocol(self, didLoad: data)
        client?.urlProtocolDidFinishLoading(self)
    }
    override func stopLoading() {}
}

enum DesignReviewCapture {
    static var isEnabled: Bool { ProcessInfo.processInfo.arguments.contains("--design-review") }
    static var fixtureDirectory: URL {
        let args = ProcessInfo.processInfo.arguments
        let role: String
        if let index = args.firstIndex(of: "--review-role"), args.count > index + 1 { role = args[index + 1] }
        else { role = "client" }
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("ReviewFixtures").appendingPathComponent(role)
    }

    static func json(_ name: String) -> [String: Any] {
        guard let data = try? Data(contentsOf: fixtureDirectory.appendingPathComponent(name + ".json")),
              let value = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return [:] }
        return value
    }

    static func respond(to urlString: String, completion: @escaping (NSObject?, NSError?) -> Void) -> Bool {
        guard isEnabled else { return false }
        let endpoint = URL(string: urlString)?.path.components(separatedBy: "/api/v2/").last ?? ""
        let response = json(endpoint.replacingOccurrences(of: "/", with: "--"))
        if !response.isEmpty { DispatchQueue.main.async { completion(response as NSDictionary, nil) } }
        return true
    }

    static func start(appDelegate: AppDelegate) {
        let args = ProcessInfo.processInfo.arguments
        guard let index = args.firstIndex(of: "--design-review"), args.count > index + 2 else { return }
        let storyboardName = args[index + 1]
        let identifier = args[index + 2]
        LanguageManger.shared.setLanguage(language: .ar)
        URLProtocol.registerClass(DesignReviewOfflineProtocol.self)
        Database.database().goOffline()
        UIView.setAnimationsEnabled(false)
        if let account = LoginData(JSON: json("account")) {
            Helper.saveObjectDefault(key: UserDefault.userData, value: account)
        }
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: storyboardName, bundle: nil)
            let target = storyboard.instantiateViewController(withIdentifier: identifier)
            target.title = target.title?.localiz()
            let selection = json("selection")
            let home = HomeData(JSON: json("home")["data"] as? [String: Any] ?? [:])
            if let screen = target as? SearchServicesVC { screen.servicesList = home?.departments ?? [] }
            if let screen = target as? SearchProvidersVC { screen.providersList = home?.providers ?? [] }
            if let screen = target as? ServicesVC {
                screen.servicesList = home?.departments ?? []
                screen.serviceId = selection["department"] as? Int ?? 0
            }
            if let screen = target as? ProviderDetailsSegmentVC {
                screen.providerId = selection["provider"] as? Int ?? 0
                screen.providerName = home?.providers?.first?.user_name ?? ""
            }
            if let screen = target as? ProviderDetailsVC { screen.provider_id = selection["provider"] as? Int ?? 0 }
            if let screen = target as? ProviderCommentsVC { screen.provider_id = selection["provider"] as? Int ?? 0 }
            if let screen = target as? ArticleDetailsVC { screen.articleId = selection["article"] as? Int ?? 0 }
            if let screen = target as? TrackProviderVC {
                screen.providerId = "\(selection["provider"] as? Int ?? 0)"
            }
            if let media = target as? ChatImagesVC { media.fileType = "image" }
            let nav: UINavigationController
            if let targetNav = target as? UINavigationController {
                nav = targetNav
            } else {
                nav = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "mainNC") as! UINavigationController
                if identifier == "ContainerVC" {
                    nav.setViewControllers([target], animated: false)
                } else {
                    nav.setViewControllers([UIViewController(), target], animated: false)
                }
            }
            appDelegate.window?.rootViewController = nav
            appDelegate.window?.makeKeyAndVisible()
            if args.contains("--review-smoke") {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                    var checks: [String] = []
                    if let container = target as? ContainerVC {
                        container.homeBtn_tapped(container)
                        container.homeBtn_tapped(container)
                        precondition(container.children.count == 1, "Repeated home selection must retain one child")
                        container.balancesBtn_tapped(container)
                        container.notificationsBtn_tapped(container)
                        container.articlesBtn_tapped(container)
                        precondition(container.children.count == 1, "Tab switching must retain one child")
                        precondition(container.children.first is MyOrdersVC || container.children.first is ProviderOrdersVC, "Bookings tab must open role-appropriate orders")
                        container.profileBtn_tapped(container)
                        container.homeBtn_tapped(container)
                        precondition(container.children.count == 1)
                        checks.append("home, wallet, notifications, bookings and account routes")
                        checks.append("one child after repeated tab switching")
                    }
                    if let appointment = target as? ReservationDataVC {
                        precondition(appointment.cityBtn.superview != nil && appointment.totalLabel.superview != nil)
                        appointment.chooseDateBtn_tapped(appointment)
                        precondition(appointment.dateTF.isEnabled, "Date picker field must remain connected")
                        appointment.view.endEditing(true)
                        appointment.chooseTime_tapped(appointment)
                        precondition(appointment.timeTF.isEnabled, "Time picker field must remain connected")
                        appointment.view.endEditing(true)
                        precondition(appointment.sensitiveBtn.superview != nil)
                        checks.append("retained appointment outlets and date/time picker actions")
                    }
                    if let suggestion = target as? SuggestTimeVC {
                        suggestion.dateBtn_tapped(suggestion)
                        precondition(suggestion.chooseDatePicker.locale?.languageCode == "ar")
                        precondition(suggestion.chooseDatePicker.calendar.identifier == .gregorian)
                        suggestion.view.endEditing(true)
                        suggestion.setupMinutesDropDown()
                        suggestion.setupMinutesDropDown()
                        precondition(suggestion.minutes.count == 60, "Minute choices must not duplicate")
                        suggestion.selectedDateString = "2099-11-14"
                        suggestion.selectedHour = "01"
                        suggestion.selectedMinute = "30"
                        suggestion.selectedPeriod = "PM".localiz()
                        suggestion.addBtn_tapped(suggestion)
                        precondition(suggestion.datesList.last?.suggestTimeAPI == "13:30:00")
                        precondition(suggestion.selectedPeriod == "AM".localiz(), "Period must reset with its button")
                        suggestion.selectedDateString = "2099-11-14"
                        suggestion.selectedHour = "01"
                        suggestion.selectedMinute = "30"
                        suggestion.addBtn_tapped(suggestion)
                        precondition(suggestion.datesList.last?.suggestTimeAPI == "01:30:00")
                        suggestion.datesList.removeAll()
                        suggestion.datesCV.reloadData()
                        checks.append("Arabic Gregorian picker, unique minutes and afternoon-to-morning reset")

                        let dueCell = Bundle.main.loadNibNamed("RequestDueCell", owner: nil)?.first as! RequestDueCell
                        for (amount, hidden) in [("0", true), ("0.00", true), ("-5", true), ("25.50", false)] {
                            let due = DueModel(JSON: ["payable_to_provider": amount, "admin_agree": "agree"])!
                            dueCell.configRequestCell(item: due)
                            precondition(dueCell.requestBtn.isHidden == hidden, "Only positive dues may be requested")
                        }
                        checks.append("zero, negative and positive due amounts with reused cell")

                        let clientCell = Bundle.main.loadNibNamed("DoneClientCell", owner: nil)?.first as! DoneClientCell
                        var order = OrdersModel()
                        order.reservation_if_provider_end = true
                        clientCell.configCell(item: order)
                        precondition(clientCell.cancelBtn.isHidden && clientCell.trackBtn.isHidden && clientCell.payView.isHidden)
                        precondition(clientCell.payAndRateBtn.isEnabled && clientCell.payAndRateBtn.title(for: .normal) == "Rate".localiz())
                        order.reservation_if_provider_end = false
                        clientCell.configCell(item: order)
                        precondition(!clientCell.cancelBtn.isHidden && !clientCell.chatBtn.isHidden)
                        checks.append("provider-ended order leaves rating; reused cell restores active actions")
                        let providerCell = Bundle.main.loadNibNamed("ConfirmedProviderCell", owner: nil)?.first as! ConfirmedProviderCell
                        order.reservation_if_provider_end = true
                        providerCell.configCell(item: order)
                        precondition(!providerCell.finishBtn.isEnabled && !providerCell.completeBtn.isEnabled)
                        precondition(providerCell.orderStatus.text == "Completed".localiz())
                        order.reservation_if_provider_end = false
                        providerCell.configCell(item: order)
                        precondition(providerCell.finishBtn.isEnabled && providerCell.completeBtn.isEnabled)
                        checks.append("provider completion disables repeated finish and resets on reuse")
                    }
                    if let payment = target as? EPayVC {
                        func descendants(_ view: UIView) -> [UIView] {
                            [view] + view.subviews.flatMap { descendants($0) }
                        }
                        let background = payment.ePayMethodsCV.backgroundView!
                        let retry = descendants(background).compactMap { $0 as? UIButton }.first!
                        precondition(!background.isHidden && !retry.isHidden, "Missing configuration must show recovery")
                        retry.sendActions(for: .touchUpInside)
                        precondition(!background.isHidden && !retry.isHidden, "Retry must remain usable after failure")
                        checks.append("payment configuration failure shows message and usable retry without transaction")
                    }
                    let result: [String: Any] = ["status": "passed", "screen": identifier, "role": fixtureDirectory.lastPathComponent, "checks": checks]
                    let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("DesignReview")
                    try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
                    if let data = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted) {
                        try? data.write(to: directory.appendingPathComponent("smoke-\(identifier)-\(fixtureDirectory.lastPathComponent).json"))
                    }
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                guard let window = appDelegate.window else { return }
                hideProgress(in: window)
                window.layoutIfNeeded()
                let prefix = "\(storyboardName)-\(identifier)-\(fixtureDirectory.lastPathComponent)"
                save(window: window, name: prefix + "-top")
                if let scroll = primaryScroll(in: target.view), scroll.contentSize.height > scroll.bounds.height + 80 {
                    scroll.setContentOffset(CGPoint(x: scroll.contentOffset.x, y: max(-scroll.adjustedContentInset.top, scroll.contentSize.height - scroll.bounds.height + scroll.adjustedContentInset.bottom)), animated: false)
                    window.layoutIfNeeded()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        save(window: window, name: prefix + "-bottom")
                    }
                }
            }
        }
    }

    private static func primaryScroll(in view: UIView) -> UIScrollView? {
        if let scroll = view as? UIScrollView, scroll.bounds.height > 250 { return scroll }
        return view.subviews.compactMap { primaryScroll(in: $0) }.first
    }

    private static func hideProgress(in view: UIView) {
        if NSStringFromClass(type(of: view)).contains("MBProgressHUD") { view.isHidden = true }
        for child in view.subviews { hideProgress(in: child) }
    }

    private static func save(window: UIWindow, name: String) {
        let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("DesignReview", isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let renderer = UIGraphicsImageRenderer(bounds: window.bounds)
        let data = renderer.pngData { _ in window.drawHierarchy(in: window.bounds, afterScreenUpdates: true) }
        do {
            try data.write(to: directory.appendingPathComponent(name + ".png"), options: .atomic)
            try name.write(to: directory.appendingPathComponent("ready.txt"), atomically: true, encoding: .utf8)
        } catch { print("Design review capture failed: \(error)") }
    }
}
#endif
