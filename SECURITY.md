# Security Policy

## Supported Versions

| Version | Supported          |
| ------- | ------------------ |
| 2.2.6   | :white_check_mark: |
| 2.2.x   | :white_check_mark: |
| 2.1.x   | :x:                |
| < 2.1   | :x:                |

## Reporting a Vulnerability

If you discover a security vulnerability within SwiftQuantum, please report it responsibly:

1. **Do NOT** open a public GitHub issue
2. Email security concerns to the maintainer (see GitHub profile)
3. Include a detailed description of the vulnerability
4. Provide steps to reproduce if possible

We will acknowledge receipt within 48 hours and provide a more detailed response within 7 days.

## Security Best Practices

### Environment Variables

Never commit sensitive data. Use environment variables for:

```bash
# .env (never committed to git)
API_BASE_URL=https://api.swiftquantum.tech
BRIDGE_BASE_URL=https://bridge.swiftquantum.tech
IBM_QUANTUM_API_KEY=your_api_key_here
APP_STORE_KEY_ID=your_key_id
APP_STORE_ISSUER_ID=your_issuer_id
APP_STORE_PRIVATE_KEY_PATH=/path/to/key.p8
```

### API Keys

- Store API keys securely using iOS Keychain or environment variables
- Never hardcode API keys in source code
- Rotate keys periodically
- Use different keys for development and production

### Backend Security

- All API endpoints require authentication
- JWT tokens with short expiration
- HTTPS only (TLS 1.3)
- Rate limiting enabled
- Input validation on all endpoints

### StoreKit Security

- Server-side receipt validation
- Transaction verification with Apple Server API v2
- Secure JWT signing (ES256)

## Sensitive Files

The following files should NEVER be committed:

- `.env` - Environment variables
- `*.p8` - Apple private keys
- `*.pem` - SSL certificates
- `credentials.json` - API credentials
- `GoogleService-Info.plist` - Firebase config (if used)

## Code Security

### Input Validation

All user inputs are validated before processing:

```swift
// Example: Validate qubit count
guard numberOfQubits > 0, numberOfQubits <= 20 else {
    throw QuantumError.invalidQubitCount
}
```

### Network Security

- Certificate pinning for production
- Request signing for sensitive operations
- Timeout limits on all requests
- ExperienceAPIClient uses URLSession with secure defaults
- Local fallback ensures functionality without network exposure

### Experience API Security

The ExperienceAPIClient follows security best practices:

```swift
// Actor-based isolation prevents data races
public actor ExperienceAPIClient {
    // Auth token stored securely
    public var authToken: String?

    // HTTPS-only communication
    public var baseURL: String = "https://api.swiftquantum.tech"
}
```

- All Experience API endpoints use HTTPS
- Optional auth token for premium features
- No sensitive data stored locally
- Automatic local fallback protects user privacy

## Third-Party Dependencies

We regularly audit dependencies for vulnerabilities:

- StoreKit (Apple - trusted)
- Accelerate (Apple - trusted)
- Foundation (Apple - trusted)

## Contact

For security-related inquiries, please refer to the repository maintainer's contact information on GitHub.
