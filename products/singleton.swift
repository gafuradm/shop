import Foundation
import Foil

class AppDefaults {
    static let shared = AppDefaults()
    
    @WrappedDefault(key: "shoppingList")
    var shoppingList: [String] = []
    
    private init() {}
}
