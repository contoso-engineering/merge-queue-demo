# Setup

## How to reset the demo

Resetting will do the following:

* Close all demo PRs (PRs with a head ref of `pr-a`, `pr-b`, `pr-c`)
* Seed a new `main` branch (from `__demo/setup`)
* Seed new PR branches
* Create new PRs

To reset:

1. Go to the **Actions** tab
2. Select the `demo reset` workflow and then click **Run workflow**
   ![image](https://github.com/github/merge-queue-demo/assets/2503052/eb269945-ed9b-4194-bbaa-eb41f557c01d)
3. Select the `__demo/setup` branch from the drop-down and click **Run workflow**
   <img width="358" alt="image" src="https://github.com/github/gh-merge-queue/assets/2503052/e02769e9-e9a2-40de-a757-56fe63998ae2">

## How to initially setup the repo

> Note: only needed the first time setting up a new repo.

### Configure branch protections

First, configure branch protections on `main` to require merge queue:

* Enable **Require status checks to pass before merging**
* Add `build` (GitHub Actions) as a required status check
* Enable **Require merge queue** 
* Enable **Allow force pushes**

<!--
### Seed branches and pull requests

Clone the repo locally and run the follow script to create the appropriate branches and PRs:

> **Warning**: as written, the script will force push to `main`.

```bash
git fetch origin
git checkout -B main __demo/main
git commit --allow-empty -m "Empty commit to ensure new refs and checks are always run"
git push origin main --force -u

# PR A (adds checks to "calculate" function that changes its behavior)
git checkout -B pr-a __demo/pr-a
git push origin pr-a --force -u
gh pr create --fill

# PR B (calls the "calculate" function in a way that previously worked, but will fail with PR A's updates)
git checkout -B pr-b __demo/pr-b
git push origin pr-b --force -u
gh pr create --fill

# PR C (simple markdown change that should not be impacted by PR A or B)
git checkout -B pr-c __demo/pr-c
git push origin pr-c -u --force
gh pr create --fill
```

```bash
git fetch origin
git checkout -B main ee68d9a475d6e13b77e5466f3eec5949bd2472da
git commit --allow-empty -m "Empty commit to ensure new refs and checks are always run"
git push origin main --force -u

# PR A (adds checks to "calculate" function that changes its behavior)
git checkout -B pr-a c94cbfcb722acf76c0f5a7a5d5b4d42872d6fc88
git push origin pr-a --force -u
gh pr create --fill

# PR B (calls the "calculate" function in a way that previously worked, but will fail with PR A's updates)
git checkout -B pr-b d9a626020688211e06f170a798c33eb438875bb9
git push origin pr-b --force -u
gh pr create --fill


# PR C (simple markdown change that should not be impacted by PR A or B)
git checkout -B pr-c 67a1ece794cba0d488504651a6e4303e79f5f74b
git push origin pr-c -u --force
gh pr create --fill
```

