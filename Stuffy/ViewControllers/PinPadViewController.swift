//
//  PinPadViewController.swift
//  Stuffy
//
//  Created by Adam on 08/07/2018.
//  Copyright © 2018 Adam Moskovich. All rights reserved.
//

import UIKit
import LocalAuthentication

class PinPadViewController: UIViewController {
    
    enum pinActionWanted {
        case login
        case turnOn, turnOff
        case create
        case resetPin
        case enteringNewPin
        case confirmPinChange
        case unassigned
    }
    
    struct Constants {
        static let isPinActiveKey = "isPinActive"
        static let pinKey = "Pin"
    }
    
    //////////////////////
    // TODO: Connect to data
    //////////////////////
    let defaults = UserDefaults.standard
    let myContext = LAContext()
    let myLocalizedReasonString = "👍🏼"
    var pinNumber = ""
    var newPin = ""
    var actionWanted: pinActionWanted = .create
    
    var pinIsOn: Bool {
        return UserDefaults.standard.object(forKey: Constants.isPinActiveKey) as? Bool ?? false }
    var correctPin: String {
        return UserDefaults.standard.object(forKey: Constants.pinKey) as? String ?? "" }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet var pinDidgitImageViews: [UIImageView]!
    @IBOutlet var pinBtn: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isThereAPin()
        cancelBtn.isHidden = actionWanted == .login ? true : false
        setTitle()
    }
    
    func isThereAPin() {
        if correctPin.count != 4 {
            actionWanted = .create
        }
    }
    
    func setTitle() {
        switch actionWanted {
        case .resetPin, .login, .turnOff:
            titleLabel.text = "Please Enter Your Pin"
            return
        case .create, .turnOn, .enteringNewPin:
            titleLabel.text = "Please Enter A New Pin"
            return
        case .confirmPinChange:
            titleLabel.text = "Please Confirm New Pin"
            return
        default:
            print("No action was stated for the pin")
            return
        }
    }
    
    @IBAction func pinBtnPressed(_ sender: UIButton) {
        pinDidgitImageViews[pinNumber.count].image = #imageLiteral(resourceName: "xcaDigitFull")
        switch pinNumber.count {
        case 0, 1, 2:
            pinNumber += "\(sender.tag)"
            print(pinNumber)
            return
        case 3:
            pinNumber += "\(sender.tag)"
            print(pinNumber)
            pinDidgitImageViews.forEach {didgit in
                didgit.image = #imageLiteral(resourceName: "xcaDigitEmpty") }
            determineActionOnCompletePin()
            return
        default:
            print("❌ Switch in pin has an unexpected Value")
        }
    }
    
    func determineActionOnCompletePin() {
        switch actionWanted {
        case .login, .turnOff, .resetPin:
            checkPin()
            return
        case .enteringNewPin, .turnOn, .create:
            newPin = pinNumber
            pinNumber = ""
            print("new Pin set to \(newPin)")
            confirmPinNumber()
            return
        case .confirmPinChange:
            // check if newPin == entered Pin
            if pinNumber == newPin {
                // change pin
                defaults.set(newPin, forKey: Constants.pinKey)
                // turn on pin
                defaults.set(true, forKey: Constants.isPinActiveKey)
                print("new Pin created \(correctPin)")
                // Turn on pin in user defaults
                defaults.set(true, forKey: Constants.isPinActiveKey)
                print("Pin is on")
                // dissmiss
                dismiss(animated: true)
            } else {
                pinNumber = ""
                print("Wrong Pin")
                titleLabel.text = "Wrong Pin, Please try again"
            }
            return
        default:
            return
        }
    }
    
    func checkPin() {
        if correctPin == pinNumber {
            print("right pin")
            pinNumber = ""
            pinEnteredCorrectly()
        } else {
            pinNumber = ""
            print("wrong pin")
        }
    }
    
    func pinEnteredCorrectly() {
        switch actionWanted {
        case .login:
            loginToMain()
            return
        case .create, .resetPin:
            enterNewPinNumber()
            return
        case .turnOff:
            pinNumber = ""
            // Turn off pin in user defaults
            defaults.set(false, forKey: Constants.isPinActiveKey)
            print("Pin state is \(pinIsOn)")
            dismiss(animated: true)
            return
        default:
            print("No action was stated for the pin")
            return
        }
    }
    
    func enterNewPinNumber() {
        titleLabel.text = "Please Set New Pin"
        actionWanted = .enteringNewPin
    }
    
    func confirmPinNumber() {
        titleLabel.text = "Please Confirm New Pin"
        actionWanted = .confirmPinChange
    }
    
    func turnOffPin() {
        // Turn off Pin
        defaults.set("", forKey: Constants.pinKey)
        dismiss(animated: true)
    }
    
    func loginToMain() {
        DispatchQueue.main.async {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = mainStoryboard.instantiateViewController(withIdentifier: "CustomTabBarViewContoller") as! CustomTabBarViewController
        UIApplication.shared.keyWindow?.rootViewController = viewController
        }
    }
    
    @IBAction func deleteSinglePin(_ sender: UIButton) {
        guard pinNumber.count > 0 else { return }
        pinNumber.removeLast()
        pinDidgitImageViews[pinNumber.count].image = #imageLiteral(resourceName: "xcaDigitEmpty")
        print(pinNumber)
    }
    @IBAction func cancelBtnTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    @IBAction func touchIDBtnTapped(_ sender: UIButton) {
        var authError: NSError?
        if #available(iOS 8.0, macOS 10.12.1, *) {
            if myContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError) {
                myContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: myLocalizedReasonString) { success, evaluateError in
                    if success {
                        switch self.actionWanted {
                        case .turnOff:
                            self.turnOffPin()
                        case .resetPin:
                            self.enterNewPinNumber()
                        case .login:
                        self.loginToMain()
                        default:
                            self.dismiss(animated: true)
                        }
                    } else {
                        // User did not authenticate successfully, look at error and take appropriate action
                    }
                }
            } else {
                // Could not evaluate policy; look at authError and present an appropriate message to user
            }
        } else {
            // Fallback on earlier versions
        }
    }

}
