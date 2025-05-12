#!/usr/bin/env bash
set -e

# Configuration\HEROKU_APP="openfresk"\HEROKU_REMOTE="heroku"\HEROKU_MAIN_BRANCH="main"
SOURCE_BRANCH="chore/stable"
PREFIX="test/dummy"
DEPLOY_BRANCH="deploy"

# 1. Split the dummy app into a temporary deploy branch
echo "Splitting subtree from '$PREFIX' of branch '$SOURCE_BRANCH' into temporary branch '$DEPLOY_BRANCH'..."
git subtree split --prefix "$PREFIX" "$SOURCE_BRANCH" -b "$DEPLOY_BRANCH"

# 2. Push the deploy branch to Heroku's main branch with force update
echo "Pushing '$DEPLOY_BRANCH' to $HEROKU_REMOTE/$HEROKU_APP:$HEROKU_MAIN_BRANCH (force)..."
git push "$HEROKU_REMOTE" "$DEPLOY_BRANCH":$HEROKU_MAIN_BRANCH --force -a "$HEROKU_APP"

# 3. Clean up: delete the temporary deploy branch
echo "Deleting temporary branch '$DEPLOY_BRANCH'..."
git branch -D "$DEPLOY_BRANCH"

# Done
echo "Successfully deployed '$SOURCE_BRANCH' to Heroku app '$HEROKU_APP'."
