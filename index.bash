#! /usr/bin/env bash
#

# directory in which a repo is created
REPOSITORY_DIR="repository";

# maximum number of actions
MAX_ACTIONS=500;

# maximum commits per action
MAX_COMMITS_PER_ACTION=10;

# intern: current branch name
current_branch=1;

# creates the repo directory and initialises git
function init {

    mkdir "${REPOSITORY_DIR}";
    cd "${REPOSITORY_DIR}";

    git init
}

# makes a merge or branch
function decideBranchOrMerge {

    number=$RANDOM;
    let "number >>= 14"
    if [ "$number" -eq 1 ]; then

        if [ "$current_branch" -eq "2" ]; then
            git checkout master;
            git merge "$current_branch" --no-ff -m "Merge: $(npm run -s lorem-ipsum 1 sentence)";
            current_branch=1;
        else 
            git checkout $((current_branch - 1));
            git merge "$current_branch" --no-ff -m "Merge: $(npm run -s lorem-ipsum 1 sentence)";
            current_branch=$((current_branch - 1));
        fi
    else
        current_branch=$((current_branch + 1));
        git branch "$current_branch";
        git checkout "$current_branch";
    fi
}

# creates $1 commit objects
function createCommits {

    local i=1;
    for ((i=1; i <= "${1}"; i++)); do
        echo "${i}" >> "${current_branch}";
        git add "${current_branch}";
        git commit -m "$(npm run -s lorem-ipsum 1 sentence)" >/dev/null;
    done;
}

# creates a git repo with branches and merges
function createRepo {

    init;

    local i=1;
    for ((i=1; i <= "${1}"; i++)); do

        # how many commits
        count=$RANDOM
        let "count %= ""${2}";

        echo "Creating ${count} commits."
        createCommits "${count}";

        decideBranchOrMerge
    done;
}

createRepo "${MAX_ACTIONS}" "${MAX_COMMITS_PER_ACTION}";
