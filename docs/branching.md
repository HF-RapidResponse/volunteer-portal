## Branching and GitHub

You should already know where this repo is on GitHub, but for easy reference, it can be found [here](https://github.com/HF-RapidResponse/volunteer-portal)

Once you figured out a coding a task to do, you need to create a branch to do your work. The default top-level branch is `master`. We do not push code directly to master! The code in this branch has been tested in the `staging` branch below it as well as the one more branch a level below by a developer who has merged that branch to `staging`. On a basic level, the hierarchy is `master > staging > your_branch`. `Master` and `staging` each have their own domains once deployed:

- Master: https://volunteers.movehumanityforward.com/
- Staging: http://vol-dev.movehumanityforward.com/

As we expand on features, we may have branches several levels below staging. In that case, we'd keep one branch around for a while and merge to that branch first before merging to staging upon completion of that feature. Example: a feature branch would be created in `master > staging > big_feature_1`. As developers finish sub-tasks, they will pull from the latest `big_feature_1` and merge pull requests to that. Example: `big_feature_1 > task_1`.

When you're finished with a branch, please delete it on GitHub. If we allow branches to stay there over time, the repo will become messy. If you have a branch locally, it will remain there even after deleting the branch on GitHub as long as you don't delete the local branch. If you wish to reuse a previously deleted branch, you can later on push up code through that branch.
