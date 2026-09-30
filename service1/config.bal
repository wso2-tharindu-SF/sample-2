import ballerina/os;

// service2's base address. The platform injects SERVICE2_URL at deploy time;
// the fallback below lets this component start with no required env vars.
configurable string service2Url = os:getEnv("SERVICE2_URL") != "" ? os:getEnv("SERVICE2_URL") : "http://localhost:9090";

// An injected address may end in `/` — strip it so a resource path (which
// always starts with `/`) joins onto it with exactly one separator.
function baseUrl(string address) returns string {
    if address.endsWith("/") {
        return address.substring(0, address.length() - 1);
    }
    return address;
}
