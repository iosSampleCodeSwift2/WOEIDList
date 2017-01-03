import Foundation
import MapKit

class WOEID : NSObject, MKAnnotation {
    var title: String? { // MKAnnotation
        return description
    }
    var subtitle: String? { // MKAnnotation
        return description
    }
    
    var code: Int64 = 0
    var city: String = ""
    var country: String = ""
    var latitude: Double = 0.0 // MKAnnotation
    var longitude: Double = 0.0 // MKAnnotation
    
    var coordinate: CLLocationCoordinate2D { // MKAnnotation
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    override init() {
    }
    
    init(coder aDecoder: NSCoder!) {
        self.code = aDecoder.decodeInt64ForKey("Code") as Int64
        self.city = aDecoder.decodeObjectForKey("City") as! String
        self.country = aDecoder.decodeObjectForKey("Country") as! String
        self.latitude = aDecoder.decodeDoubleForKey("Latitude") as Double
        self.longitude = aDecoder.decodeDoubleForKey("Longitude") as Double
    }
    
    init(code: Int64, city: String, country: String, latitude: Double, longitude: Double) {
        self.code = code
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
    
    func encodeWithCoder(coder: NSCoder!) {
        coder.encodeInt64(self.code, forKey: "Code")
        coder.encodeObject(self.city, forKey: "City")
        coder.encodeObject(self.country, forKey: "Country")
        coder.encodeDouble(self.latitude, forKey: "Latitude")
        coder.encodeDouble(self.longitude, forKey: "Longitude")
    }
    
    override var description : String {
        get {
            return "\(code),\(city),\(country),\(latitude),\(longitude)"
        }
    }
    
    var xmlFormat : String {
        get {
            /*
             let root = NSXMLElement(name: "WOEID")
             let xml = NSXMLDocument(rootElement: root)
             root.addChile(NSXMLElement(name: "Code", stringValue: "\(code)"))
             root.addChile(NSXMLElement(name: "City", stringValue: "\(city)"))
             root.addChile(NSXMLElement(name: "Country", stringValue: "\(country)"))
             root.addChile(NSXMLElement(name: "Latitude", stringValue: "\(latitude)"))
             root.addChile(NSXMLElement(name: "Longitude", stringValue: "\(longitude)"))
             return xml.XMLString
             */
            var xmlString = "<WOEID>\n"
            xmlString += "<Code>\(self.code)</Code>\n"
            xmlString += "<City>\(self.city)</City>\n"
            xmlString += "<Country>\(self.country)</Country>\n"
            xmlString += "<Latitude>\(self.latitude)</Latitude>\n"
            xmlString += "<Longitude>\(self.longitude)</Longitude>\n"
            xmlString += "</WOEID>\n"
            return xmlString
        }
    }
    
}