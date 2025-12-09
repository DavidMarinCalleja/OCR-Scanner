import { platformIOS } from '@rock-js/platform-ios';
import { platformAndroid } from '@rock-js/platform-android';
import { pluginMetro } from '@rock-js/plugin-metro';
import { pluginBrownfieldIos } from '@rock-js/plugin-brownfield-ios';

export default {
  plugins: [
    pluginBrownfieldIos()
  ],
  bundler: pluginMetro(),
  platforms: {
    ios: platformIOS(),
    android: platformAndroid(),
  },
};
