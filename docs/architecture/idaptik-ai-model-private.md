<!-- SPDX-License-Identifier: CC-BY-SA-4.0 -->
# IDApTIK private cognitive-model working note

This document is intentionally kept in the private canonical UMS repository.
IDApTIK's public repository should expose only the stable ESM/package contract
and observable runtime behaviour.

## Working model

The current hypothesis combines an affective appraisal path, an epistemic
state/theory-of-mind path, relational inference, conative candidate selection,
and typed/formal verification. The process is a feedback loop, not a one-way
pipeline:

```text
world/bodily input → affective appraisal → epistemic update
→ inference and competing hypotheses → candidate action
→ policy/verification → world transition → new observation
```

## Evidence and false hypotheses

The guard model must be observer-relative. It should retain competing
explanations, explicit ignorance, provenance, source reliability, and conflict.
Dempster–Shafer-style belief masses are a candidate mathematical substrate;
fixed-point arithmetic is preferred for deterministic replay. Do not normalise
high-conflict evidence without an explicit policy.

The USB/fridge-note and vent/front-door examples are the first deception
fixtures: an NPC can make a rational but false attribution and later revise it
without erasing the original trace.

## VSM-shaped supervision

NPCs are operational units; patrols coordinate and regulate them; factions are
recursive higher-level systems; a director forecasts player tactics; policy
constrains adaptation. All interventions must be explicit, bounded, and
provenance-bearing.

This remains a working hypothesis. Promote details into shared contracts only
after executable conformance fixtures and replay tests succeed.
