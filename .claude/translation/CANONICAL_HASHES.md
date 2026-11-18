# File: CANONICAL_HASHES.md

Module: .claude/translation/CANONICAL_HASHES.md  
Purpose: SHA-256 (first 16 hex) of every canonical rule file at the last Claude convergence; lets the next convergence detect changed files even when the canonical rules are not committed.  
Path: LCM_AI/.claude/translation/CANONICAL_HASHES.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4
Status: Draft  
Date: 2026-11-17 15:40:19

---

Baseline: LCM_AI 2bebbaa + CRP-331 Batch 1-3 (uncommitted working tree); content identical to LCM_AI e258f1c (WIP commit 2026-11-15).

- 2026-11-18 16:11:02: ProposalReviewFlowPolicy.md (10.3.3, RULE-LCM-009 / RULE-LCM-011 bundle file names carry the item ID) re-hashed (CRP-359, operator 2026-11-18); adapter line updated.
- 2026-11-18 16:02:48: ProposalReviewFlowPolicy.md (10.3.3, RULE-LCM-002 implied cohort, RULE-LCM-016 multi-repository COMPLETE), ReviewCommitGovernancePolicy.md (10.3.2, RULE-REV-012 window ownership / Full Refresh) and macro-definitions.md (10.3.2, BCR / COMPLETE) re-hashed (CRP-346 revision, operator 2026-11-18); adapter lines updated.
- 2026-11-17 15:40:19: ProposalReviewFlowPolicy.md (10.3.2, RULE-LCM-030 (1) cross-host adapter changes, (5) session state schema, (6) AI-run day routines), RepositoryContextPolicy.md (10.3.1, RULE-CTX-006) and macro-definitions.md (10.3.1, GoodMorning / GoodNight) re-hashed (CRP-350, operator 2026-11-17); adapter lines updated.
- 2026-11-17 15:05:31: MethodEfficiencyPolicy.md (10.2.2, RULE-EFF-001 SQL projections, RULE-EFF-002 bookkeeping never aborts) re-hashed (BUG-349, operator 2026-11-17); adapter line updated.
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
| macro-definitions.md | FE2766E193711B03 |
| MethodEfficiencyPolicy.md | 27C8B34CFBF3E697 |
| PowerShellRules.md | 2F23056F652F024C |
| PowerShellStandardsPolicy.md | 9F6E6DD1DF96AC1C |
| ProposalReviewFlowPolicy.md | 6647FB3247473647 |
| PythonRules.md | C14EE91B678EA312 |
| RepositoryContextPolicy.md | E2EECA66E74F3DE4 |
| ReviewCommitGovernancePolicy.md | 4768FB9A0A7F9BFE |
| RuleAuthority.md | 1F4C00CE4DEB20C9 |
| SubsystemGovernancePolicy.md | 618C0E3B6F6ECC67 |
