import Evergreen
import Foundation
import LarkRuntime

getLogger("Lark").logLevel = .warning


// HelloWorld
// Before you can run this example, you need to start the included Python server;
//
//     pip install spyne
//     python Sources/Demo/server.py
let hwsClient = HelloWorldServiceClient()

// This call returns an array of strings.
let result0 = try hwsClient.sayHello(SayHello(name: "World", times: 2))
print(result0.sayHelloResult.string)

// This call shows optional parameters; `name` is defined as `String?`.
let result1 = try hwsClient.sayHello(SayHello(name: nil, times: 1))
print(result1.sayHelloResult.string)

// This call returns nothing.
let result2 = try hwsClient.sayNothing(SayNothing())
print(result2)

// This call has an optional result and will return something.
let result3 = try hwsClient.sayMaybeSomething(SayMaybeSomething(name: "Bouke"))
print(result3.sayMaybeSomethingResult ?? "__nil__")

// This call has an optional result and will return nothing.
let result4 = try hwsClient.sayMaybeNothing(SayMaybeNothing(name: "Bouke"))
print(result4.sayMaybeNothingResult ?? "__nil__")

// This call takes an enum value.
let result5 = try hwsClient.greet(Greet(partOfDay: .evening))
print(result5)

// This call takes an array of enums.
let result6 = try hwsClient.greets(Greets(partOfDays: PartOfDayArrayType(partOfDay: [.morning, .night])))
print(result6.greetsResult.string)

// This call will fault.
do { 
    let result = try hwsClient.fault(LarkExample.Fault())
    print(result)
} catch let fault as LarkRuntime.Fault {
    print("Server generated a Fault: \(fault)")
}

// Set HTTP headers
let transport = hwsClient.channel.transport as! HTTPTransport
transport.headers["Authorization"] = "Basic QWxhZGRpbjpPcGVuU2VzYW1l"
_ = try hwsClient.secret(Secret())

// Set SOAP headers
transport.headers = [:]
hwsClient.headers.append((QualifiedName(uri: "http://tempuri.org/", localName: "Token"), "QWxhZGRpbjpPcGVuU2VzYW1l"))
_ = try hwsClient.secret(Secret())
