# Pre-presentation

* Have browser open with tabs:
  * https://github.com/warrenb-cgi/github-actions-talk-features
  * https://github.com/warrenb-cgi/github-actions-talk-manual
  * https://github.com/warrenb-cgi/github-actions-talk-completed/

# Presentation

* Deliver first few slides full screen until finished with example application overview
* Switch to reading view and make half the screen with browser the other half
* _Build and test_
  * Switch to successful feature branch; show green checkbox
    * Open PR
    * Show that checks have already passed (the PR is from a branch, the branch hasn't changed)
    * Merge PR; delete branch
  * _Failed branch_
    * Open PR
    * Click on details of failure; click on summary
    * Go to report, explain failure
  * _Cleanup_
    * Run cleanup workflow with arg `feature/title`
* _Build and test - how_
  * https://github.com/warrenb-cgi/github-actions-talk-features/blob/main/.github/workflows/build.yml#L2-L5
* _Build and test - how (2)_
  * https://github.com/warrenb-cgi/github-actions-talk-features/blob/main/.github/workflows/build.yml#L10-L44
* _Build and test - how (3)_
  * https://github.com/warrenb-cgi/github-actions-talk-features/blob/main/.github/workflows/build.yml#L45-L92
  * https://github.com/warrenb-cgi/github-actions-talk-features/blob/main/.github/workflows/build.yml#L93-L129
* _Build and test - how (4)_
  * https://github.com/warrenb-cgi/github-actions-talk-features/blob/main/.github/workflows/ghpage-indexes.yml#L25-L59
  * https://github.com/warrenb-cgi/github-actions-talk-features/blob/main/.github/workflows/cleanup-report.yml#L3-L8
* _Dependabot_
  * Docker Node update
    * talk about non-semantic versions
  * Docker JDK 18
    * `@dependabot ignore this major version`
  * Pick something else (jest dot, react)
    * Note release notes, commits
  * Pick something broken (reactstrap)
    * Show "Enable auto-merge" button
    * `@dependabot recreate`
* _Dependabot - how_
  * https://github.com/warrenb-cgi/github-actions-talk-manual/blob/main/.github/dependabot.yml
* _Automating Dependabot_
  * Show closed PRs on completed project
* _Automating Dependabot - how_
  * https://github.com/warrenb-cgi/github-actions-talk-completed/blob/main/.github/workflows/auto-dependabot-merge.yml
