# Release Process

## Overview
PullMaster uses automated release packaging via GitHub Actions and the BigWigs packager.

## Prerequisites
- Write access to the repository
- GitHub secrets configured:
  - `CF_API_KEY` (if using CurseForge)
  - `WOWI_API_TOKEN` (if using WoWInterface)

## Creating a Release

1. Update version number:
   - Update `## Version: @project-version@` in `PullMaster.toc`
   - Update CHANGELOG.md with new version

2. Create and push a tag:
   ```bash
   git tag -a v1.0.0 -m "Release version 1.0.0"
   git push origin v1.0.0
   ```

3. The GitHub Action will automatically:
   - Package the addon
   - Create a GitHub release
   - Upload release artifacts
   - Deploy to configured platforms

## Release Checklist
- [ ] Update CHANGELOG.md
- [ ] Test all changes
- [ ] Create and push tag
- [ ] Verify GitHub Action completion
- [ ] Test released package

## Troubleshooting
1. Check GitHub Actions logs for errors
2. Verify .pkgmeta configuration
3. Ensure all required files are committed

## Version Numbering
We follow semantic versioning:
- MAJOR.MINOR.PATCH
- Example: 1.0.0