# frontend_flutter

A Flutter project providing multi-platform support for Web and mobile applications (iOS and Android).

## Architecture

### Bloc

This application is based on [bloc](https://bloclibrary.dev/#/) state management for decoupling UI and business logic.

## Authentication

This application provides authentication via [OAuth 2.0 code flow](https://auth0.com/docs/get-started/authentication-and-authorization-flow/authorization-code-flow) using the following
frameworks:
- Web: [oauth2](https://pub.dev/packages/oauth2)
- iOS / Android: [flutter_appauth](https://pub.dev/packages/flutter_appauth)

To use authentication in DEV mode we need a running Keycloak server with a configuration matching our set configuration in [config folder](/assets/config).
