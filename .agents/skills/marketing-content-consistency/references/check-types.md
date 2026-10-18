# Consistency check types

The examples are invented to illustrate each rule. They are not data.

## CON: contradiction

| Subtype | A | B | Why it conflicts |
|---------|---|---|------------------|
| negation | "The audit needs no access to production." | "We start by reading production logs." | Same subject, exclusive states |
| judgment | "A retainer is the cheap way to start." | "A retainer's minimum eats a small firm's budget." | Opposite cost judgment for the same reader, no condition |
| recommendation | "Start with the ICP." | "The first step is positioning." | Two different first steps |
| quantifier | "Every proposal has an assumptions section." | "Short proposals skip assumptions." | "Every" vs an exception |
| cause | "Clients leave over price." | "Price is rarely why clients leave." | Conflicting causes |
| attribution | "Maister says decline at once." | FAQ: "Maister allows it if the client insists." | Two readings of one source |

**Not a contradiction:** different conditions, different time, different scope, a
third-party opinion presented as such, a contrast the text names ("looks cheap, but…").
Exception: a named contrast between the firm's own example and the method's rule
is still reported — that is the case readers catch.

## NUM: numbers

Check:

- the same quantity in different places (duration, price, headcount, percentage);
- shares and sums: parts over 100%, "half of 30 is 12";
- dates and order ("we started in 2025; a year earlier, in 2023…");
- units and currency (EUR vs USD, net vs gross) for one amount;
- rounding: "about 40%" and "42%" is fine; "40%" and "60%" of the same thing is not;
- two perspectives on one activity (vendor hours vs client hours) — fine only when
  the text names which is which.

## CNT: counters

Announcements of a number of items: in the title ("7 mistakes"), a heading ("Three
steps"), a sentence ("for two reasons"), or a quantifier ("each with one question",
"every row"). Count the real items: headings, list entries, items in a sentence,
cells in a table. Check numbering too: a missing step 3, two step 4s.

## ANG: angle

The angle is the idea's `unique_angle`, answering its `buyer_question`. One rating
per H2 section:

- `supports` — gives an argument or example for the angle;
- `neutral` — background, definition, instruction;
- `undercuts` — claims something that weakens the angle and the text leaves it open.

A counterargument the text raises and answers is `supports`. Report only
`undercuts`, and report the whole text when it never answers the `buyer_question`.

## REF: cross-references

"As shown above", "in step 3", "see the table", "the report mentioned earlier".
Check that the place exists and says what the reference claims.

## EXM: example and method against the text's own rules

A text that teaches a method has to follow it. Check whether:

- each example meets the text's definitions (definition: "a trigger is an event";
  example: "pressure on productivity" → `EXM`);
- a shown example fills the text's template, or names what it lacks;
- each step of a method has its input from earlier steps;
- each term has one definition throughout ("decides or uses" in the definition,
  only "decides" in the template → `EXM`);
- the method's steps produce every field of the template the text gives;
- a strong generalization ("never", "always", "there is no reason") survives the
  exception described later;
- a filled example is internally consistent (its fields do not contradict each other);
- advice does not break a formula quoted next to it;
- the text does not criticize something it then does itself, unless it explains why;
- a sentence summarizing a list fits every item on that list.

## REP: repetition

The same idea twice or more with nothing new the second time. Test: deleting the
second occurrence loses no fact, argument, or example.

Do not report a definition repeated in a step summary of an instruction, or the angle
stated once at the start and once at the end — unless it appears three times or more.
Say which occurrence to keep (usually the first, or the one with the example).
