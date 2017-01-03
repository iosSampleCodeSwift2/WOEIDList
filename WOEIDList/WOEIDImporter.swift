//
//  WOEIDImporter.swift
//  WOEIDList
//
//  Created by Daesub Kim on 2016. 11. 29..
//  Copyright © 2016년 DaesubKim. All rights reserved.
//

import Foundation

/*
extension String {
    func toDouble() -> Double {
        if let unwrappedNum = Double(self) {
            return unwrappedNum
        }
        else {
            print("Error converting \"" + self + "\" to Double")
            return 0.0
        }
    }
    func toInt64() -> Int64 {
        if let unwrappedNum = Int64(self) {
            return unwrappedNum
        }
        else {
            print("Error converting \"" + self + "\" to Int64")
            return 0
        }
    }
}

class WOEIDImporter: NSObject {
    var woeidList : [WOEID] = [WOEID]() // XML parser woeidList
    var woeid: WOEID! = nil // XML parser woeid
    var parser: NSXMLParser? = nil // XML parser
    var xmlData: String = "" // XML elementName data
    
    override init() {
        super.init()
        print("WOEIDImporter")
    }
    
    func loadData() -> [WOEID] {
        var woeidList:[WOEID] = [WOEID] ()
        woeidList.append(WOEID(code: 4118, city: "Toronto", country: "Canada", latitude: 43.64856, longitude: -79.385368))
        woeidList.append(WOEID(code: 44418, city: "London", country: "United Kingdom", latitude: 51.507702, longitude: -0.12797))
        woeidList.append(WOEID(code: 2487956, city: "San Francisco", country: "United States", latitude: 37.747398, longitude: -122.439217))
        woeidList.append(WOEID(code: 1132599, city: "Seoul", country: "South Korea", latitude: 37.557121, longitude: 126.977379))
        woeidList.append(WOEID(code: 718345, city: "Milan", country: "Italy", latitude: 45.4781, longitude: 9.17789))
        return woeidList
    }
    
}
*/
import Foundation

extension String {
    func toDouble() -> Double {
        if let unwrappedNum = Double(self) {
            return unwrappedNum
        }
        else {
            print("Error converting \"" + self + "\" to Double")
            return 0.0
        }
    }
    func toInt64() -> Int64 {
        if let unwrappedNum = Int64(self) {
            return unwrappedNum
        }
        else {
            print("Error converting \"" + self + "\" to Int64")
            return 0
        }
    }
}

class WOEIDImporter: NSObject, NSXMLParserDelegate {
    var woeidList : [WOEID] = [WOEID]() // XML parser woeidList
    var woeid: WOEID! = nil // XML parser woeid
    var parser: NSXMLParser? = nil // XML parser
    var xmlData: String = "" // XML elementName data
    
    override init() {
        super.init()
        print("WOEIDImporter")
    }
    
    func loadData() -> [WOEID] {
        var woeidList:[WOEID] = [WOEID] ()
        woeidList.append(WOEID(code: 4118, city: "Toronto", country: "Canada", latitude: 43.64856, longitude: -79.385368))
        woeidList.append(WOEID(code: 44418, city: "London", country: "United Kingdom", latitude: 51.507702, longitude: -0.12797))
        woeidList.append(WOEID(code: 2487956, city: "San Francisco", country: "United States", latitude: 37.747398, longitude: -122.439217))
        woeidList.append(WOEID(code: 1132599, city: "Seoul", country: "South Korea", latitude: 37.557121, longitude: 126.977379))
        woeidList.append(WOEID(code: 718345, city: "Milan", country: "Italy", latitude: 45.4781, longitude: 9.17789))
        return woeidList
    }
    
    
    
    /*** PList File ***/
    // PList file Load
    func loadDataFromPList(path: String) -> [WOEID] {
        var woeidList = [WOEID]()
        let plistPath = NSBundle.mainBundle().pathForResource(path, ofType: "plist") // load a local plist file
        if plistPath != nil {
            print("loadDataToPList \(path)")
            let array = NSArray(contentsOfFile: plistPath!) // read NSArray :: let Array
            let values = array as! [AnyObject]
            for item in values {
                let code : Int64 = (item[0] as! NSNumber).longLongValue // Long으로 Parsing
                let city : String = item[1] as! String
                let country : String = item[2] as! String
                let lat : Double = item[3] as! Double
                let lon : Double = item[4] as! Double
                //print("\(code),\(city),\(country),\(lat),\(lon)")
                woeidList.append(WOEID(code: code, city: city, country: country, latitude: lat, longitude: lon))
            }
        }
        return woeidList
    }
    
