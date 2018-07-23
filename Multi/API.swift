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

public final class CheckUsernameAvailableMutation: GraphQLMutation {
  public let operationDefinition =
    "mutation CheckUsernameAvailable($username: String!) {\n  checkUsernameAvailable(input: {username: $username}) {\n    __typename\n    ok\n    message\n  }\n}"

  public var username: String

  public init(username: String) {
    self.username = username
  }

  public var variables: GraphQLMap? {
    return ["username": username]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("checkUsernameAvailable", arguments: ["input": ["username": GraphQLVariable("username")]], type: .object(CheckUsernameAvailable.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(checkUsernameAvailable: CheckUsernameAvailable? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "checkUsernameAvailable": checkUsernameAvailable.flatMap { (value: CheckUsernameAvailable) -> ResultMap in value.resultMap }])
    }

    public var checkUsernameAvailable: CheckUsernameAvailable? {
      get {
        return (resultMap["checkUsernameAvailable"] as? ResultMap).flatMap { CheckUsernameAvailable(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "checkUsernameAvailable")
      }
    }

    public struct CheckUsernameAvailable: GraphQLSelectionSet {
      public static let possibleTypes = ["CheckUsernameAvailablePayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("ok", type: .scalar(Bool.self)),
        GraphQLField("message", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(ok: Bool? = nil, message: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "CheckUsernameAvailablePayload", "ok": ok, "message": message])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var ok: Bool? {
        get {
          return resultMap["ok"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "ok")
        }
      }

      public var message: String? {
        get {
          return resultMap["message"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "message")
        }
      }
    }
  }
}

public final class StartPhoneNumberVerificationMutation: GraphQLMutation {
  public let operationDefinition =
    "mutation StartPhoneNumberVerification($phoneNumber: String!) {\n  startPhoneNumberVerification(input: {phoneNumber: $phoneNumber}) {\n    __typename\n    ok\n    message\n  }\n}"

  public var phoneNumber: String

  public init(phoneNumber: String) {
    self.phoneNumber = phoneNumber
  }

  public var variables: GraphQLMap? {
    return ["phoneNumber": phoneNumber]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("startPhoneNumberVerification", arguments: ["input": ["phoneNumber": GraphQLVariable("phoneNumber")]], type: .object(StartPhoneNumberVerification.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(startPhoneNumberVerification: StartPhoneNumberVerification? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "startPhoneNumberVerification": startPhoneNumberVerification.flatMap { (value: StartPhoneNumberVerification) -> ResultMap in value.resultMap }])
    }

    public var startPhoneNumberVerification: StartPhoneNumberVerification? {
      get {
        return (resultMap["startPhoneNumberVerification"] as? ResultMap).flatMap { StartPhoneNumberVerification(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "startPhoneNumberVerification")
      }
    }

    public struct StartPhoneNumberVerification: GraphQLSelectionSet {
      public static let possibleTypes = ["StartPhoneNumberVerificationPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("ok", type: .scalar(Bool.self)),
        GraphQLField("message", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(ok: Bool? = nil, message: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "StartPhoneNumberVerificationPayload", "ok": ok, "message": message])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var ok: Bool? {
        get {
          return resultMap["ok"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "ok")
        }
      }

      public var message: String? {
        get {
          return resultMap["message"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "message")
        }
      }
    }
  }
}

public final class CheckPhoneNumberVerificationMutation: GraphQLMutation {
  public let operationDefinition =
    "mutation CheckPhoneNumberVerification($phoneNumber: String!, $verificationCode: String!) {\n  checkPhoneNumberVerification(input: {phoneNumber: $phoneNumber, verificationCode: $verificationCode}) {\n    __typename\n    ok\n    message\n    phoneNumber {\n      __typename\n      hashedPhoneNumber\n    }\n    phoneNumberToken\n    phoneNumberTokenExpires\n  }\n}"

  public var phoneNumber: String
  public var verificationCode: String

  public init(phoneNumber: String, verificationCode: String) {
    self.phoneNumber = phoneNumber
    self.verificationCode = verificationCode
  }

  public var variables: GraphQLMap? {
    return ["phoneNumber": phoneNumber, "verificationCode": verificationCode]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("checkPhoneNumberVerification", arguments: ["input": ["phoneNumber": GraphQLVariable("phoneNumber"), "verificationCode": GraphQLVariable("verificationCode")]], type: .object(CheckPhoneNumberVerification.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(checkPhoneNumberVerification: CheckPhoneNumberVerification? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "checkPhoneNumberVerification": checkPhoneNumberVerification.flatMap { (value: CheckPhoneNumberVerification) -> ResultMap in value.resultMap }])
    }

    public var checkPhoneNumberVerification: CheckPhoneNumberVerification? {
      get {
        return (resultMap["checkPhoneNumberVerification"] as? ResultMap).flatMap { CheckPhoneNumberVerification(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "checkPhoneNumberVerification")
      }
    }

    public struct CheckPhoneNumberVerification: GraphQLSelectionSet {
      public static let possibleTypes = ["CheckPhoneNumberVerificationPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("ok", type: .scalar(Bool.self)),
        GraphQLField("message", type: .scalar(String.self)),
        GraphQLField("phoneNumber", type: .object(PhoneNumber.selections)),
        GraphQLField("phoneNumberToken", type: .scalar(String.self)),
        GraphQLField("phoneNumberTokenExpires", type: .scalar(String.self)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(ok: Bool? = nil, message: String? = nil, phoneNumber: PhoneNumber? = nil, phoneNumberToken: String? = nil, phoneNumberTokenExpires: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "CheckPhoneNumberVerificationPayload", "ok": ok, "message": message, "phoneNumber": phoneNumber.flatMap { (value: PhoneNumber) -> ResultMap in value.resultMap }, "phoneNumberToken": phoneNumberToken, "phoneNumberTokenExpires": phoneNumberTokenExpires])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var ok: Bool? {
        get {
          return resultMap["ok"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "ok")
        }
      }

      public var message: String? {
        get {
          return resultMap["message"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "message")
        }
      }

      public var phoneNumber: PhoneNumber? {
        get {
          return (resultMap["phoneNumber"] as? ResultMap).flatMap { PhoneNumber(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "phoneNumber")
        }
      }

      public var phoneNumberToken: String? {
        get {
          return resultMap["phoneNumberToken"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "phoneNumberToken")
        }
      }

      public var phoneNumberTokenExpires: String? {
        get {
          return resultMap["phoneNumberTokenExpires"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "phoneNumberTokenExpires")
        }
      }

      public struct PhoneNumber: GraphQLSelectionSet {
        public static let possibleTypes = ["PhoneNumber"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("hashedPhoneNumber", type: .nonNull(.scalar(String.self))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(hashedPhoneNumber: String) {
          self.init(unsafeResultMap: ["__typename": "PhoneNumber", "hashedPhoneNumber": hashedPhoneNumber])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var hashedPhoneNumber: String {
          get {
            return resultMap["hashedPhoneNumber"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "hashedPhoneNumber")
          }
        }
      }
    }
  }
}

public final class CreateIdentityContractMutation: GraphQLMutation {
  public let operationDefinition =
    "mutation CreateIdentityContract($username: String!, $phoneNumberToken: String!, $managerAddresses: [EthereumAddressString!]!, $network: ETHEREUM_NETWORK, $passphraseRecoveryHash: String, $socialRecoveryAddresses: [EthereumAddressString!]) {\n  createIdentityContract(input: {username: $username, phoneNumberToken: $phoneNumberToken, managerAddresses: $managerAddresses, network: $network, passphraseRecoveryHash: $passphraseRecoveryHash, socialRecoveryAddresses: $socialRecoveryAddresses}) {\n    __typename\n    ok\n    message\n    identityContract {\n      __typename\n      address {\n        __typename\n        display\n      }\n    }\n  }\n}"

  public var username: String
  public var phoneNumberToken: String
  public var managerAddresses: [String]
  public var network: ETHEREUM_NETWORK?
  public var passphraseRecoveryHash: String?
  public var socialRecoveryAddresses: [String]?

  public init(username: String, phoneNumberToken: String, managerAddresses: [String], network: ETHEREUM_NETWORK? = nil, passphraseRecoveryHash: String? = nil, socialRecoveryAddresses: [String]?) {
    self.username = username
    self.phoneNumberToken = phoneNumberToken
    self.managerAddresses = managerAddresses
    self.network = network
    self.passphraseRecoveryHash = passphraseRecoveryHash
    self.socialRecoveryAddresses = socialRecoveryAddresses
  }

  public var variables: GraphQLMap? {
    return ["username": username, "phoneNumberToken": phoneNumberToken, "managerAddresses": managerAddresses, "network": network, "passphraseRecoveryHash": passphraseRecoveryHash, "socialRecoveryAddresses": socialRecoveryAddresses]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes = ["Mutation"]

    public static let selections: [GraphQLSelection] = [
      GraphQLField("createIdentityContract", arguments: ["input": ["username": GraphQLVariable("username"), "phoneNumberToken": GraphQLVariable("phoneNumberToken"), "managerAddresses": GraphQLVariable("managerAddresses"), "network": GraphQLVariable("network"), "passphraseRecoveryHash": GraphQLVariable("passphraseRecoveryHash"), "socialRecoveryAddresses": GraphQLVariable("socialRecoveryAddresses")]], type: .object(CreateIdentityContract.selections)),
    ]

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createIdentityContract: CreateIdentityContract? = nil) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createIdentityContract": createIdentityContract.flatMap { (value: CreateIdentityContract) -> ResultMap in value.resultMap }])
    }

    public var createIdentityContract: CreateIdentityContract? {
      get {
        return (resultMap["createIdentityContract"] as? ResultMap).flatMap { CreateIdentityContract(unsafeResultMap: $0) }
      }
      set {
        resultMap.updateValue(newValue?.resultMap, forKey: "createIdentityContract")
      }
    }

    public struct CreateIdentityContract: GraphQLSelectionSet {
      public static let possibleTypes = ["CreateIdentityContractPayload"]

      public static let selections: [GraphQLSelection] = [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("ok", type: .scalar(Bool.self)),
        GraphQLField("message", type: .scalar(String.self)),
        GraphQLField("identityContract", type: .object(IdentityContract.selections)),
      ]

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(ok: Bool? = nil, message: String? = nil, identityContract: IdentityContract? = nil) {
        self.init(unsafeResultMap: ["__typename": "CreateIdentityContractPayload", "ok": ok, "message": message, "identityContract": identityContract.flatMap { (value: IdentityContract) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var ok: Bool? {
        get {
          return resultMap["ok"] as? Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "ok")
        }
      }

      public var message: String? {
        get {
          return resultMap["message"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "message")
        }
      }

      public var identityContract: IdentityContract? {
        get {
          return (resultMap["identityContract"] as? ResultMap).flatMap { IdentityContract(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "identityContract")
        }
      }

      public struct IdentityContract: GraphQLSelectionSet {
        public static let possibleTypes = ["EthereumIdentityContract"]

        public static let selections: [GraphQLSelection] = [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("address", type: .nonNull(.object(Address.selections))),
        ]

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(address: Address) {
          self.init(unsafeResultMap: ["__typename": "EthereumIdentityContract", "address": address.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var address: Address {
          get {
            return Address(unsafeResultMap: resultMap["address"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "address")
          }
        }

        public struct Address: GraphQLSelectionSet {
          public static let possibleTypes = ["EthereumAddress"]

          public static let selections: [GraphQLSelection] = [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("display", type: .nonNull(.scalar(String.self))),
          ]

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(display: String) {
            self.init(unsafeResultMap: ["__typename": "EthereumAddress", "display": display])
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
        }
      }
    }
  }
}