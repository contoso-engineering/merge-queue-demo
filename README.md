# merge-queue-testing

## Setup steps

### Configure branch protections on `main`

1. Enable **Require merge queue** 
2. Enable **Allow force pushes**

### Create branches and pull requests

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

