# File: CANONICAL_HASHES.md

Module: .claude/translation/CANONICAL_HASHES.md  
Purpose: SHA-256 (first 16 hex) of every canonical rule file at the last Claude convergence; lets the next convergence detect changed files even when the canonical rules are not committed.  
Path: LCM_AI/.claude/translation/CANONICAL_HASHES.md  
Authors: Rolf, Claude (Anthropic)  
Version: 10.6.4
Status: Draft  
Date: 2026-11-19 12:01:29

---

Baseline: LCM_AI 2bebbaa + CRP-331 Batch 1-3 (uncommitted working tree); content identical to LCM_AI e258f1c (WIP commit 2026-11-15).

- 2026-11-19 12:01:29: PythonRules.md (10.2.1, RULE-PY-010 interpreter registry) re-hashed (CRP-366, operator option B 2026-11-19); adapter line added in the same change set.
- 2026-11-19 11:45:45: all 21 canonical files re-hashed after the one-time CRLF -> LF conversion (BUG-365, operator 2026-11-19); content changes only in InvariantRules.md (10.3.1, newline-crlf -> newline-lf), JsonRules.md (10.2.1), PowerShellRules.md (10.2.2) and ProposalReviewFlowPolicy.md (10.3.5, MinimalTests wording); adapter lines updated in the same change set.
- 2026-11-18 22:29:49: ProposalReviewFlowPolicy.md (10.3.4, RULE-LCM-009 / RULE-LCM-011 bundle folders <nnn>_<Kind>-<Slug>) re-hashed (CRP-359 revision 3, operator 2026-11-18); adapter lines updated.
- 2026-11-18 16:11:02: ProposalReviewFlowPolicy.md (10.3.3, RULE-LCM-009 / RULE-LCM-011 bundle file names carry the item ID) re-hashed (CRP-359, operator 2026-11-18); adapter line updated.
- 2026-11-18 16:02:48: ProposalReviewFlowPolicy.md (10.3.3, RULE-LCM-002 implied cohort, RULE-LCM-016 multi-repository COMPLETE), ReviewCommitGovernancePolicy.md (10.3.2, RULE-REV-012 window ownership / Full Refresh) and macro-definitions.md (10.3.2, BCR / COMPLETE) re-hashed (CRP-346 revision, operator 2026-11-18); adapter lines updated.
- 2026-11-17 15:40:19: ProposalReviewFlowPolicy.md (10.3.2, RULE-LCM-030 (1) cross-host adapter changes, (5) session state schema, (6) AI-run day routines), RepositoryContextPolicy.md (10.3.1, RULE-CTX-006) and macro-definitions.md (10.3.1, GoodMorning / GoodNight) re-hashed (CRP-350, operator 2026-11-17); adapter lines updated.
- 2026-11-17 15:05:31: MethodEfficiencyPolicy.md (10.2.2, RULE-EFF-001 SQL projections, RULE-EFF-002 bookkeeping never aborts) re-hashed (BUG-349, operator 2026-11-17); adapter line updated.
- 2026-11-17 12:27:04: ReviewCommitGovernancePolicy.md (10.3.1, RULE-REV-007 item 4) and ProposalReviewFlowPolicy.md (10.3.1, RULE-LCM-010 item 4) re-hashed after the BUG-342 version-alignment exemption (operator 2026-11-17); adapter lines updated in the same change set.
- 2026-11-16 15:45:57: DecisionCascadeGovernancePolicy.md re-hashed after LF -> CRLF conversion (CRP-332); content unchanged, adapter needs no re-mapping.

| File | SHA-256 (16) |
|:---|:---|
| AnalysisGovernancePolicy.md | 878C96A2B0288415 |
| CMDRules.md | BD5AF92D402E7260 |
| DecisionCascadeGovernancePolicy.md | C28FB50C4C79A95A |
| DisplayStandardsPolicy.md | 24882E749C9119E0 |
| DocumentationStandardsPolicy.md | 384F2190C4A18C40 |
| ElevationPolicy.md | E5E53A03E949FA3C |
| GoalFirstDesignPolicy.md | 409783165CD08732 |
| GoRules.md | 2E2C78109AE78FC4 |
| InvariantRules.md | FBEE0D8473B71AD7 |
| JsonRules.md | 5CD7EF7714B3DE8B |
| LanguagePolicy.md | E930C637A087794E |
| macro-definitions.md | CBE836EC8B87743A |
| MethodEfficiencyPolicy.md | 194321B258EF2C6C |
| PowerShellRules.md | 03F0AF42D5EF8602 |
| PowerShellStandardsPolicy.md | E7E7CAE86114667D |
| ProposalReviewFlowPolicy.md | 9A561AC63DA25289 |
| PythonRules.md | 0B5A0EE4F8F1EB48 |
| RepositoryContextPolicy.md | 5893A8A24CFB5C22 |
| ReviewCommitGovernancePolicy.md | 1CDFBA9ED4FA9C74 |
| RuleAuthority.md | C8DF8FBDB8301634 |
| SubsystemGovernancePolicy.md | F3DA87C140CCA8A3 |
