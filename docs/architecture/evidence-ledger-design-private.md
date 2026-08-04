<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
# Evidence ledger design — private canonical draft

Status: **design draft v0.1**

This is the detailed private design for observer-relative evidence handling.
Public consumers should receive only versioned events, belief/plausibility
summaries, diagnostics, and package compatibility rules.

## 1. Purpose

The ledger represents what an observer can justify from available evidence. It
must preserve ignorance, competing explanations, source provenance, conflict,
time, and revision. It must never consult hidden world truth when constructing
an observer's state.

The ledger is not the world model, not a planner, and not a truth oracle. It is
an evidence state that feeds ESM updates and VSM regulation.

## 2. Frame of discernment

Each ledger has a declared frame of hypotheses for one question:

```text
Frame {
  frame_id,
  version,
  hypotheses: [HypothesisId],
  open_world: bool,
  exclusivity: Exclusive | Overlapping,
  unknown_id: optional HypothesisId
}
```

For route attribution:

```text
front_door, ventilation, unknown
```

For intention attribution:

```text
wants_usb, wants_fridge_note, wants_both, unknown
```

If the frame is incomplete, mass may be assigned to a set of alternatives or
to `unknown`; it must not be silently redistributed to named hypotheses.

## 3. Basic belief assignment

Use fixed-point mass units for deterministic replay:

```text
Mass = uint32 in 0..=10_000
```

A focal element is a sorted, duplicate-free set of hypothesis IDs. A basic
belief assignment is:

```text
Bpa {
  frame_id,
  focal_sets: [(FocalSet, Mass)],
  uncommitted_mass: Mass,
  provenance: [EvidenceId]
}
```

Invariants:

1. all IDs belong to the frame;
2. focal sets are canonicalised before comparison;
3. masses are non-negative;
4. focal masses plus uncommitted mass equal 10,000;
5. empty focal sets are forbidden in a normalised state and retained only as
   explicit conflict during combination;
6. serialisation order is canonical.

`Bel(A)` is the sum of masses of focal sets wholly contained in `A`.
`Pl(A)` is the sum of masses of focal sets intersecting `A`, including mass
that has not ruled `A` out. Decisions must retain the interval
`[Bel(A), Pl(A)]` until a policy explicitly requests a point estimate.

## 4. Evidence item

```text
Evidence {
  evidence_id,
  observer,
  source,
  observed_at,
  received_at,
  reliability: Mass,
  freshness: Mass,
  bpa,
  observation_kind,
  supporting_trace_events,
  expires_at,
  independence_group,
  notes
}
```

`observed_at` and `received_at` are separate: delayed reports must not appear
to have been known earlier. `independence_group` prevents double-counting a
camera report and a patrol report derived from that same camera report.

## 5. Reliability and discounting

Reliability is applied by discounting an evidence item, not by changing the
observer's prior. A reliability of 7,500 means 7,500 mass units remain on the
item's focal sets and 2,500 move to the frame's unknown/uncommitted element.

Reliability must be attributable to a declared source policy. It must not be
silently learned from the hidden answer. A guard, camera, hearsay report, and
director inference may have different reliability profiles.

## 6. Time and revision

Evidence is event-sourced. The ledger records append-only evidence and derives a
current view. Expiry or decay creates a new derived state/event; it does not
delete the historical evidence.

Recommended events:

```text
EvidenceReceived
EvidenceDiscounted
EvidenceCombined
EvidenceConflictDetected
HypothesisIntervalChanged
EvidenceExpired
BeliefRevisionRecorded
```

Temporal decay must be a named policy with deterministic integer arithmetic.
Different observers may use different freshness policies while consuming the
same underlying event trace.

## 7. Combination and conflict

Combination policy is part of the ledger profile:

```text
IndependentConjunctive
Cautious
Disjunctive
SourcePriority
RetainConflict
```

Do not automatically apply normalised Dempster combination to highly
conflicting evidence. Preserve conflict mass and emit a diagnostic. A policy
may later resolve, discount, separate, or escalate the conflict.

Conflict is useful game state:

```text
high conflict → split patrol, seek corroboration, or preserve coverage
low conflict  → commit resources to the most plausible explanation
```

## 8. ESM boundary

The ledger emits evidence and interval changes into the ESM; it does not mutate
the world directly:

```text
observation
  → EvidenceReceived
  → ledger view (Bel/Pl/conflict)
  → ESM belief/hypothesis event
  → VSM regulation proposal
  → policy check
  → candidate action
```

The ESM owns ordered identity, provenance references, nested-agent scope, and
replay. The ledger owns evidence fusion for a declared question frame. VSM owns
resource allocation and supervisory intervention. The world simulator owns
actual consequences.

## 9. Decision interface

The ledger must not return an action. It returns a query result:

```text
EvidenceQuery {
  frame_id,
  proposition,
  belief,
  plausibility,
  conflict,
  unknown,
  supporting_evidence,
  contrary_evidence
}
```

A profile policy maps this to an action. Example policies:

```text
plausibility(vent) ≥ 7_000 → assign one operator to vents
belief(front_door) ≥ 6_000 → preserve front-door coverage
conflict ≥ 4_000 → gather evidence before committing
unknown ≥ 5_000 → do not collapse to a named route
```

Policies must be explicit, versioned, and testable.

## 10. Deterministic encoding

Canonical encoding requires sorted frame IDs, sorted focal-set members, sorted
evidence IDs, fixed-point masses, explicit policy/version fields, and no map
iteration dependence. Every combine, discount, decay, and query operation must
have replay tests and overflow/rounding tests.

## 11. Conformance fixtures

The first fixtures should cover:

1. USB interest that rationally but incorrectly raises `wants_usb`.
2. Fridge-note evidence that revises the earlier attribution.
3. Vent/front-door evidence with mass on `{vent, front_door}`.
4. Two reports derived from one camera event, proving no double-counting.
5. Delayed evidence that cannot affect an earlier decision.
6. High-conflict reports that preserve conflict rather than normalising it away.
7. Unknown/open-world mass that remains unknown.
8. Snapshot and replay equivalence.
9. Stable tie-breaking and canonical serialisation.

## 12. Promotion criteria

Do not make this a shared public contract until the fixtures demonstrate:

- deterministic replay;
- provenance-complete revision;
- bounded memory and focal-set growth;
- explicit conflict handling;
- observer-relative information boundaries;
- policy decisions that are explainable from ledger queries.
