# GitHub Actions Update - January 2025

## Issue Fixed
GitHub Actions was failing with the error:
```
This request has been automatically failed because it uses a deprecated version of `actions/upload-artifact: v3`
```

## Root Cause
According to the [GitHub changelog](https://github.blog/changelog/2024-04-16-deprecation-notice-v3-of-the-artifact-actions/), GitHub deprecated v3 of artifact actions on **January 30, 2025**. Our workflows were using deprecated versions that are no longer supported.

## Changes Made

### 1. Updated `.github/workflows/test.yml`
- ✅ `actions/cache@v3` → `actions/cache@v4`
- ✅ `actions/upload-artifact@v3` → `actions/upload-artifact@v4`
- ✅ `pnpm/action-setup@v2` → `pnpm/action-setup@v4`

### 2. Updated `.github/workflows/publish.yml`
- ✅ `actions/cache@v3` → `actions/cache@v4`
- ✅ `actions/create-release@v1` → `softprops/action-gh-release@v2`
- ✅ `pnpm/action-setup@v2` → `pnpm/action-setup@v4`

### 3. Updated Documentation
- Updated `PUBLISHING.md` to include troubleshooting for deprecated actions

## Benefits of v4 Actions
According to GitHub's changelog:
- **98% faster** upload and download speeds
- New features and improvements
- Better reliability and performance

## Action Items Completed
- [x] Fixed deprecated artifact actions
- [x] Updated cache actions to v4
- [x] Updated PNPM setup action
- [x] Replaced deprecated create-release action
- [x] Validated YAML syntax
- [x] Updated documentation

## Testing
Both workflow files have been validated for correct YAML syntax and should now work without the deprecation errors.

## Next Steps
1. Commit and push these changes to fix the GitHub Actions failures
2. Test workflows by creating a pull request or triggering manually
3. Monitor for any remaining issues

## References
- [Deprecation notice: v3 of the artifact actions](https://github.blog/changelog/2024-04-16-deprecation-notice-v3-of-the-artifact-actions/)
- [Deprecation notice: v1 and v2 of the artifact actions](https://github.blog/changelog/2024-02-13-deprecation-notice-v1-and-v2-of-the-artifact-actions/)
- [Actions Documentation](https://docs.github.com/en/actions)