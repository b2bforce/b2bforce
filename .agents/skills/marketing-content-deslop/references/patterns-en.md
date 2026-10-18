# AI patterns in English prose

Written in our own words, grouped after humanizer (blader/humanizer, MIT), stop-slop
(hardikpandya/stop-slop, MIT), Wikipedia "Signs of AI writing" and the banned-language
idea from Sentry's blog guide (Apache 2.0). See `CREDITS.md`.

Strength: **strong** = flag on first sighting; **weak** = flag at 2+ per 300 words or
in a cluster.

## O. Openers and run-ups

| ID | Pattern | Examples | Strength | Instead |
|---|---|---|---|---|
| EN-O01 | Era opener | "In today's fast-paced world", "In the age of AI" | strong | Open with the problem or the conclusion |
| EN-O02 | Announcing the point | "It's worth noting that", "Let's dive in", "Here's what you need to know", "Without further ado", "In this post we'll explore" | strong | Delete the announcement |
| EN-O03 | Staged candor | "Here's the thing:", "Let's be honest", "Honestly?" as a standalone beat | strong | Delete |
| EN-O04 | Hook question | "Sound familiar?", "Ever wondered why…?" | strong | State the fact |

## W. Overused words

| ID | Words | Strength |
|---|---|---|
| EN-W01 | delve, tapestry, landscape (figurative), realm, testament, intricate, interplay, multifaceted | strong |
| EN-W02 | crucial, pivotal, vital, key (as filler), significant (without a number) | weak |
| EN-W03 | leverage, empower, unlock, streamline, seamless, robust, cutting-edge, best-in-class, game-changer | strong |
| EN-W04 | additionally, moreover, furthermore starting consecutive sentences | weak |
| EN-W05 | serves as, stands as, boasts, features (instead of is/has) | weak |
| EN-W06 | showcasing, highlighting, underscoring, fostering as a trailing -ing rider | strong |

## C. Constructions

| ID | Pattern | Strength | Instead |
|---|---|---|---|
| EN-C01 | Not X but Y; not just X, it's Y; split across two sentences | strong | State Y; keep a contrast only when someone actually claimed X |
| EN-C02 | Rhetorical question + answer ("Why does this matter? Because…") | strong | Declarative sentence |
| EN-C03 | Colon reveal ("The answer is simple:", "The result?") | strong | Give the answer |
| EN-C04 | Forced triads (three adjectives, three parallel sentences) | weak; strong at 2+ per paragraph | Two items, or the real number |
| EN-C05 | One-line closer or dramatic fragments ("That's the real win.", "No errors. No warnings.") | strong | Cut; end on the last fact |
| EN-C06 | Aphorism instead of a claim ("Data is the new oil") | strong | The specific claim |
| EN-C07 | Arguing with no one ("I'm not saying…", "Don't get me wrong") | strong | Delete or name who says it |
| EN-C08 | Stacked hedges ("could potentially arguably") | strong | One qualifier or none |
| EN-C09 | Borrowed authority ("experts agree", "studies show" with no source) | strong | Name the source or cut |
| EN-C10 | False range ("from startups to enterprises") | weak | List what it actually covers |
| EN-C11 | Inanimate actor doing a human verb ("the data tells a story") | weak | Name who acts |
| EN-C12 | Parallel ad copy ("Metrics tell you what. Traces tell you why.") | strong | One normal sentence |

## E. Endings and chat residue

| ID | Pattern | Strength |
|---|---|---|
| EN-E01 | "In conclusion", "In summary", "Ultimately" opening the last paragraph | strong |
| EN-E02 | Bright-future send-off ("The future looks bright", "Exciting times ahead") | strong |
| EN-E03 | Chat residue ("I hope this helps", "Let me know if…", "Great question!") | strong |
| EN-E04 | Empty CTA ("Start your journey today!") | strong |

## F. Formatting and typography

| ID | Pattern | Strength |
|---|---|---|
| EN-F01 | Bold as decoration, bold-label bullets with colons | strong |
| EN-F02 | Emoji or arrows in headings and bullets | strong |
| EN-F03 | Title Case where the site style uses sentence case | weak |
| EN-F04 | Em dashes as the default connector (any, unless the content guidelines allow them) | weak alone, strong at 1+ per 3 sentences |
| EN-F05 | Heading restated in the first sentence | strong |
| EN-F06 | Personality only in the intro and the CTA, clinical middle | strong (whole-text) |
