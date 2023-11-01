#!/usr/bin/env bash

ORG="${GITHUB_REPOSITORY_OWNER:-willsmythe}"
REPO="${GITHUB_REPOSITORY:-merge-queue-testing}"

echo "NWO: $ORG / $REPO"

declare -a heads=( "pr-a" "pr-b" "pr-c" )
for head in "${heads[@]}"
do
    PR_NUMBER=`gh api "repos/$ORG/$REPO/pulls?head=$ORG:$head&state=open" | jq ".[] | .number"`
    if [ "$PR_NUMBER" = "" ]; then
        echo "No PR open against $head"
    else
        echo "Found a PR open again $head; closing it..."

        gh api \
        --method PATCH \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        repos/$ORG/$REPO/pulls/$PR_NUMBER \
        -f state='closed'
    fi
done


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

