// commons/Utils.qml
pragma Singleton
import QtQuick

QtObject {
    id: utils

    // String utilities
    function capitalizeFirst(str) {
        if (!str) return ""
        return str.charAt(0).toUpperCase() + str.slice(1)
    }

    function truncate(str, maxLength) {
        if (!str || str.length <= maxLength) return str
        return str.substring(0, maxLength - 3) + "..."
    }

    // Array utilities
    function unique(array) {
        return [...new Set(array)]
    }

    function sortBy(array, key) {
        return [...array].sort((a, b) => {
            const aVal = a[key]
            const bVal = b[key]
            if (aVal < bVal) return -1
            if (aVal > bVal) return 1
            return 0
        })
    }

    // Object utilities
    function deepClone(obj) {
        return JSON.parse(JSON.stringify(obj))
    }

    function merge(target, source) {
        const result = deepClone(target)
        for (const key in source) {
            if (source.hasOwnProperty(key)) {
                result[key] = source[key]
            }
        }
        return result
    }

    // Time utilities
    function formatTime(date, format24Hour) {
        const hours = date.getHours()
        const minutes = date.getMinutes()

        if (format24Hour) {
            return `${String(hours).padStart(2, '0')}:${String(minutes).padStart(2, '0')}`
        } else {
            const period = hours >= 12 ? 'PM' : 'AM'
            const hours12 = hours % 12 || 12
            return `${hours12}:${String(minutes).padStart(2, '0')} ${period}`
        }
    }

    function formatDate(date) {
        const days = ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday']
        const months = ['January', 'February', 'March', 'April', 'May', 'June',
                       'July', 'August', 'September', 'October', 'November', 'December']

        return `${days[date.getDay()]}, ${months[date.getMonth()]} ${date.getDate()}`
    }

    // Number utilities
    function clamp(value, min, max) {
        return Math.max(min, Math.min(max, value))
    }

    function lerp(start, end, t) {
        return start + (end - start) * clamp(t, 0, 1)
    }

    // File utilities
    function getFileName(path) {
        return path.split('/').pop()
    }

    function getFileExtension(path) {
        const parts = path.split('.')
        return parts.length > 1 ? parts.pop() : ""
    }

    // Debug utilities
    function log(component, message, level) {
        const levels = {
            info: "ℹ️",
            warn: "⚠️",
            error: "❌",
            success: "✓"
        }
        const prefix = levels[level] || "•"
        console.log(`${prefix} [${component}] ${message}`)
    }
}
