# Github Release

This action simply creates a GitHub release.

Note that when a GitHub release is created, it also automatically creates a git tag.  
This action can be configured to only publish a git tag without a GitHub release.

## Usage

See [action.yml](action.yml).

## Examples

```yml
---
name: "Base Branch"

on:
  push:
    branches:
      - master

jobs:
    release:
      name: Release
      runs-on: [ ubuntu, default ]
      timeout-minutes: 15
      steps:        
        - name: Github release
          uses: @phoenixtw/github-release@1.0
          with:
            access_token: ${{ secrets.GITHUB_TOKEN }}
            tag: v0.0.1
```

> Maintained by [Kaustav Chakraborty](https://github.com/phoenixTW)