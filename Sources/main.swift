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
try hwsClient.sayHello(SayHello(name: "World", times: 2)) {
    print($0.value?.sayHelloResult.string ?? "__error__")
}

// This call shows optional parameters; `name` is defined as `String?`.
try hwsClient.sayHello(SayHello(name: nil, times: 1)) {
    print($0.value?.sayHelloResult.string ?? "__error__")
}

// This call returns nothing.
try hwsClient.sayNothing(SayNothing()) {
    print($0)
}

// This call has an optional result and will return something.
try hwsClient.sayMaybeSomething(SayMaybeSomething(name: "Bouke")) {
    print($0.map { $0.sayMaybeSomethingResult } )
}

// This call has an optional result and will return nothing.
try hwsClient.sayMaybeNothing(SayMaybeNothing(name: "Bouke")) {
    print($0.map { $0.sayMaybeNothingResult } )
}

// This call takes an enum value.
try hwsClient.greet(Greet(partOfDay: .evening)) {
    print($0)
}

// This call takes an array of enums.
try hwsClient.greets(Greets(partOfDays: PartOfDayArrayType(partOfDay: [.morning, .night]))) {
    print($0.value?.greetsResult.string ?? "__error__")
}

// This call will fault.
try hwsClient.fault(Lark_Example.Fault()) {
    do {
        _ = try $0.resolve()
    } catch let fault as LarkRuntime.Fault {
        // handle server faults here
        print("Server generated a Fault: \(fault)")
    } catch {
        // handle other errors (e.g connection) here
    }
}

// Set HTTP headers
let transport = hwsClient.channel.transport as! HTTPTransport
transport.headers = ["Authorization": "Basic QWxhZGRpbjpPcGVuU2VzYW1l"]
try hwsClient.secret(Secret()) {
    do {
        _ = try $0.resolve()
        print("Successfully authorized for secret page")
    } catch {
        print("Error was caught: \(error)")
    }
}

// Set SOAP headers
transport.headers = [:]
hwsClient.headers.append((QualifiedName(uri: "http://tempuri.org/", localName: "Token"), "QWxhZGRpbjpPcGVuU2VzYW1l"))
try hwsClient.secret(Secret()) {
    do {
        _ = try $0.resolve()
        print("Successfully authorized for secret page")
    } catch {
        print("Error was caught: \(error)")
    }
}
