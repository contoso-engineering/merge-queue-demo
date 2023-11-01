#!/usr/bin/env bash

ORG="${GITHUB_REPOSITORY_OWNER:-willsmythe}"
REPO_NWO="${GITHUB_REPOSITORY:-willsmythe/merge-queue-testing}"

echo "NWO: $REPO_NWO"

declare -a heads=( "pr-a" "pr-b" "pr-c" )
for head in "${heads[@]}"
do
    PR_NUMBER=`gh api "repos/$REPO_NWO/pulls?head=$ORG:$head&state=open" | jq ".[] | .number"`
    if [ "$PR_NUMBER" = "" ]; then
        echo "No PR open against $head"
    else
        echo "Found a PR open again $head; closing it..."

        o=$(gh api \
        --method PATCH \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        repos/$REPO_NWO/pulls/$PR_NUMBER \
        -f state='closed')
    fi
done

# Create main branch
git fetch origin __demo/setup
git checkout -B main origin/__demo/setup
git commit --allow-empty -m "Empty commit to ensure new refs and checks are always run"
git push origin main --force -u

for head in "${heads[@]}"
do
    # PR A (adds checks to "calculate" function that changes its behavior)
    git fetch origin "__demo/$head"
    git checkout -B "$head" "origin/__demo/$head"
    git push origin "$head" --force -u
    gh pr create --fill
done
