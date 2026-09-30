# sample-2 — PRD

## Problem Statement

Teams that need a single summary figure from a catalog of scored records
today have to fetch every record themselves and compute the aggregate by
hand, which duplicates the same arithmetic in every caller and makes it hard
to verify that a service behaves correctly both when data is present and when
it is not. There is no small, dependable service that hands back one number —
the average score — while keeping the underlying catalog and its state
(populated or emptied) fully under an operator's control.

## Solution

Two cooperating services. Service2 holds a fixed catalog of scored records
and can be switched, through an internal-only endpoint, between serving that
full catalog and serving an empty one. Service1 asks Service2 for whatever
catalog it is currently serving and returns one number: the average score,
as a whole number. API Consumers only ever talk to Service1; Service2's mode
switch is never exposed to them.

## Actors

- **API Consumer** — calls Service1's public endpoint to retrieve the current
average score. Has no visibility into, or access to, Service2 or its mode.
- **Internal Operator** — uses Service2's internal operations endpoint to
switch it between full mode and empty mode. This endpoint is never reachable
by an API Consumer.

## User Stories

1. As an API Consumer, I want to request the current average score across the
 catalog, so that I get one summary number without fetching and computing
 over every record myself.
2. As an API Consumer, I want a request to a path Service1 does not serve to
 return a structured 404 body, so that I can reliably tell "not found" apart
 from a computed result.
3. As an Internal Operator, I want to switch Service2 into empty mode, so
 that I can verify the system's behavior when the catalog holds no records.
4. As an Internal Operator, I want to switch Service2 back into full mode, so
 that the standard catalog is restored for normal operation.

## Product Decisions

- **Service2's catalog is fixed, seed data**, reproduced verbatim here and in
the seed data:
- **Service2 starts in full mode.** Empty mode — a catalog with no records —
is reached only by an Internal Operator calling the mode-switch endpoint.
- **The average computation is a single, universal rule**: sum every record's
score in whatever catalog Service2 is currently serving, divide by the
record count, and discard any remainder to return a whole number. The same
rule runs for every catalog Service2 can serve — there is no separate
computation or result path for any particular catalog. Against the full
catalog this yields 35.
- **Service1 is open access.** Its average endpoint requires no sign-in —
any API Consumer can call it directly.
- **Service2's operations endpoint is internal-only.** It is never exposed
through Service1, never reachable by an API Consumer, and is used solely by
an Internal Operator to switch modes.
- **Both services log how many records they handled per request**, so an
operator can observe catalog size per call without that count being part of
either service's response body.
- **Unmatched paths on Service1 return a structured 404 body.** This applies
only to paths Service1 does not serve at all — it is unrelated to, and does
not apply to, Service1's average endpoint.

## Out of Scope

- What Service1 returns when Service2's catalog is currently empty. This
version defines no story, no computed value, no default, and no error
response for that case — it is left entirely unspecified.
- Any alternative response shape, optional field, or documented variant for
an empty catalog on either service's OpenAPI contract. Empty mode is a
fault condition for Service1's consumer-facing contract, not a documented
alternative.
- Any 4xx or 5xx response documented on Service1's average endpoint. That
endpoint's contract documents exactly one response: the successful average.
The structured 404 for unmatched paths is a separate, unrelated concern.
- Authentication or sign-in in front of Service1 — it is open access by
decision above.
- Any user-facing web application or UI. This project is API-only: two
services with no frontend.
- Exposing Service2's operations endpoint to API Consumers, or to any
path Service1 serves.

## Open Questions

None outstanding — actor naming, Service1's access model, and every scope
boundary above were settled during the interview.