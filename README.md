# HashiCorp Vault N8N Node

![n8n.io - Workflow Automation](https://raw.githubusercontent.com/n8n-io/n8n/master/assets/n8n-logo.png)

A community node for N8N that provides integration with HashiCorp Vault, supporting both AppRole and Token authentication methods.

## Features

- ✅ **AppRole Authentication** - Secure authentication using Role ID and Secret ID
- ✅ **Token Authentication** - Direct token-based authentication
- ✅ **KV Secrets Engine Support** - Works with both v1 and v2 KV engines
- ✅ **Multiple Operations** - Read, Write, Delete, and List secrets
- ✅ **Namespace Support** - Enterprise namespace support
- ✅ **SSL Configuration** - Custom SSL certificate support
- ✅ **Error Handling** - Comprehensive error handling and validation

## Installation

### Community Nodes Installation

1. Go to your N8N instance
2. Navigate to **Settings** → **Community Nodes**
3. Click **Install a community node**
4. Enter: `n8n-nodes-hashicorp-vault`
5. Click **Install**

### Manual Installation

```bash
# In your n8n installation directory
npm install n8n-nodes-hashicorp-vault
```

### Docker Installation

If you're using N8N with Docker, you can install the node by building a custom image:

```dockerfile
FROM n8nio/n8n
RUN npm install -g n8n-nodes-hashicorp-vault
```

## Configuration

### 1. Create HashiCorp Vault Credentials

1. In N8N, go to **Credentials** → **Create New**
2. Search for "HashiCorp Vault API"
3. Configure the following:

#### Basic Settings
- **Vault URL**: Your Vault instance URL (e.g., `https://vault.example.com:8200`)
- **Authentication Method**: Choose between `AppRole` or `Token`

#### AppRole Authentication
- **Role ID**: Your AppRole Role ID
- **Secret ID**: Your AppRole Secret ID

#### Token Authentication
- **Token**: Your Vault token

#### Optional Settings
- **Namespace**: Vault namespace (Enterprise feature)
- **API Version**: Choose between `v1` or `v2` (default: v2)
- **Ignore SSL Issues**: Enable for self-signed certificates

### 2. HashiCorp Vault Setup

#### AppRole Setup Example

```bash
# Enable AppRole auth method
vault auth enable approle

# Create a policy
vault policy write myapp-policy - <<EOF
path "secret/data/myapp/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}
EOF

# Create an AppRole
vault write auth/approle/role/n8n-role \
    token_policies="myapp-policy" \
    token_ttl=1h \
    token_max_ttl=4h

# Get Role ID
vault read auth/approle/role/n8n-role/role-id

# Generate Secret ID
vault write -f auth/approle/role/n8n-role/secret-id
```

## Usage

### Available Operations

#### 1. Read Secret
Retrieve a secret from Vault.

**Parameters:**
- **Secret Engine**: Name of the secrets engine (e.g., `secret`)
- **Secret Path**: Path to the secret (e.g., `myapp/database`)
- **Version**: Specific version to read (0 for latest, KV v2 only)

**Example Output:**
```json
{
  "data": {
    "username": "admin",
    "password": "secret123"
  },
  "metadata": {
    "version": 1,
    "created_time": "2023-01-01T00:00:00Z"
  }
}
```

#### 2. Write Secret
Store a secret in Vault.

**Parameters:**
- **Secret Engine**: Name of the secrets engine
- **Secret Path**: Path where to store the secret
- **Secret Data**: JSON object containing the secret data

**Example Secret Data:**
```json
{
  "username": "admin",
  "password": "secret123",
  "url": "https://database.example.com"
}
```

#### 3. Delete Secret
Delete a secret from Vault.

**Parameters:**
- **Secret Engine**: Name of the secrets engine
- **Secret Path**: Path to the secret to delete

#### 4. List Secrets
List all secrets at a given path.

**Parameters:**
- **Secret Engine**: Name of the secrets engine
- **List Path**: Path to list secrets from

### Example Workflows

#### Example 1: Read Database Credentials
```json
{
  "nodes": [
    {
      "name": "Get DB Credentials",
      "type": "n8n-nodes-hashicorp-vault.hashiCorpVault",
      "parameters": {
        "operation": "readSecret",
        "secretEngine": "secret",
        "secretPath": "myapp/database"
      },
      "credentials": {
        "hashiCorpVaultApi": "vault-credentials"
      }
    }
  ]
}
```

#### Example 2: Store API Key
```json
{
  "nodes": [
    {
      "name": "Store API Key",
      "type": "n8n-nodes-hashicorp-vault.hashiCorpVault",
      "parameters": {
        "operation": "writeSecret",
        "secretEngine": "secret",
        "secretPath": "myapp/api-keys",
        "secretData": "{\"api_key\": \"sk-1234567890\", \"environment\": \"production\"}"
      },
      "credentials": {
        "hashiCorpVaultApi": "vault-credentials"
      }
    }
  ]
}
```

## Development

### Prerequisites

- Node.js 18+
- pnpm 9+
- N8N development environment

### Setup

```bash
# Clone the repository
git clone https://github.com/imitruk/hashicorp_n8n_node.git
cd hashicorp_n8n_node

# Install dependencies
pnpm install

# Build the project
pnpm run build

# Link for local development
npm link

# In your n8n directory
npm link n8n-nodes-hashicorp-vault
```

### Scripts

- `pnpm run build` - Build the project
- `pnpm run dev` - Build in watch mode
- `pnpm run lint` - Run ESLint
- `pnpm run lintfix` - Fix ESLint issues
- `pnpm run format` - Format code with Prettier

## Publishing

### Automated Publishing (GitHub Actions)

The project includes GitHub Actions for automated publishing:

1. **On Release**: Automatically publishes when a new GitHub release is created
2. **Manual Trigger**: Use the "Publish to npm" workflow with custom version

### Manual Publishing

Use the included script for manual publishing:

```bash
./scripts/publish-manual.sh
```

This script will:
- Check environment setup
- Allow version bumping
- Run linting and formatting
- Build the project
- Publish to npm
- Provide next steps for GitHub release

### Publishing Checklist

1. Update version in `package.json`
2. Run tests and linting
3. Build the project
4. Publish to npm
5. Create GitHub release
6. Update documentation

## Troubleshooting

### Common Issues

#### SSL Certificate Issues
If you're using self-signed certificates, enable "Ignore SSL Issues" in the credentials.

#### AppRole Authentication Fails
- Verify Role ID and Secret ID are correct
- Check that the AppRole has necessary policies
- Ensure the Secret ID hasn't expired

#### Connection Timeouts
- Check Vault URL is accessible from N8N
- Verify network connectivity
- Increase timeout in Additional Fields

#### Permission Denied
- Verify the token/AppRole has necessary permissions
- Check Vault policies
- Ensure the secret path exists

### Debug Mode

Enable debug logging in N8N to see detailed request/response information:

```bash
export N8N_LOG_LEVEL=debug
```

## Security Considerations

1. **Credential Storage**: N8N encrypts stored credentials
2. **Network Security**: Use HTTPS for Vault communication
3. **Token Lifecycle**: Regularly rotate AppRole Secret IDs
4. **Least Privilege**: Grant minimal necessary permissions
5. **Audit Logging**: Enable Vault audit logging

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Run linting and formatting
6. Submit a pull request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Support

- 📖 [N8N Documentation](https://docs.n8n.io)
- 📖 [HashiCorp Vault Documentation](https://www.vaultproject.io/docs)
- 🐛 [Issue Tracker](https://github.com/imitruk/hashicorp_n8n_node/issues)
- 💬 [N8N Community Forum](https://community.n8n.io)

## Changelog

### v1.0.0
- Initial release
- AppRole and Token authentication support
- KV v1 and v2 support
- Read, Write, Delete, List operations
- Namespace support
- SSL certificate support