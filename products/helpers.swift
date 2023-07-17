import Foundation

struct Product: Codable {
    let name: String
    let amount: Int
    let selected: Bool
    let price: Double
}

class JSONHelper {
    static func convertToJSONString(_ data: Product) -> String? {
        let encoder = JSONEncoder()
        let jsonData = try? encoder.encode(data)
        return String(data: jsonData!, encoding: .utf8)
    }

    static func convertJSON(_ jsonString: String) -> Product? {
        let decoder = JSONDecoder()
        let jsonData = Data(jsonString.utf8)
        let data = try? decoder.decode(Product.self, from: jsonData)
        return data
    }

}
