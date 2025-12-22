# Model Context Protocol (MCP) Configuration

This project uses MCP servers to enhance AI assistant capabilities.

## Configured MCP Servers

### SwiftLens
**Purpose**: Semantic-level Swift code analysis with SourceKit-LSP integration

**Configuration**:
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

**Features**:
- Compiler-grade Swift code understanding
- Symbol references and definitions
- Type information and hover documentation
- Cross-file analysis
- Safe code modifications

**Setup**:
1. Add configuration to your MCP settings file
2. Build the iOS project to generate SourceKit index
3. Restart your AI assistant

**Requirements**:
- macOS (required for SourceKit-LSP)
- Python 3.10+
- Xcode (full installation)

**Documentation**: https://github.com/swiftlens/swiftlens

## Configuration Files by Platform

### Claude Desktop
Location: `~/Library/Application Support/Claude/claude_desktop_config.json`

### Cursor
Location: `.cursor/mcp.json` (project-specific) or global settings

### Windsurf
Location: Global MCP settings in application

## Initial Setup

### 1. Install Prerequisites
```bash
# Python (if not already installed)
brew install python@3.10

# Xcode should already be installed
xcode-select -p  # Verify Xcode installation
```

### 2. Configure MCP Server

Add the SwiftLens configuration to your AI assistant's MCP settings.

### 3. Build iOS Project Index

```bash
cd ios
xcodebuild -project SomeSuperApp.xcodeproj \
  -scheme SomeSuperApp \
  -sdk iphonesimulator \
  build
```

### 4. Verify Setup

Ask your AI assistant:
```
"Run swift_check_environment to verify SwiftLens is working"
```

## Usage Examples

### Analyze a Swift file
```
"Analyze ContentView.swift and show me its structure"
```

### Find references
```
"Find all references to the ContentView struct"
```

### Get type information
```
"What's the type of the body property in ContentView?"
```

### Build index
```
"Run swift_build_index to update the project index"
```

## Troubleshooting

### "Symbol not found"
Rebuild the index:
```bash
cd ios
xcodebuild -project SomeSuperApp.xcodeproj -scheme SomeSuperApp build
```

### "SourceKit-LSP not found"
Verify Xcode installation:
```bash
xcode-select -p
xcrun sourcekit-lsp --help
```

### "Command not found: uvx"
Install uv (Python package manager):
```bash
curl -LsSf https://astral.sh/uv/install.sh | sh
```

## Adding More MCP Servers

To add additional MCP servers:

1. Add configuration to MCP settings
2. Document in this file
3. Update ios/README.md if iOS-specific
4. Test with AI assistant

## Resources

- [MCP Protocol Documentation](https://modelcontextprotocol.io/)
- [SwiftLens GitHub](https://github.com/swiftlens/swiftlens)
- [MCP Servers List](https://github.com/modelcontextprotocol/servers)
