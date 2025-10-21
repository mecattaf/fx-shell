# Sway Integration Guide

## IPC Protocol Overview

Sway uses i3-compatible binary IPC protocol:
- Magic string: `i3-ipc`
- Message format: `<magic><length><type><payload>`
- Little-endian byte order
- JSON payloads

## Critical Message Types

```javascript
const SWAY_MESSAGES = {
    RUN_COMMAND: 0,
    GET_WORKSPACES: 1,
    SUBSCRIBE: 2,
    GET_OUTPUTS: 3,
    GET_TREE: 4,
    GET_MARKS: 5,
    GET_BAR_CONFIG: 6,
    GET_VERSION: 7
};

const SWAY_EVENTS = {
    WORKSPACE: 0x80000000,
    OUTPUT: 0x80000001,
    MODE: 0x80000002,
    WINDOW: 0x80000003,
    BARCONFIG_UPDATE: 0x80000004,
    BINDING: 0x80000005,
    SHUTDOWN: 0x80000006
};
```

## Reference Implementation

See Waybar's Sway integration:
- `/references/waybar/src/modules/sway/`
- Production-tested IPC handling
- Complete event subscription

## Key Patterns

### Event Subscription
Always subscribe to events during initialization:
```qml
Component.onCompleted: {
    ipcHandler.subscribe([
        "workspace",
        "window",
        "output"
    ])
}
```

### Workspace Management
Sway workspaces are numbered/named per output:
```qml
function switchWorkspace(identifier) {
    // identifier can be number or name
    ipcHandler.runCommand(`workspace ${identifier}`)
}
```

### Window Tree Traversal
Use recursive traversal for window tree:
```qml
function extractWindows(tree) {
    var windows = []

    function traverse(node) {
        if (node.type === "con" && node.name) {
            windows.push(node)
        }
        if (node.nodes) node.nodes.forEach(traverse)
        if (node.floating_nodes) node.floating_nodes.forEach(traverse)
    }

    traverse(tree)
    return windows
}
```

## Debugging

### Test IPC Manually
```bash
# Get socket path
echo $SWAYSOCK

# Test with swaymsg
swaymsg -t get_tree
swaymsg -t get_workspaces
swaymsg -t subscribe '["workspace"]'

# Monitor with socat
socat - UNIX-CONNECT:$SWAYSOCK
```

### Common Issues
1. **Socket not found**: Check $SWAYSOCK environment
2. **Event not received**: Verify subscription array
3. **Command failed**: Check Sway logs with `journalctl -u sway`
