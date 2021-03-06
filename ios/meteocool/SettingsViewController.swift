//
//  SettingsController.swift
//  meteocool
//
//  Created by Nina Loser on 30.01.20.
//  Copyright © 2020 Florian Mauracher. All rights reserved.
//
import UIKit
import StepSlider

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var settingsBar:UINavigationBar!
    @IBOutlet weak var settingsTable:UITableView!
    
    //userDefaults
    let userDefaults = UserDefaults.init(suiteName: "group.org.frcy.app.meteocool")
    
    private var header = [
        NSLocalizedString("Map View", comment: "header"),
        NSLocalizedString("Layers", comment: "header"),
        NSLocalizedString("Push Notification", comment: "header"),
        NSLocalizedString("About", comment: "header")
    ]
    private var footer = [
        NSLocalizedString("Customise the appearance and behaviour of the main map.", comment: "footer"),
        NSLocalizedString("Enable or disable informational layers on the main map.", comment: "footer"),
        NSLocalizedString("If you want, we can notify you ahead of rain or snow at your current location.", comment: "footer"),
        NSLocalizedString("Version Nr", comment: "footer")
    ]
    private var dataPushNotification = [
        NSLocalizedString("Push Notification", comment: "dataPushNotification"),
        NSLocalizedString("Show Meteorological Details", comment: "dataPushNotification"),
        NSLocalizedString("Threshold", comment: "dataPushNotification"),
        NSLocalizedString("Time before", comment: "dataPushNotification")
    ]
    private var dataMapView = [
        NSLocalizedString("Map Rotation", comment: "dataMapView"),
        NSLocalizedString("Auto Zoom after Start", comment: "dataMapView"),
        NSLocalizedString("Darkmode", comment: "dataMapView"),
        //NSLocalizedString("Look", comment: "dataMapView")
    ]
    private var dataLayers = [
        NSLocalizedString("⚡️ Lightning", comment: "dataLayers"),
        NSLocalizedString("🌀 Mesocyclones", comment: "dataLayers"),
        NSLocalizedString("☂️ Shelters", comment: "dataLayers")
    ]
    private var dataAboutLable = [
        NSLocalizedString("Github", comment: "dataAboutLable"),
        NSLocalizedString("Twitter", comment: "dataAboutLable"),
        NSLocalizedString("Feedback", comment: "dataAboutLable"),
        NSLocalizedString("Push Token", comment: "dataAboutLable")
    ]
    private var dataAboutValue = [
        "","","",
        NSLocalizedString("Push Token", comment: "dataAboutValue")
    ]
    private var intensity = [
        NSLocalizedString("Drizzle", comment: "intensity"),
        NSLocalizedString("Light rain", comment: "intensity"),
        NSLocalizedString("Rain", comment: "intensity"),
        NSLocalizedString("Hail", comment: "intensity")
    ]
    
    //General View Things
    override func loadView() {
        super.loadView()
        self.view.addSubview(settingsBar)
        self.view.addSubview(settingsTable)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingsTable.estimatedRowHeight = 100
        settingsTable.rowHeight = 44
    }
    
    //Return Back with Done
    @IBAction func doneSettings(_ sender: Any){
        self.dismiss(animated: true,completion:nil)
    }

    //Nuber of Selections
    func numberOfSections(in tableView: UITableView) -> Int {
        return header.count
    }

    // Number of Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0: //Map View
            return dataMapView.count
        case 1: //Layer
            return dataLayers.count
        case 2: //Notification
            let pushNotification = userDefaults?.bool(forKey: "pushNotification")
            if pushNotification!{
                return dataPushNotification.count
            }
            else {
                return 1
            }
        case 3: //About
            return dataAboutLable.count
        default:
            return 0
        }
    }

    //Sections Header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return header[section]
    }
    
    //Selection Footer
    func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if(section == 2 && (userDefaults?.bool(forKey: "pushNotification"))!){
            return NSLocalizedString("Show Meteorological Details:\nFor advanced users, include meteorological details in the notification text (like dBZ values). \n\nThreshold:\nOnly send a notification if incoming precipitation is expected to be at least this intense. \n\nTime before:\nChange the amount of time before you want to be notified about precipitation.",comment: "selection Footer")
        }
        return footer[section]
    }

    //Table Content
    func tableView(_ tableView: UITableView,cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var returnCell : UITableViewCell
        
        // kind of cells
        let switcherCell = tableView.dequeueReusableCell(withIdentifier: "switcherCell")
        let textCell = tableView.dequeueReusableCell(withIdentifier: "textCell")
        let stepperSliderCell = tableView.dequeueReusableCell(withIdentifier: "stepperSliderCell")
        
        // Switch
        let switchView = UISwitch(frame: .zero)
        switchView.onTintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1.0)
        
        // StepperSlider
        let stepperSliderView = StepSlider.init(frame: CGRect(x: 15.0,y: 50.0,width: tableView.frame.width-30,height: 50.0))
        stepperSliderView.sliderCircleColor = UIColor(red: 233/255, green: 233/255, blue: 235/255, alpha: 1.0)
        stepperSliderView.labelColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1.0)
        let stepperSliderCellInfoLabel = UILabel.init(frame: CGRect(x: 20.0,y: 5.0,width: tableView.frame.width/2-15.0,height: 44.0))
        let stepperSliderCellValueLabel = UILabel.init(frame: CGRect(x: tableView.frame.width/2-15.0,y: 5.0,width: tableView.frame.width/2-10.0,height: 44.0))
        stepperSliderCellValueLabel.textAlignment = .right
        
        // Text
        let textInfoLabel = UILabel.init(frame: CGRect(x: 20.0,y: 0,width: tableView.frame.width/2-15.0,height: 44.0))
        let textValueLabel = UILabel.init(frame: CGRect(x: tableView.frame.width/2-15.0,y: 0,width: tableView.frame.width/2-10.0,height: 44.0))
        textValueLabel.textAlignment = .right
        textValueLabel.textColor = UIColor.gray
        let linkArrow = UIImageView.init(frame: CGRect(x: tableView.frame.width-30.0,y: 44.0/2-15/2,width:15.0,height: 15.0))
        returnCell = textCell!
        switch indexPath.section{
        case 0: //Map View
            switch indexPath.row {
            case 0: //Map Rotation
                switcherCell?.textLabel?.text = dataMapView[indexPath.row]
                returnCell = switcherCell!
                switchView.setOn((userDefaults?.bool(forKey: "mapRotation"))!, animated: false)
            case 1: //Auto Zoom
                switcherCell?.textLabel?.text = dataMapView[indexPath.row]
                returnCell = switcherCell!
                switchView.setOn((userDefaults?.bool(forKey: "autoZoom"))!, animated: false)
            case 2: //DarkMode
                switcherCell?.textLabel?.text = dataMapView[indexPath.row]
                returnCell = switcherCell!
                switchView.setOn((userDefaults?.bool(forKey: "darkMode"))!, animated: false)
            default:
                returnCell = textCell!
            }
        case 1: //Layers
            switch indexPath.row{
            case 0: //Lightning
                switcherCell?.textLabel?.text = dataLayers[indexPath.row]
                returnCell = switcherCell!
                switchView.setOn((userDefaults?.bool(forKey: "lightning"))!, animated: false)
            case 1: //Mesocyclones
                switcherCell?.textLabel?.text = dataLayers[indexPath.row]
                returnCell = switcherCell!
                switchView.setOn((userDefaults?.bool(forKey: "mesocyclones"))!, animated: false)
            case 2: //Shelters
                switcherCell?.textLabel?.text = dataLayers[indexPath.row]
                returnCell = switcherCell!
                switchView.setOn((userDefaults?.bool(forKey: "shelters"))!, animated: false)
            default:
                returnCell = textCell!
            }
        case 2: //Push Notification
            switch indexPath.row {
            case 0: //Notificatino On/Off
                switcherCell?.textLabel?.text = dataPushNotification[indexPath.row]
                returnCell = switcherCell!
                switchView.setOn((userDefaults?.bool(forKey: "pushNotification"))!, animated: false)
            case 1: //with dbZ
                switcherCell?.textLabel?.text = dataPushNotification[indexPath.row]
                returnCell = switcherCell!
                switchView.setOn((userDefaults?.bool(forKey: "withDBZ"))!, animated: false)
            case 2: //Intensity, Threshold
                stepperSliderCell!.addSubview(stepperSliderView)
                stepperSliderView.maxCount = UInt(intensity.count)
                stepperSliderView.index = UInt.init(bitPattern: (userDefaults?.integer(forKey: "intensityValue"))!)
                
                stepperSliderCellInfoLabel.text = dataPushNotification[indexPath.row]
                stepperSliderCell!.addSubview(stepperSliderCellInfoLabel)
                
                stepperSliderCellValueLabel.text = intensity[(userDefaults?.integer(forKey: "intensityValue"))!]
                stepperSliderCell!.addSubview(stepperSliderCellValueLabel)
                
                returnCell = stepperSliderCell!
            case 3: //Time before
                stepperSliderCell!.addSubview(stepperSliderView)
                stepperSliderView.maxCount = 9
                stepperSliderView.index = UInt.init(bitPattern: (userDefaults?.integer(forKey: "timeBeforeValue"))!)
                
                stepperSliderCellInfoLabel.text = dataPushNotification[indexPath.row]
                stepperSliderCell!.addSubview(stepperSliderCellInfoLabel)
                
                stepperSliderCellValueLabel.text = String(((userDefaults?.integer(forKey: "timeBeforeValue"))!+1)*5) + " min"
                stepperSliderCell!.addSubview(stepperSliderCellValueLabel)
                
                returnCell = stepperSliderCell!
            default:
                textCell?.textLabel?.text = dataPushNotification[indexPath.row]
                returnCell = textCell!
            }
        case 3: //About
            switch indexPath.row {
            case 3: //Push Token
                textCell?.addSubview(textInfoLabel)
                textInfoLabel.text = dataAboutLable[indexPath.row]
                textCell?.addSubview(textValueLabel)
                textValueLabel.text = dataAboutValue[indexPath.row]
                returnCell = textCell!
            
            default: //Feedack and About
                textCell?.addSubview(textInfoLabel)
                textInfoLabel.text = dataAboutLable[indexPath.row]
                textCell?.addSubview(linkArrow)
                if #available(iOS 13.0, *) {
                    linkArrow.image = UIImage.init(systemName: "chevron.right")
                } else {
                    // Fallback on earlier versions
                }
                returnCell = textCell!
            }
        default:
            returnCell = textCell!
        }
        
        //SwitchChange
        //To detect which switch changed: Fist Num: Selection, Secend Num: Row
        switchView.tag = Int(String(indexPath.section)+String(indexPath.row))!
        switchView.addTarget(self, action: #selector(switchChanged(_:)), for: .valueChanged) //Change here!!!
        switcherCell!.accessoryView = switchView
        
        //SliderChange
        stepperSliderView.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        
        return returnCell
    }
    
    //Cell Height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section == 2 && (indexPath.row == 2 || indexPath.row == 3)){
            return 100
        }
        return tableView.rowHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if (indexPath.section == 3 && indexPath.row == 0){
            if let url = URL(string: "https://github.com/v4lli/meteocool") {
                UIApplication.shared.open(url)
            }
        }
        if (indexPath.section == 3 && indexPath.row == 1){
            if let url = URL(string: "https://twitter.com/meteocool_de") {
                UIApplication.shared.open(url)
            }
        }
        if (indexPath.section == 3 && indexPath.row == 2){ //Feedback
            let mailAdress = "support@meteocool.com"
            if let url = URL(string: "mailto:\(mailAdress)") {
                UIApplication.shared.open(url)
            }
        }
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        switch sender.tag {
        //Map View
        case 0:
            userDefaults?.setValue(sender.isOn, forKey: "mapRotation")
            viewController?.webView.evaluateJavaScript("window.injectSettings({\"mapRotation\": \(sender.isOn)});")
        case 1:
            userDefaults?.setValue(sender.isOn, forKey: "autoZoom")
            viewController?.webView.evaluateJavaScript("window.injectSettings({\"zoomOnForeground\": \(sender.isOn)});")
        case 2:
            userDefaults?.setValue(sender.isOn, forKey: "darkMode")
            viewController?.webView.evaluateJavaScript("window.injectSettings({\"darkMode\": \(sender.isOn)});")
        //Layers
        case 10:
            userDefaults?.setValue(sender.isOn, forKey: "lightning")
            viewController?.webView.evaluateJavaScript("window.injectSettings({\"layerLightning\": \(sender.isOn)});")
        case 11:
            userDefaults?.setValue(sender.isOn, forKey: "mesocyclones")
            viewController?.webView.evaluateJavaScript("window.injectSettings({\"layerMesocyclones\": \(sender.isOn)});")
        case 12:
            userDefaults?.setValue(sender.isOn, forKey: "shelters")
            //viewController?.webView.evaluateJavaScript("window.injectSettings({\"layerShelters\": \(sender.isOn)});")
        //Push Notification
        case 20:
            userDefaults?.setValue(sender.isOn, forKey: "pushNotification")
            settingsTable.reloadData()
        case 22:
            userDefaults?.setValue(sender.isOn, forKey: "withDBZ")
        default:
            print("This not happen")
        }
    }
    
    @objc func sliderChanged(_ sender: StepSlider!){
        switch sender.maxCount {
        case 4: //Intensity
            userDefaults?.setValue(sender.index, forKey: "intensityValue")
            // 0 -> any
            // 1 -> light
            // 2 -> normal
            // 3 -> heavy
        case 9: //Time before
            userDefaults?.setValue(sender.index, forKey: "timeBeforeValue")
            //Value +1 *5 for minutes
        default:
            print ("Not happen")
        }
        settingsTable.reloadData()
    }
}
