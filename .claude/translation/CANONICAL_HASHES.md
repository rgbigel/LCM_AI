# File: CANONICAL_HASHES.md

Module: .claude/translation/CANONICAL_HASHES.md  
Purpose: SHA-256 (first 16 hex) of every canonical rule file at the last Claude convergence; lets the next convergence detect changed files even when the canonical rules are not committed.  
Path: LCM_AI/.claude/translation/CANONICAL_HASHES.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4
Status: Draft  
Date: 2026-11-17 12:27:04

---

Baseline: LCM_AI 2bebbaa + CRP-331 Batch 1-3 (uncommitted working tree); content identical to LCM_AI e258f1c (WIP commit 2026-11-15).

- 2026-11-17 12:27:04: ReviewCommitGovernancePolicy.md (10.3.1, RULE-REV-007 item 4) and ProposalReviewFlowPolicy.md (10.3.1, RULE-LCM-010 item 4) re-hashed after the BUG-342 version-alignment exemption (operator 2026-11-17); adapter lines updated in the same change set.
- 2026-11-16 15:45:57: DecisionCascadeGovernancePolicy.md re-hashed after LF -> CRLF conversion (CRP-332); content unchanged, adapter needs no re-mapping.

| File | SHA-256 (16) |
|:---|:---|
| AnalysisGovernancePolicy.md | 8DFB29AE546AB173 |
| CMDRules.md | 3D56298EBDEA24D6 |
| DecisionCascadeGovernancePolicy.md | 5399AB451F3E01FF |
| DisplayStandardsPolicy.md | AD3FAB77ED95FF9A |
| DocumentationStandardsPolicy.md | 3399EC0D69823487 |
| ElevationPolicy.md | DFB5D0060D021B7D |
| GoalFirstDesignPolicy.md | 57962D994F7A2A38 |
| GoRules.md | 4C615A00E6A80448 |
| InvariantRules.md | A253DF80EF9A0D5B |
| JsonRules.md | C03F3330FFCFB47F |
| LanguagePolicy.md | 8466F4BA95AB84AA |
| macro-definitions.md | 2AB30570378E1230 |
| MethodEfficiencyPolicy.md | CD98117EE5A010B6 |
| PowerShellRules.md | 2F23056F652F024C |
| PowerShellStandardsPolicy.md | 9F6E6DD1DF96AC1C |
| ProposalReviewFlowPolicy.md | 4080766835641F9F |
| PythonRules.md | C14EE91B678EA312 |
| RepositoryContextPolicy.md | 5AD66D4505A48D63 |
| ReviewCommitGovernancePolicy.md | 41AC90DE11F87F3C |
| RuleAuthority.md | 1F4C00CE4DEB20C9 |
| SubsystemGovernancePolicy.md | 618C0E3B6F6ECC67 |
