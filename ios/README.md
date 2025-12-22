# Some SuperApp - iOS

Native iOS application built with SwiftUI and CloudKit.

## Requirements

- Xcode 26.0+
- iOS 18.0+
- Swift 6.0+
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) 2.44.1+
- (Optional) [SwiftLens MCP](https://github.com/swiftlens/swiftlens) - For AI-powered Swift code analysis

## Setup

### 1. Install XcodeGen

```bash
brew install xcodegen
```

### 2. Generate Xcode Project

The Xcode project files (`.xcodeproj`) are not committed to version control. Instead, we use XcodeGen to generate them from `project.yml`:

```bash
cd ios
xcodegen generate
```

This will create `SomeSuperApp.xcodeproj` in the `ios/` directory.

### 3. Open in Xcode

```bash
open SomeSuperApp.xcodeproj
```

Or double-click the generated `.xcodeproj` file.

### 4. Configure Signing

1. Select the `SomeSuperApp` project in Xcode
2. Select the `SomeSuperApp` target
3. Go to "Signing & Capabilities"
4. Set your development team
5. Ensure "Automatically manage signing" is checked

### 5. Build and Run

- Select a simulator or device

### 6. (Optional) Set Up SwiftLens MCP

SwiftLens provides semantic-level Swift code analysis that works with GitHub Copilot in VS Code, Claude Desktop, Cursor, and other MCP-compatible clients.

**Quick Setup (VS Code / GitHub Copilot)**:

1. Install an MCP extension for VS Code:
   - **Continue** (recommended, has built-in MCP support)
   - Or search "MCP" in VS Code Extensions

2. The project already has `.vscode/mcp.json` configured with SwiftLens

3. Build the iOS project index:
   ```bash
   cd ios
   xcodebuild -project SomeSuperApp.xcodeproj \
     -scheme SomeSuperApp \
     -sdk iphonesimulator \
     build
   ```

4. Restart VS Code and start using it:
   ```
   "Analyze ContentView.swift structure"
   "Find all references to the ContentView struct"
   "What's the type of the body property?"
   ```

**For other clients** (Claude Desktop, Cursor, etc.):
See [docs/MCP_SETUP.md](../docs/MCP_SETUP.md)
- Press `Cmd + R` or click the Play button

## Project Structure

```
ios/
├── project.yml                 # XcodeGen configuration
├── SomeSuperApp/              # Main app target
│   ├── SomeSuperAppApp.swift # App entry point
│   ├── ContentView.swift      # Main view
│   ├── Assets.xcassets/       # App assets
│   └── SomeSuperApp.entitlements  # CloudKit entitlements
├── SomeSuperAppTests/         # Unit tests
└── SomeSuperAppUITests/       # UI tests
```

## XcodeGen Workflow

### Why XcodeGen?

- **Cleaner Git History**: `.xcodeproj` files are XML and binary, causing merge conflicts
- **Declarative Configuration**: Project structure defined in readable YAML
- **Consistency**: Ensures all developers have identical project settings
- **CI/CD Friendly**: Easy to regenerate projects in build pipelines

### Making Changes

1. **Add Files**: Just add `.swift` files to the appropriate directory
2. **Regenerate**: Run `xcodegen generate` to update the project
3. **Commit**: Only commit source files and `project.yml`, not `.xcodeproj`

### Common XcodeGen Commands

```bash
# Generate project
xcodegen generate

# Generate with verbose output
xcodegen generate --verbose

# Validate project.yml without generating
xcodegen generate --only-plists
```

## Building from Command Line

### Build

```bash
xcodebuild -project SomeSuperApp.xcodeproj \
  -scheme SomeSuperApp \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.5' \
  build
```

### Run Tests

```bash
xcodebuild test \
  -project SomeSuperApp.xcodeproj \
  -scheme SomeSuperApp \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.5'
```

## CloudKit Setup

The app is configured with CloudKit entitlements:

- **Container**: `iCloud.com.patterueldev.somesuperapp`
- **Services**: CloudKit
- **Key-Value Store**: Enabled

You'll need to:
1. Be signed in with an Apple ID in Xcode
2. Have a valid development team
3. CloudKit container will be created automatically on first build

## Architecture

- **UI Framework**: SwiftUI
- **Architecture Pattern**: TBD (MVVM/MV/TCA)
- **Data Layer**: TBD (SwiftData/Core Data)
- **Sync**: CloudKit Private Database
- **Minimum iOS Version**: 18.0

SeeSwiftLens MCP Integration

SwiftLens provides AI assistants with deep understanding of Swift code:

### What is SwiftLens?

SwiftLens is a Model Context Protocol (MCP) server that bridges AI models with Apple's SourceKit-LSP for semantic-level code analysis.

### Available Tools

**Single-File Analysis** (no index required):
- `swift_analyze_file` - Analyze structure and symbols
- `swift_summarize_file` - Get symbol counts and overview
- `swift_validate_file` - Validate syntax with swiftc
- `swift_check_environment` - Verify Swift setup

**Cross-File Analysis** (requires index):
- `swift_find_symbol_references` - Find all references
- `swift_get_symbol_definition` - Jump to definition
- `swift_get_hover_info` - Get type info

**Code Modification**:
- `swift_replace_symbol_body` - Safe symbol replacement

### Building the Index

SwiftLens needs an index for cross-file analysis:

```bash
# From ios/ directory
xcodebuild -project SomeSuperApp.xcodeproj \
  -scheme SomeSuperApp \
  -sdk iphonesimulator \
  build
```

Or ask your AI: `"Build the Swift index for this project"`

### When to Rebuild Index

- After adding new Swift files
- After changing public interfaces  
- If symbol references are missing

### Configuration

Add to your MCP configuration file (e.g., `~/Library/Application Support/Claude/claude_desktop_config.json`):

```json
{
  "mcpServers": {
    "swiftlens": {
      "command": "uvx",
      "args": ["swiftlens"]
    }
  }
}
```

Restart your AI assistant after configuration changes.

## Resources

- [XcodeGen Documentation](https://github.com/yonaskolb/XcodeGen/blob/master/Docs/ProjectSpec.md)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [CloudKit Documentation](https://developer.apple.com/documentation/cloudkit/)
- [SwiftLens MCP Server](https://github.com/swiftlens/swiftlens) - Swift code analysis for AI

1. Create feature files in `SomeSuperApp/`
2. Run `xcodegen generate` to update project
3. Build and test

### Modifying Project Configuration

1. Edit `project.yml`
2. Run `xcodegen generate`
3. Verify changes in Xcode

### Common Configurations in project.yml

- **Targets**: Define app, test, and extension targets
- **Settings**: Build settings, deployment targets
- **Info.plist**: App metadata and permissions
- **Entitlements**: CloudKit, iCloud, push notifications
- **Schemes**: Build configurations and test plans

## Troubleshooting

### Project Not Found

Run `xcodegen generate` to create the `.xcodeproj` file.

### Build Errors After Pulling

Regenerate the project: `xcodegen generate`

### Signing Issues

1. Check your development team in Xcode
2. Ensure you're signed in with your Apple ID
3. For CloudKit, ensure container identifier matches your team

### XcodeGen Errors

- Validate `project.yml` syntax (YAML)
- Check XcodeGen documentation: https://github.com/yonaskolb/XcodeGen
- Run with `--verbose` flag for detailed output

## Resources

- [XcodeGen Documentation](https://github.com/yonaskolb/XcodeGen/blob/master/Docs/ProjectSpec.md)
- [SwiftUI Documentation](https://developer.apple.com/documentation/swiftui/)
- [CloudKit Documentation](https://developer.apple.com/documentation/cloudkit/)
