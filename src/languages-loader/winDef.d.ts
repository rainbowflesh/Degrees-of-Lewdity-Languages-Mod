import type { SC2DataManager } from "../../lib/sugarcube-2-ModLoader/dist-BeforeSC2/SC2DataManager";
import type { ModUtils } from "../../lib/sugarcube-2-ModLoader/dist-BeforeSC2/Utils";

declare global {
  interface Window {
    modUtils: ModUtils;
    modSC2DataManager: SC2DataManager;

    modI18N: ModI18N;
  }

  var StartConfig: any;
}
