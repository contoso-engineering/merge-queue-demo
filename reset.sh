#!/usr/bin/env bash

heads = ("pr-a", "pr-b", "pr-c")
for head in "${heads[@]}"
do
  gh api "repos/{owner}/{repo}/pulls?head={owner}:$head&state=open" | jq ".[] | .id"
done

return 0


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


gh api  -- '
query {
    repository {

    }
}
'

heads = ("pr-a", "pr-b", "pr-c")
for head in "${heads[@]}"
do
  gh api "repos/{owner}/{repo}/pulls?head={owner}:$head&state=open" | jq ".[] | .id"
done

gh api "repos/{owner}/{repo}/pulls?head={owner}:pr-a&state=open" | jq ".[] | .id"



gh api "repos/{owner}/{repo}/pulls?head={owner}:pr-b&state=open"
gh api "repos/{owner}/{repo}/pulls?head={owner}:pr-c&state=open"
