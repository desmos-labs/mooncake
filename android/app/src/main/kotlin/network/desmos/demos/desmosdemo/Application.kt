package network.desmos.demos.desmosdemo

import be.tramckrijte.workmanager.WorkmanagerPlugin
import io.flutter.app.FlutterApplication
import io.flutter.plugin.common.PluginRegistry

class Application : FlutterApplication(), PluginRegistry.PluginRegistrantCallback {
    override fun onCreate() {
        super.onCreate();
        WorkmanagerPlugin.setPluginRegistrantCallback(this);
    }

    override fun registerWith(registry: PluginRegistry) {

    }
}