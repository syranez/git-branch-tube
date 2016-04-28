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

# intern: max branch name
max_branch=1;

# creates the repo directory and initialises git
function init {

    mkdir "${REPOSITORY_DIR}";
    cd "${REPOSITORY_DIR}";

    git init
}

# makes a checkout or checkout -b
function decideBackOrForward {

    if [ "${current_branch}" -eq "2" ]; then
        git checkout master;
        git merge "$current_branch" --no-ff -m "Merge: $(npm run -s lorem-ipsum 1 sentence)";
    elif [ "${current_branch}" -gt "2" ]; then
        git checkout $((current_branch - 1));
        git merge "$current_branch" --no-ff -m "Merge: $(npm run -s lorem-ipsum 1 sentence)";
    fi

    if [ "${RANDOM: -1}" -gt 6 ]; then
        if [ "${current_branch}" -gt "2" ]; then
            tmp=$RANDOM;
            tmp2=$((current_branch - 1))
            let "tmp %= ${tmp2}";
            current_branch=$((current_branch - tmp));
        fi
    else
        current_branch=$((current_branch + 1));
        max_branch=${current_branch};
        git branch "${current_branch}";
    fi

    git checkout "${current_branch}";
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

        decideBackOrForward
    done;
}

createRepo "${MAX_ACTIONS}" "${MAX_COMMITS_PER_ACTION}";