    // PList file Write
    func exportDataToPList(data: [WOEID], path: String) {
        print("exportDataToPList \(path)")
        let fileManager = NSFileManager.defaultManager()
        let dirs = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true) as [String] // Device에 있는 Directory를 찾음. (Document Dir이나 Temp Dir)
        let dir = dirs[0] // documents directory
        let newDir = dir.stringByAppendingString("data")
        print("exportDataToPList \(newDir)")
        
        // Dir 생성
        /*do {
         try fileManager.createDirectoryAtPath(newDir, withIntermediateDirectories: true, attributes:nil)
         } catch {
         print("Failed to create dir!!")
         print(error)
         }*/
        let plistPath = dir + "/" + path + ".plist" // 파일명 세팅
        
        if !fileManager.fileExistsAtPath(plistPath) {
            let array = NSMutableArray()
            for item in data {
                let itemArray = NSMutableArray() // Variable Array
                itemArray[0] = NSNumber(longLong: item.code)
                itemArray[1] = item.city
                itemArray[2] = item.country
                itemArray[3] = NSNumber(double: item.latitude)
                itemArray[4] = NSNumber(double: item.longitude)
                array.addObject(itemArray)
            }
            print(array)
            let result : Bool = array.writeToFile(plistPath, atomically: true)
            if result == true {
                print("File \(plistPath) file created")
            }
        }
    }
    
    
    
    /*** CSV File ***/
    // CSV file Load
    func loadDataFromCSV(path: String) -> [WOEID] {
        var woeidList:[WOEID] = [WOEID] ()
        
        let csvPath = NSBundle.mainBundle().pathForResource(path, ofType: "csv") // load a local csv file
        if csvPath != nil {
            let data = NSData(contentsOfFile: csvPath!) // 모르기 때문에 NSData로 통째로 받아들임.
            if let content = String(data: data!, encoding: NSUTF8StringEncoding) {
                // cleaning "\r" "\n\n" string first
                let newline = NSCharacterSet.newlineCharacterSet()
                let delimiter = NSCharacterSet(charactersInString: ",")
                var contentToParse = content.stringByReplacingOccurrencesOfString("\r", withString: "\n")
                contentToParse = contentToParse.stringByReplacingOccurrencesOfString("\n\n", withString: "\n")
                // get list of eachline
                let lines:[String] = contentToParse.componentsSeparatedByCharactersInSet(newline) as [String]
                // list of deliminated strings for each line
                for line in lines {
                    let values: [String] = line.componentsSeparatedByCharactersInSet(delimiter)
                    if values != [""] {
                        //print(values)
                        woeidList.append(WOEID(code: values[0].toInt64(), city: values[1], country: values[2], latitude: values[3].toDouble(), longitude: values[4].toDouble()))
                    }
                }
            }
        }
        
        return woeidList
    }
    // CSV file Write
    func exportDataToCSV(data: [WOEID], path: String) {
        print("exportDataToCSV \(path)")
        var contentsOfFile: String = ""
        for item in data {
            //print(item.description)
            contentsOfFile.appendContentsOf(item.description + "\n")
        }
        //print(contentsOfFile)
        let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as [String]
        let dir = dirs[0]
        let csvPath = dir + "/" + path + ".csv"
        do {
            try contentsOfFile.writeToFile(csvPath, atomically: true, encoding: NSUTF8StringEncoding)
            print("File \(csvPath) file created")
        } catch {
            print("Fail to create \(csvPath) file")
        }
    }
    
    
    /*** JSON File ***/
    // JSON file Load
    func loadDataFromJSON(path: String) -> [WOEID] {
        var woeidList = [WOEID]()
        let jsonPath = NSBundle.mainBundle().pathForResource(path, ofType: "json") // load a local json file
        if jsonPath != nil {
            print("loadDataFromJSON \(path)")
            let data = NSData(contentsOfFile: jsonPath!)
            //let error: NSError?
            do {
                if let decodedJson = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? [AnyObject] {
                    for item in decodedJson {
                        //print(item)
                        let code : Int64 = (item["Code"] as! NSNumber).longLongValue
                        let city : String = item["City"] as! String
                        let country : String = item["Country"] as! String
                        let lat : Double = item["Latitude"] as! Double
                        let lon : Double = item["Longitude"] as! Double
                        //print("\(code),\(city),\(country),\(lat),\(lon)")
                        woeidList.append(WOEID(code: code, city: city, country: country, latitude: lat, longitude: lon))
                    }
                }
            }
            catch {
                print(error)
            }
        }
        return woeidList
    }
    // JSON file Write
    func exportDataToJSON(data: [WOEID], path: String) {
        print("exportDataToJSON \(path)")
        
        let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as [String]
        let dir = dirs[0]
        let jsonPath = dir + "/" + path + ".json"
        
        let array = NSMutableArray()
        for item in data {
            let itemData = NSMutableDictionary() // Variable Dictionary
            itemData.addEntriesFromDictionary(["Code" : NSNumber(longLong: item.code)])
            itemData.addEntriesFromDictionary(["City" : NSString(string: item.city)])
            itemData.addEntriesFromDictionary(["Country" : NSString(string: item.country)])
            itemData.addEntriesFromDictionary(["Latitude" : NSNumber(double: item.latitude)])
            itemData.addEntriesFromDictionary(["Longitude" : NSNumber(double: item.longitude)])
            array.addObject(itemData)
        }
        //print(array)
        
        if let outputJson = NSOutputStream(toFileAtPath: jsonPath, append: false) {
            outputJson.open()
            var error: NSError?
            NSJSONSerialization.writeJSONObject(array, toStream: outputJson, options: NSJSONWritingOptions.PrettyPrinted, error: &error)
            // PrettyPrinted : JSON 파일을 우리가 보기쉽게 만들어줌.
            outputJson.close()
        }
    }
    
    
    
    /*** XML File ***/
    // XML file Write
    func exportDataToXML(data: [WOEID], path: String) {
        print("exportDataToXML \(path)")
        // using TBXML or KissXML to write XML for better implementation
        var contentsOfFile: String = "<ArrayOfWOEID>\n"
        for item in data {
            contentsOfFile.appendContentsOf(item.xmlFormat)
        }
        contentsOfFile += "</ArrayOfWOEID>"
        print(contentsOfFile)
        
        let dirs = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true) as [String]
        let dir = dirs[0]
        let xmlPath = dir + "/" + path + ".xml"
        do {
            try contentsOfFile.writeToFile(xmlPath, atomically: true, encoding: NSUTF8StringEncoding)
            print("File \(xmlPath) file created")
        } catch {
            print("Fail to create \(xmlPath) file")
        }
    }
    // XML file Load
    func loadDataFromXML(path: String) {
        //parser = NSXMLParser(contentsOfURL:(NSURL(string:path))!)! // fromURL
        let xmlPath = NSBundle.mainBundle().pathForResource(path, ofType: "xml")
        if xmlPath != nil {
            parser = NSXMLParser(contentsOfURL: NSURL(fileURLWithPath: xmlPath!))
        }
        if parser != nil {
            parser!.delegate = self
            parser!.parse()
        }
    }
    
    // it calls when it finds new element
    func parser(parser: NSXMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String])
    {
        xmlData = elementName
        if elementName == "WOEID" {
            woeid = WOEID()
        }
    }
    
    func parser(parser: NSXMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?)
    {
        xmlData = "" // reset
        if elementName == "WOEID" {
            //print(woeid.description)
            woeidList.append(woeid)
            //woeid = nil // delete
        }
    }
    
    // after find new character, it calls below
    func parser(parser: NSXMLParser, foundCharacters string: String)
    {
        if woeid != nil {
            if xmlData == "Code" {
                //print("Code" + string)
                woeid.code = string.toInt64()
            } else if xmlData == "City" {
                //print("City" + string)
                woeid.city = string
            } else if xmlData == "Country" {
                //print("Country" + string)
                woeid.country = string
            } else if xmlData == "Latitude" {
                //print("Latitude" + string)
                woeid.latitude = string.toDouble()
            } else if xmlData == "Longitude" {
                //print("Longitude" + string)
                woeid.longitude = string.toDouble()
            }
        }
    }
    
    func parser(parser: NSXMLParser, parseErrorOccurred parseError: NSError) {
        NSLog("failure error: %@", parseError)
    }
    
}

