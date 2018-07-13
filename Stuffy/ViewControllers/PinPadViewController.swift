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
    
    struct Constancts {
        static let systemBlueColor = "xcaStuffyDarkBlueColor"
        static let buttonBorderWidth: CGFloat = 2
        static let digitViewBorderWidth: CGFloat = 1
    }
    
    //////////////////////
    // TODO: Connect to data
    //////////////////////
    let myContext = LAContext()
    let myLocalizedReasonString = "Give me your 👍🏼!"
    var pinNumber = ""
    var correctPin = "5555"
    var newPin = ""
    var pinIsOn: Bool?
    var actionWanted: pinActionWanted = .create

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet var pinDidgitImageViews: [UIImageView]!
    @IBOutlet var pinBtn: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        isThereAPin()
        setupView()
        cancelBtn.isHidden = actionWanted == .login ? true : false
        setTitle()
    }
    
    func setupView() {
        for button in pinBtn {
            button.layer.cornerRadius = button.bounds.height/2 + 4
            button.layer.borderColor = Colors.stuffyNavyBlue.cgColor
            button.layer.borderWidth = Constancts.buttonBorderWidth
        }
        for digit in pinDidgitImageViews {
            digit.layer.cornerRadius = digit.frame.height / 2 + 2
            digit.layer.borderColor = Colors.stuffySoftBlue.cgColor
            digit.layer.borderWidth = Constancts.digitViewBorderWidth
            digit.layer.backgroundColor = Colors.stuffyBackgroundGray.cgColor
        }
    }
    
    func isThereAPin() {
        if correctPin.count == 0 {
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
        pinDidgitImageViews[pinNumber.count].backgroundColor = Colors.stuffySoftBlue
        switch pinNumber.count {
        case 0, 1, 2:
            pinNumber += "\(sender.tag)"
            print(pinNumber)
            return
        case 3:
            pinNumber += "\(sender.tag)"
            print(pinNumber)
            pinDidgitImageViews.forEach {didgit in
                didgit.backgroundColor = Colors.stuffyBackgroundGray }
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
                correctPin = newPin
                print("new Pin created \(correctPin)")
                pinIsOn = true
                print("Pin is on")
                // dissmiss
                dismiss(animated: true)
            } else {
                pinNumber = ""
                print("Wrong Pin")
                titleLabel.text = "Wrong Pin, Please try again"
            }
            
            // else
            // change label, wrong pin, please try again
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
//            let storyboard = UIStoryboard(name: "StuffyHome", bundle: nil)
//            let destinationVC = storyboard.instantiateViewController(withIdentifier: "StuffyHome")
//            present(destinationVC, animated: true, completion: nil)
            return
        case .create, .resetPin:
            enterNewPinNumber()
            return
        case .confirmPinChange:
            newPinConfirmed()
            return
        case .turnOff:
            pinNumber = ""
            pinIsOn = false
            print("Pin state is \(pinIsOn!)")
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
    
    func newPinConfirmed() {
        print("New Pin set as \(newPin)")
        //Turn on Pin
        //set pin == newPin
        activateTouchID()
        dismiss(animated: true)
    }
    
    func turnOffPin() {
        // Turn off Pin
        correctPin = ""
        dismiss(animated: true)
    }
    
    func activateTouchID() {
        
    }
    
    @IBAction func deleteSinglePin(_ sender: UIButton) {
        guard pinNumber.count > 0 else { return }
        pinNumber.removeLast()
        pinDidgitImageViews[pinNumber.count].backgroundColor = UIColor(white: 1, alpha: 0.01)
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
                        self.performSegue(withIdentifier: "segueStuffyHome", sender: self)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
