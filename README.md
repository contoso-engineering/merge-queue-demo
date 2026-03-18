# Merge Queue Demo

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

## How to demo

1. Reset the main branch to its original state and seed new PRs (see [reset steps](./setup.md))

2. Wait for all 3 PRs to pass the required status check (1-2 minutes)   

3. From the web, navigate to **`A`** and add it to the queue. Repeat for **`B`** and **`C`** so that all 3 PRs are in the queue.
   <img width="913" alt="image" src="https://user-images.githubusercontent.com/2503052/205069843-bfa4b0ae-f0bf-4a7d-97ad-dea20bcccbce.png">
   * **The order in which the PRs are added is important**
   * A few seconds between each enqueue is fine

What **should** happen:

* **`A`** (`main` + `pr-a`) builds successfully and is merged
* **`B`** (`main` + `pr-a` + `pr-b`) fails because **`B`** new call to `calculate` fails with the enhanced validation logic added by **`A`**
* **`B`** is removed from the queue once it reaches the top (i.e. **`A`** merges)
* **`C`** (`main` + `pr-a` + `pr-b` + `pr-c`) fails for the same problem (even though C's changes are unrelated to A or B)
* **`C`** remains in the queue, a new build starts for it (`main` -- which includes `pr-a` --- + `pr-c`), and is merged

## Setup

See [setup instructions](setup.md) for one-time setup steps, how to reset the demo, etc.


HERE IS A CHANGE!
