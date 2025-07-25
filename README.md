I used this repo to avoid the dreaded string of "fix build" commits in a repo I care about.

### 1. Tagging script and tagging with GITHUB_TOKEN

Combination of `.github/find-next.tag.sh` and the `release.yml` workflow, with `permissions.contents: write`. Nailed
it on the first try, hooray! This version is available as `release-simple.yml`.

The above evolved into:

### 2. Using the GitHub DEPLOY_TOKEN for pushing the tag

The driver here is rulesets: you can create a tag protection rule that blocks tagging by anyone except an allowlist,
but you cannot add the `GITHUB_TOKEN` to that allowlist. You **can** add deploy keys. So I generated a key pair, added
the public key as a deploy key and the private key as a build secret. Having an SSH key at hand anyway, might as well
sign the tag, so that's there too.

Whether it's a good idea to use this bit is left to the reader.
