
import Foundation

protocol CoinManagerDelegate {
    func didUpdateCoin (price: String, currency: String)
    func didFailWithError (error: Error)
}


struct CoinManager {
    
    var delegate: CoinManagerDelegate?
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "F46D7C8C-9381-4B3D-836F-61D906437CB9"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    //MARK: - getCoinPrice
    
    func getCoinPrice (for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    let bitcoinPrice = self.parseJSON(safeData)
                    let priceString = String(format: "%.2f", bitcoinPrice!)
                    self.delegate?.didUpdateCoin (price: priceString, currency: currency)
                }
                
            }
            task.resume()
        }
        
    }
    
    //MARK: - parseJSON
    
    func parseJSON(_ coinData: Data) -> Double? {
        let decoder = JSONDecoder ()
        do {
            let decodeData = try decoder.decode(CoinData.self, from: coinData)
            
            let currentRate = decodeData.rate
            print (currentRate)
            return currentRate
            
        } catch {
            print (error)
            return nil
        }
    }
}
