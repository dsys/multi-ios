//  This file was automatically generated and should not be edited.

import Apollo

public enum ETHEREUM_NETWORK: RawRepresentable, Equatable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case mainnet
  case ropsten
  case kovan
  case rinkeby
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "MAINNET": self = .mainnet
      case "ROPSTEN": self = .ropsten
      case "KOVAN": self = .kovan
      case "RINKEBY": self = .rinkeby
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .mainnet: return "MAINNET"
      case .ropsten: return "ROPSTEN"
      case .kovan: return "KOVAN"
      case .rinkeby: return "RINKEBY"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: ETHEREUM_NETWORK, rhs: ETHEREUM_NETWORK) -> Bool {
    switch (lhs, rhs) {
      case (.mainnet, .mainnet): return true
      case (.ropsten, .ropsten): return true
      case (.kovan, .kovan): return true
      case (.rinkeby, .rinkeby): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }
}

public final class TransactionFeedQuery: GraphQLQuery {
  public let operationDefinition =
    "query TransactionFeed($address: EthereumAddressString!, $network: ETHEREUM_NETWORK) {\n  ethereumAddress(address: $address, network: $network) {\n    __typename\n    transactions {\n      __typename\n      from {\n        __typename\n        hex\n      }\n      to {\n        __typename\n        hex\n      }\n      value {\n        __typename\n        display(precision: 2)\n        ether\n      }\n      status\n      hash\n      gas\n      gasPrice {\n        __typename\n        ether\n        display(precision: 2)\n      }\n      gasUsed\n      cumulativeGasUsed\n      contractAddress {\n        __typename\n        hex\n      }\n      block {\n        __typename\n        number\n        timestamp\n      }\n    }\n  }\n}"

  public var address: String
  public var network: ETHEREUM_NETWORK?

  public init(address: String, network: ETHEREUM_NETWORK? = nil) {
    self.address = address
    self.network = network
  }

  public var variables: GraphQLMap? {
    return ["address": address, "network": network]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Query"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("ethereumAddress", arguments: ["address": GraphQLVariable("address"), "network": GraphQLVariable("network")], type: .object(EthereumAddress.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(ethereumAddress: EthereumAddress? = nil) {
      self.init(unsafeResultMap: ["__typename": "Query", "ethereumAddress": ethereumAddress.flatMap { (value: EthereumAddress) -> ResultMap in value.resultMap }])
    }

