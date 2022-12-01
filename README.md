# merge-queue-testing

A simple test repo that demonstrates merge queue. 

## How it works

The script below creates 3 pull requests:

* **`A`**: enhances the validation of the values passed to  `calculate()`
* **`B`**: adds new logic that calls `calculate` (passing values that are currently OK, but are not OK with **`A`**'s new validation)
* **`C`**: makes an unrelated change to a markdown file

<img width="723" alt="image" src="https://user-images.githubusercontent.com/2503052/205069631-235be39d-63d4-4ddc-bcfa-a700a24b5139.png">

All 3 PRs build successfully on their own, but the changes in **`B`** will throw an exception and break the build if applied on top of the changes from **`A`**.

_**Without merge queue**_ (and without requiring PR branches be up-to-date before merging), merging **`A`** followed by **`B`** would cause `main` to be in a broken state (not good). "_But, my PR [B] was passing when I merged it!_"

_**With merge queue**_, enqueuing (or merging) **`A`** followed by **`B`** will result in **`B`** getting removed from the queue, giving the developer the chance to make it compatible with the enhanced validation checks now in `main`.

## Get started

### Configure branch protections (one time)

First, configure branch protections on `main` to require merge queue:

* Enable **Require status checks to pass before merging**
* Add `build` (GitHub Actions) as a required status check
* Enable **Require merge queue** 
* Enable **Allow force pushes**

### Seed branches and pull requests

Clone the repo locally and run the follow script to create the appropriate branches and PRs:

> **Warning**: as written, the script will force push to `main`.

```bash
git fetch origin
git checkout -B main 8a1bb282523f145aafabf4f7f58a87861d42c2c4
git commit --allow-empty -m "Empty commit to ensure new refs and checks are always run"
git push origin main --force -u

# PR A (adds checks to "calculate" function that changes its behavior)
git checkout -B pr-a 78c13f265f40741d3a6d202f8cf8ee11e94a19f9
git push origin pr-a --force -u
gh pr create --fill

# PR B (calls the "calculate" function in a way that previously worked, but will fail with PR A's updates)
git checkout -B pr-b e814228ef33cb871d79b3574996ad6e7c6ce9928
git push origin pr-b --force -u
gh pr create --fill

# PR C (simple markdown change that should not be impacted by PR A or B)
git checkout -B pr-c 8fe8deb2d1ef4ff42e1809cb130ebb197a778761
git push origin pr-c -u --force
gh pr create --fill
```

### Demonstrate

Now to demonstrate the value of merge queue:

1. Wait for all 3 PRs to pass the required status check (1-2 minutes)   

2. From the web, navigate to **`A`** and add it to the queue. Repeat for **`B`** and **`C`** so that all 3 PRs are in the queue.
   <img width="913" alt="image" src="https://user-images.githubusercontent.com/2503052/205069843-bfa4b0ae-f0bf-4a7d-97ad-dea20bcccbce.png">
   * The order in which the PRs are added is important
   * A few seconds between each enqueue is fine

What **should** happen:

* **`A`** (`main` + `pr-a`) builds successfully and is merged
* **`B`** (`main` + `pr-a` + `pr-b`) fails because **`B`** new call to `calculate` fails with the enhanced validation logic added by **`A`**
* **`B`** is removed from the queue once it reaches the top (i.e. **`A`** merges)
* **`C`** (`main` + `pr-a` + `pr-b` + `pr-c`) fails for the same problem (even though C's changes are unrelated to A or B)
* **`C`** remains in the queue, a new build starts for it (`main` -- which includes `pr-a` --- + `pr-c`), and is merged




<!-- #### With `push` trigger

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
-->
