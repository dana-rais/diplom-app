# 02. Evidence of Relevance

## 1. Overview
This document presents the evidence that informed the requirements of the application: discussions with representatives of the target users and with a person who helps older adults use smartphones. It also separates findings supported by evidence from assumptions that are still to be tested.

## 2. Method
- **Format:** [short informal conversations / phone calls / in person], about [10–15] minutes each.
- **Dates:** [DD Month 2026 – DD Month 2026].
- **Selection:** [how participants were found, e.g. relatives and acquaintances of the author]. This is a convenience sample and does not represent all older adults in Kazakhstan.
- **Consent and privacy:** participants agreed to take part verbally. No names, contact details, or recordings were stored. Participants are identified only by code and age.
- **Questions:** see Section 6.

## 3. Discussions with User Representatives

| Code | Who | Date | Main statements (paraphrased) |
|---|---|---|---|
| P1 | Grandmother, 63, smartphone user | 21 Oct 2026 | Worries about accidentally sending money or deleting important data because navigation is hard to predict |
| P2 | Grandfather, 69, basic smartphone user | 21 Oct 2026 | Interface elements are too small; terms such as "cache" and "two-factor authentication" are confusing |
| P3 | Uncle, a relative who helps older family members with their phones | 21 Oct 2026 | Learners need a risk-free environment where mistakes have no real consequences, so they can build confidence step by step |

*Edit the statements above so that they match what participants actually said.*

## 4. Findings and Their Link to Requirements

| # | Finding | Evidence | Strength | Requirement or design decision |
|---|---|---|---|---|
| F1 | Fear of making an irreversible mistake discourages use | P1, P3 | Stated in discussions (2 of 3 people); consistent with the literature on confidence (Czaja et al., 2006) | FR-4 (safe simulations), FR-6 (hints without penalty), "Training mode" badge |
| F2 | Small interface elements and unclear terms are barriers | P2 | Stated in discussions (1 person); consistent with design guidelines (Gomez-Hernandez et al., 2023) | FR-2, NFR-1, plain-language texts |
| F3 | Learners need a safe place to practise with no real consequences | P3 | Stated in discussions (1 person) | FR-4, scope exclusion of real banking and government integrations |

These findings are indicative, not statistically representative: the sample is small and non-random.

## 5. Assumptions Still to Be Tested

| Assumption | Why it is not yet verified | How it will be tested |
|---|---|---|
| Passive tutorials (text, video) are not enough for most learners | Not stated by participants; literature supports interactive practice only indirectly (Moore & Hancock, 2022) | Usability study with task completion and pre/post comparison (see 09_verification_plan) |
| Standard phone accessibility settings do not solve the usability problems | Not tested | Compare tasks in the app with tasks on the phone's default settings |
| Audio narration helps users with reading or vision difficulties | No participant was asked | Include audio questions in the next round of discussions |
| Users prefer Kazakh or Russian depending on context | No participant was asked | Ask language preference in the next round |

## 6. Discussion Guide
1. What do you use your smartphone for? What do you avoid doing, and why?
2. Have you ever been afraid to press something? What happened?
3. What on the screen is hard to read, find, or understand?
4. Would you prefer to read instructions or listen to them? In which language?
5. Have you received a suspicious call or SMS? What did you do?
6. What would help you practise without worrying about mistakes?

## 7. Limitations
- Small convenience sample (3 relatives), no random selection.
- Statements were recorded as notes, not verbatim transcripts.
- Findings inform requirements but do not replace the planned usability testing.
