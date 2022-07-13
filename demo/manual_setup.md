# Demo Repository setup

In order to create demonstrations at various stages of evolution, other repositories must be created.

## Initial Steps

1. Create repository, adding Readme file to create main branch. (It will be replaced.)
2. [Create a PAT](https://github.com/settings/tokens/new?scopes=repo) for avoiding [GitHub's restriction](https://docs.github.com/en/actions/using-workflows/triggering-a-workflow#triggering-a-workflow-from-a-workflow) on cascading workflow triggers.
3. Create secrets ACTION_GIT_NAME, ACTION_GIT_EMAIL, ACTION_PAT in both action and dependabot
4. Checkout repository as child of `repos/` folder in this folder.
5. Run `setup.sh` on the repository.
6. Activate auto-merge
7. Activate status check to pass before merging with build, integration-tests as checks.
    * Apply status check to administrators too.
8. **Only for Dependabot repos**
    1. Turn on Dependabot alerts
    2. If not the manual repository, run `enable_fullauto.sh`
    3. Run `enable_dependabot.sh` on the repository
    4. Create and auto-merge a pull request for the branch
