# Quick Setup Guide

This document provides a quick setup guide for the HashiCorp Vault N8N Node project.

## Project Structure

```
hashicorp_n8n_node/
├── .github/workflows/          # GitHub Actions for CI/CD
│   ├── publish.yml            # Automated publishing workflow
│   └── test.yml              # Testing and linting workflow
├── __tests__/                 # Test files
├── credentials/               # N8N credential definitions
│   └── HashiCorpVaultApi.credentials.ts
├── nodes/                     # N8N node implementations
│   └── HashiCorpVault/
│       ├── HashiCorpVault.node.ts
│       └── hashicorp.svg
├── scripts/                   # Helper scripts
│   └── publish-manual.sh     # Manual publishing script
├── dist/                     # Built files (generated)
├── package.json              # Project configuration
├── tsconfig.json            # TypeScript configuration
├── gulpfile.js              # Build configuration
├── jest.config.js           # Test configuration
├── .eslintrc.js            # Linting configuration
├── .prettierrc             # Code formatting configuration
├── .gitignore              # Git ignore rules
├── LICENSE                 # MIT License
├── README.md               # Main documentation
├── PUBLISHING.md           # Publishing guide
└── SETUP.md                # This file
```

## Quick Start

1. **Install dependencies:**
   ```bash
   npm install
   ```

2. **Build the project:**
   ```bash
   npm run build
   ```

3. **Link for local development:**
   ```bash
   npm link

   # In your n8n directory
   npm link n8n-nodes-hashicorp-vault
   ```

4. **Restart N8N to load the node**

## Development Commands

- `npm run build` - Build the project
- `npm run dev` - Build in watch mode
- `npm run lint` - Run ESLint
- `npm run lintfix` - Fix ESLint issues
- `npm run format` - Format code with Prettier
- `npm run test` - Run tests

## Publishing

### Automated (Recommended)
1. Push to GitHub
2. Create a release or use GitHub Actions workflow

### Manual
```bash
./scripts/publish-manual.sh
```

## Node Features

✅ **AppRole Authentication** - Secure authentication using Role ID and Secret ID
✅ **Token Authentication** - Direct token-based authentication
✅ **KV Secrets Engine Support** - Works with both v1 and v2 KV engines
✅ **Multiple Operations** - Read, Write, Delete, and List secrets
✅ **Namespace Support** - Enterprise namespace support
✅ **SSL Configuration** - Custom SSL certificate support
✅ **Error Handling** - Comprehensive error handling and validation

## Next Steps

1. Test the node in your N8N instance
2. Set up GitHub repository with secrets for automated publishing
3. Configure HashiCorp Vault with appropriate policies
4. Create your first workflow using the node

For detailed usage instructions, see [README.md](README.md).
For publishing instructions, see [PUBLISHING.md](PUBLISHING.md).