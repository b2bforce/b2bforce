---
fixture: true
firm: Bramblegate Group
website: https://example.com/bramblegate-group
industry: ERP integration and finance-data services
headcount: 24
content_language: en
updated: 2026-08-10
---

# Firm Profile — Bramblegate Group

A fictional 24-person services group, used as the **multi-brand** demo for this
repo. See [examples/README.md](../../README.md) before reading further. One legal
firm, one delivery bench, one marketing and sales team — and two market-facing
brands, because the buyers are different people with different vocabularies.

## What we do

Two brands, each a directory under `firm/brands/` holding its own services, ICP, proof, and channels:

- **Bramblegate** sells fixed-scope ERP integration projects to mid-market
  distributors. The buyer is a COO with a stock number nobody trusts.
- **Ledgerline** sells a monthly finance-reporting retainer on top of the data
  those integrations produce. The buyer is a CFO who closes the month late.

The second brand exists because a CFO does not buy "ERP integration" and a COO
does not buy "reporting". Same firm, same people, different doors.

## Positioning

Bramblegate competes with ERP vendors' own services arms and wins on being
implementation-agnostic. Ledgerline competes with hiring a financial analyst and
wins on starting from data the firm already understands. Neither brand's website
mentions the other; the connection is made in conversations, client by client,
which is why `cross_brand` on proof records matters here.

## Who we sell to

Mid-market distribution companies in the EU, 100–500 employees. Each brand has
its own ICP and personas inside its brand home, `firm/brands/{brand}/icp/`.

## Delivery model

One shared bench. The people registry in `firm/people/` is what makes the shared
team explicit — the same marketing lead owns both brands' pipelines, which is
exactly the situation the multi-brand layout exists for.

## Language and tone

English. Plain and specific, no superlatives, no client numbers outside
`firm/proof/`.
