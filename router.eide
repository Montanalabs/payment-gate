#! Router — the route selector is ITSELF untrusted, so it must cross extract<Endpoint>
#! (a closed set) before it can drive control flow. A request cannot route itself to an
#! arbitrary handler; an unknown route is rejected at the boundary.
import payments
import refunds

type Endpoint = Payments | Refunds

fn route() {
  let sel = fetch<route>  # UNTRUSTED route selector — tainted
  quarantined { let ep = extract<Endpoint>(sel) }  # only a fixed endpoint crosses
  match ep {
    Payments => { payHandle() }
    Refunds => { refundHandle() }
  }
}
