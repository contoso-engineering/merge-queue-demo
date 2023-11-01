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

## Setup

See [setup instructions](setup.md) for one-time setup steps, how to reset the demo, etc.
