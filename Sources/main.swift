import Alamofire
import Foundation
import Lark

let client = HelloWorldServiceClient()

// This call returns an array of strings.
do {
    let result = try client.sayHello(SayHello(name: "World", times: 2))
    print(String(describing: result.sayHelloResult?.string))
} catch {
    print("Error: \(error)")
}

// This call shows optional parameters; `name` is defined as `String?`
do {
    let result = try client.sayHello(SayHello(name: nil, times: 1))
    print(String(describing: result.sayHelloResult?.string))
} catch {
    print("Error: \(error)")
}

// This call returns nothing.
do {
    let result = try client.sayNothing(SayNothing())
    print(result)
} catch {
    print("Error: \(error)")
}

// This call has an optional result and will return something.
do {
    let result = try client.sayMaybeSomething(SayMaybeSomething(name: "Bouke"))
    print(String(describing: result.sayMaybeSomethingResult))
} catch {
    print("Error: \(error)")
}

// This call has an optional result and will return nothing.
do {
    let result = try client.sayMaybeNothing(SayMaybeNothing(name: "Bouke"))
    print(String(describing: result.sayMaybeNothingResult))
} catch {
    print("Error: \(error)")
}

// This call takes an enum value.
do {
    let result = try client.greet(Greet(partOfDay: .evening))
    print(String(describing: result.greetResult))
} catch {
    print("Error: \(error)")
}

// This call takes an array of enums.
do {
    let result = try client.greets(Greets(partOfDays: PartOfDayArrayType(partOfDay: [.morning, .night])))
    print(String(describing: result.greetsResult))
} catch {
    print("Error: \(error)")
}

// This call will fault.
do {
    _ = try client.fault(Lark_Example.Fault())
} catch let fault as Lark.Fault {
    print("Service generated a Fault: \(fault)")
} catch {
    print("Error: \(error)")
}

// Set HTTP headers

struct UsernamePasswordAdapter: RequestAdapter {
    private let encoded: String

    init(encoded: String) {
        self.encoded = encoded
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.setValue("Basic " + encoded, forHTTPHeaderField: "Authorization")
        return urlRequest
    }
}

client.sessionManager.adapter = UsernamePasswordAdapter(encoded: "QWxhZGRpbjpPcGVuU2VzYW1l")
do {
    try client.secret(Secret())
    print("Successfully authorized for secret page")
} catch {
    print("Error: \(error)")
}
client.sessionManager.adapter = nil

// Set SOAP headers
client.headers.append(Header(name: QualifiedName(uri: "http://tempuri.org/", localName: "Token"), value: "QWxhZGRpbjpPcGVuU2VzYW1l"))
do {
    _ = try client.secret(Secret())
    print("Successfully authorized for secret page")
} catch {
    print("Error: \(error)")
}
