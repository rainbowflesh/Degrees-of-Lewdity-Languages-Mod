(async () => {
  console.log("dol-languages-mod earlyload start");

  window.modSC2DataManager.getSc2EventTracer().addCallback({
    // @ts-ignore
    modName: "dol-languages-mod",
    whenSC2PassageEnd: (passage: any, content: HTMLDivElement) => {
      // console.log('dol-languages-mod earlyload whenSC2PassageEnd', passage, content);
      if (!window.modSC2DataManager.getModLoader().getModZip("dol-languages-mod")?.gcIsReleased()) {
        window.modSC2DataManager.getModLoader().getModZip("dol-languages-mod")?.gcReleaseZip();
      }
    },
  });

  await window.modI18N.readZipStream();
})();
