#!/bin/bash
set -ev
# ONLY DEPLOY tags from master
if ([ "$TRAVIS_BRANCH" == "master" ] || [ ! -z "$TRAVIS_TAG" ]) &&
       [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
    openssl aes-256-cbc -K $encrypted_d7e5bf3dfc23_key -iv $encrypted_d7e5bf3dfc23_iv -in deploy-key.enc -out deploy-key -d
    chmod 600 deploy-key
    eval `ssh-agent -s`
    ssh-add deploy-key
    git config user.name "Automatic Publish"
    git config user.email "bgcook@lbl.gov"
    git remote add gh-token "${GH_REF}";
    git fetch gh-token && git fetch gh-token gh-pages:gh-pages;
    PYTHONPATH=src/ mkdocs gh-deploy -v --clean --remote-name gh-token
    git push gh-token gh-pages    
fi