    public var ethereumAddress: EthereumAddress? {
      get {
        return (resultMap["ethereumAddress"] as? ResultMap).flatMap { EthereumAddress(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "ethereumAddress")
      }
    }

    public struct EthereumAddress: GraphQLSelectionSet {
      public static let possibleTypes = ["EthereumAddress"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("transactions", type: .list(.nonNull(.object(Transaction.selections)))),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(transactions: [Transaction]? = nil) {
        self.init(unsafeResultMap: ["__typename": "EthereumAddress", "transactions": transactions.flatMap { (value: [Transaction]) -> [ResultMap] in value.map { (value: Transaction) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var transactions: [Transaction]? {
        get {
          return (resultMap["transactions"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Transaction] in value.map { (value: ResultMap) -> Transaction in Transaction(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Transaction]) -> [ResultMap] in value.map { (value: Transaction) -> ResultMap in value.resultMap } }, forKey: "transactions")
        }
      }

      public struct Transaction: GraphQLSelectionSet {
        public static let possibleTypes = ["EthereumTransaction"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("from", type: .object(From.selections)),
          GraphQLField("to", type: .object(To.selections)),
          GraphQLField("value", type: .object(Value.selections)),
          GraphQLField("status", type: .scalar(Bool.self)),
          GraphQLField("hash", type: .nonNull(.scalar(String.self))),
          GraphQLField("gas", type: .scalar(Int.self)),
          GraphQLField("gasPrice", type: .object(GasPrice.selections)),
          GraphQLField("gasUsed", type: .scalar(Int.self)),
          GraphQLField("cumulativeGasUsed", type: .scalar(Int.self)),
          GraphQLField("contractAddress", type: .object(ContractAddress.selections)),
          GraphQLField("block", type: .object(Block.selections)),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(from: From? = nil, to: To? = nil, value: Value? = nil, status: Bool? = nil, hash: String, gas: Int? = nil, gasPrice: GasPrice? = nil, gasUsed: Int? = nil, cumulativeGasUsed: Int? = nil, contractAddress: ContractAddress? = nil, block: Block? = nil) {
          self.init(unsafeResultMap: ["__typename": "EthereumTransaction", "from": from.flatMap { (value: From) -> ResultMap in value.resultMap }, "to": to.flatMap { (value: To) -> ResultMap in value.resultMap }, "value": value.flatMap { (value: Value) -> ResultMap in value.resultMap }, "status": status, "hash": hash, "gas": gas, "gasPrice": gasPrice.flatMap { (value: GasPrice) -> ResultMap in value.resultMap }, "gasUsed": gasUsed, "cumulativeGasUsed": cumulativeGasUsed, "contractAddress": contractAddress.flatMap { (value: ContractAddress) -> ResultMap in value.resultMap }, "block": block.flatMap { (value: Block) -> ResultMap in value.resultMap }])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var from: From? {
          get {
            return (resultMap["from"] as? ResultMap).flatMap { From(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "from")
          }
        }

        public var to: To? {
          get {
            return (resultMap["to"] as? ResultMap).flatMap { To(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "to")
          }
        }

        public var value: Value? {
          get {
            return (resultMap["value"] as? ResultMap).flatMap { Value(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "value")
          }
        }

        public var status: Bool? {
          get {
            return resultMap["status"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "status")
          }
        }

        public var hash: String {
          get {
            return resultMap["hash"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "hash")
          }
        }

        public var gas: Int? {
          get {
            return resultMap["gas"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "gas")
          }
        }

        public var gasPrice: GasPrice? {
          get {
            return (resultMap["gasPrice"] as? ResultMap).flatMap { GasPrice(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "gasPrice")
          }
        }

        public var gasUsed: Int? {
          get {
            return resultMap["gasUsed"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "gasUsed")
          }
        }

        public var cumulativeGasUsed: Int? {
          get {
            return resultMap["cumulativeGasUsed"] as? Int
          }
          set {
            resultMap.updateValue(newValue, forKey: "cumulativeGasUsed")
          }
        }

        public var contractAddress: ContractAddress? {
          get {
            return (resultMap["contractAddress"] as? ResultMap).flatMap { ContractAddress(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "contractAddress")
          }
        }

        public var block: Block? {
          get {
            return (resultMap["block"] as? ResultMap).flatMap { Block(unsafeResultMap: $0) }
          }
          set {
            resultMap.updateValue(newValue?.resultMap, forKey: "block")
          }
        }

        public struct From: GraphQLSelectionSet {
          public static let possibleTypes = ["EthereumAddress"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("hex", type: .nonNull(.scalar(String.self))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(hex: String) {
            self.init(unsafeResultMap: ["__typename": "EthereumAddress", "hex": hex])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var hex: String {
            get {
              return resultMap["hex"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "hex")
            }
          }
        }

        public struct To: GraphQLSelectionSet {
          public static let possibleTypes = ["EthereumAddress"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("hex", type: .nonNull(.scalar(String.self))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(hex: String) {
            self.init(unsafeResultMap: ["__typename": "EthereumAddress", "hex": hex])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var hex: String {
            get {
              return resultMap["hex"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "hex")
            }
          }
        }

        public struct Value: GraphQLSelectionSet {
          public static let possibleTypes = ["EthereumValue"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("display", arguments: ["precision": 2], type: .nonNull(.scalar(String.self))),
            GraphQLField("ether", type: .nonNull(.scalar(String.self))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(display: String, ether: String) {
            self.init(unsafeResultMap: ["__typename": "EthereumValue", "display": display, "ether": ether])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var display: String {
            get {
              return resultMap["display"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "display")
            }
          }

          public var ether: String {
            get {
              return resultMap["ether"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "ether")
            }
          }
        }

        public struct GasPrice: GraphQLSelectionSet {
          public static let possibleTypes = ["EthereumValue"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("ether", type: .nonNull(.scalar(String.self))),
            GraphQLField("display", arguments: ["precision": 2], type: .nonNull(.scalar(String.self))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(ether: String, display: String) {
            self.init(unsafeResultMap: ["__typename": "EthereumValue", "ether": ether, "display": display])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var ether: String {
            get {
              return resultMap["ether"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "ether")
            }
          }

          public var display: String {
            get {
              return resultMap["display"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "display")
            }
          }
        }

        public struct ContractAddress: GraphQLSelectionSet {
          public static let possibleTypes = ["EthereumAddress"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("hex", type: .nonNull(.scalar(String.self))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(hex: String) {
            self.init(unsafeResultMap: ["__typename": "EthereumAddress", "hex": hex])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var hex: String {
            get {
              return resultMap["hex"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "hex")
            }
          }
        }

        public struct Block: GraphQLSelectionSet {
          public static let possibleTypes = ["EthereumBlock"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("number", type: .nonNull(.scalar(Int.self))),
            GraphQLField("timestamp", type: .scalar(Int.self)),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(number: Int, timestamp: Int? = nil) {
            self.init(unsafeResultMap: ["__typename": "EthereumBlock", "number": number, "timestamp": timestamp])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var number: Int {
            get {
              return resultMap["number"]! as! Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "number")
            }
          }

          public var timestamp: Int? {
            get {
              return resultMap["timestamp"] as? Int
            }
            set {
              resultMap.updateValue(newValue, forKey: "timestamp")
            }
          }
        }
      }
    }
  }
}