import type { SC2DataManager } from "../../lib/sugarcube-2-ModLoader/dist-BeforeSC2/SC2DataManager";
import type { ModUtils } from "../../lib/sugarcube-2-ModLoader/dist-BeforeSC2/Utils";
import type jQuery from "jquery/misc";

declare global {
  interface Window {
    modUtils: ModUtils;
    modSC2DataManager: SC2DataManager;

    jQuery: jQuery;

    modI18N: ModI18N;
  }
}
