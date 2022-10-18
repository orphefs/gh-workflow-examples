# Github Actions workflows for updating release metadata

## Overview

This repo introduces a Github Actions workflow logic that allows for automatic release metadata updates using a combination of Github Actions and a CI/CD platform of your choice.

## Logic

- You check out a branch `feature-amazing-new-feature` from `dev` and want to develop an amazing new feature.
- When you are done with development, you open a PR. 
- This PR is reviewed and approved manually, then merged back into `dev`.
- You want the above merge to trigger a release update (with a custom script of your choice), followed by a build-and-test workflow on the CI/CD platform of your choice.

This workflow logic solves the following issues:
 - It alleviates the need for force-pushing onto `dev` or `main`,
 - Makes sure that the release commit hashes (and their associated builds) actually can be traced back to the base (i.e. `dev` or `main`) and not the head (feature) branch.

Example steps with `dev` as base branch:
 - (Manual step) Review feature PR `feature-amazing-new-feature` and approve merge to `dev`. NOTE: It is good for the most recent push to have run a workflow, prior to review,  to ensure that tests/build are passing before approving PR.
 - (Automated step) (`update-release-metadata.yml`) As soon as `dev` detects the merge commit (or equivalently, push to `dev`), it opens PR with branch name `update-release-metadata-<commit_hash>` and `write_release.sh` runs within PR to update release metadata.
 - (Automated step) (`update-release-metadata.yml`) Bot reviews and approve merge to `dev` for the above PR.
 - (Automated step) (`build-execute-after-update-release-metadata.yml`) As soon as a push to `dev` with commit message `Merge pull request * update-release-metadata-<commit_hash>` is detected, this workflow runs, which calls the reusable workflow `tekton-build-test-dev.yaml`.
 - (Automated step) (`build-test-dev.yaml`) Builds and runs tests on the platform of your choice.

