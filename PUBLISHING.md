# Publishing Guide

This document provides detailed instructions for publishing the HashiCorp Vault N8N Node.

## Prerequisites

### 1. NPM Account Setup
- Create an account at [npmjs.com](https://www.npmjs.com)
- Verify your email address
- Enable two-factor authentication (recommended)

### 2. GitHub Setup
- Fork or have access to the repository
- Set up the following secrets in GitHub repository settings:
  - `NPM_TOKEN`: Your npm authentication token
  - `GITHUB_TOKEN`: Automatically provided by GitHub Actions

### 3. Local Development Setup
```bash
# Install dependencies
pnpm install

# Login to npm
npm login

# Verify login
npm whoami
```

## Publishing Methods

### Method 1: Automated Publishing via GitHub Actions

#### Option A: Release-triggered Publishing
1. Create a new release on GitHub:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
2. Go to GitHub repository → Releases → Create new release
3. Select the tag you created
4. Fill in release notes
5. Publish the release
6. GitHub Actions will automatically publish to npm

#### Option B: Manual Workflow Trigger
1. Go to GitHub repository → Actions
2. Select "Publish to npm" workflow
3. Click "Run workflow"
4. Optionally specify a version number
5. Click "Run workflow" button

### Method 2: Manual Publishing

#### Using the Automated Script
```bash
./scripts/publish-manual.sh
```

The script will guide you through:
- Version bumping options
- Dependency installation
- Linting and formatting
- Building
- Publishing confirmation

#### Manual Step-by-Step
```bash
# 1. Update version
npm version patch # or minor, major

# 2. Install dependencies
pnpm install --frozen-lockfile

# 3. Run quality checks
pnpm run lint
pnpm run format

# 4. Build
pnpm run build

# 5. Test build
npm pack --dry-run

# 6. Publish
npm publish --access public
```

## Version Management

### Semantic Versioning
Follow [semantic versioning](https://semver.org/):
- **MAJOR**: Breaking changes
- **MINOR**: New features (backward compatible)
- **PATCH**: Bug fixes (backward compatible)

### Version Bump Commands
```bash
npm version patch   # 1.0.0 → 1.0.1
npm version minor   # 1.0.0 → 1.1.0
npm version major   # 1.0.0 → 2.0.0
npm version 1.2.3   # Specific version
```

## Pre-Publishing Checklist

### Code Quality
- [ ] All TypeScript compiles without errors
- [ ] ESLint passes without errors
- [ ] Code is formatted with Prettier
- [ ] All tests pass (if applicable)

### Documentation
- [ ] README.md is up to date
- [ ] CHANGELOG.md includes new changes
- [ ] Version number matches release notes

### Package Configuration
- [ ] package.json version is correct
- [ ] Dependencies are up to date
- [ ] Files array includes only necessary files
- [ ] N8N configuration is correct

### Testing
- [ ] Build succeeds (`pnpm run build`)
- [ ] Package can be installed locally
- [ ] Node works in N8N environment
- [ ] All operations function correctly

## Post-Publishing Steps

### 1. GitHub Release
If not using automated publishing:
```bash
git add package.json
git commit -m "Release v1.0.0"
git tag v1.0.0
git push origin main --tags
```

Create GitHub release with:
- Tag version
- Release title
- Detailed changelog
- Installation instructions

### 2. Documentation Updates
- Update any external documentation
- Notify community channels if applicable
- Update examples if needed

### 3. Verification
- Check package appears on [npmjs.com](https://www.npmjs.com/package/n8n-nodes-hashicorp-vault)
- Test installation in fresh N8N instance
- Verify all functionality works

## Troubleshooting

### Common Publishing Issues

#### Authentication Errors
```bash
# Re-login to npm
npm logout
npm login

# Check authentication
npm whoami
```

#### Build Failures
```bash
# Clean build
rm -rf dist node_modules
pnpm install
pnpm run build
```

#### Version Conflicts
```bash
# Check current published version
npm view n8n-nodes-hashicorp-vault version

# List all versions
npm view n8n-nodes-hashicorp-vault versions --json
```

#### GitHub Actions Failures
1. Check workflow logs in GitHub Actions tab
2. Verify secrets are set correctly
3. Ensure package.json version is unique
4. Check for linting/build errors

### Recovery Procedures

#### Unpublish Package (within 24 hours)
```bash
npm unpublish n8n-nodes-hashicorp-vault@1.0.0
```

#### Deprecate Version
```bash
npm deprecate n8n-nodes-hashicorp-vault@1.0.0 "This version has critical bugs"
```

## Security Considerations

### NPM Token Security
- Use automation tokens for CI/CD
- Set appropriate token permissions
- Rotate tokens regularly
- Never commit tokens to repository

### Package Security
- Regularly update dependencies
- Use `npm audit` to check for vulnerabilities
- Consider using `npm audit fix`
- Review dependency licenses

## Maintenance

### Regular Tasks
- Update dependencies monthly
- Review and respond to issues
- Update documentation as needed
- Monitor package download statistics

### Monitoring
- Watch for security advisories
- Monitor N8N compatibility
- Check for breaking changes in dependencies
- Review user feedback and issues

## Resources

- [NPM Publishing Guide](https://docs.npmjs.com/packages-and-modules/contributing-packages-to-the-registry)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [N8N Community Node Guidelines](https://docs.n8n.io/integrations/community-nodes/)
- [Semantic Versioning](https://semver.org/)