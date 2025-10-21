// commons/ServiceRegistry.qml
pragma Singleton
import QtQuick

QtObject {
    id: registry

    property var _services: ({})

    function registerService(name, service) {
        if (_services[name]) {
            console.warn(`[ServiceRegistry] Service '${name}' already registered, replacing`)
        }
        _services[name] = service
        console.log(`[ServiceRegistry] ✓ Registered: ${name}`)
    }

    function getService(name) {
        const service = _services[name]
        if (!service) {
            console.error(`[ServiceRegistry] Service '${name}' not found`)
            console.log(`[ServiceRegistry] Available services: ${Object.keys(_services).join(', ')}`)
        }
        return service
    }

    function unregisterService(name) {
        if (!_services[name]) {
            console.warn(`[ServiceRegistry] Service '${name}' not registered`)
            return
        }
        delete _services[name]
        console.log(`[ServiceRegistry] ✗ Unregistered: ${name}`)
    }

    function listServices() {
        return Object.keys(_services)
    }

    function hasService(name) {
        return _services.hasOwnProperty(name)
    }
}
