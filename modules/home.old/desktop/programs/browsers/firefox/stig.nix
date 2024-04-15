''
  // SV-16925 - DTBF030
  lockPref("security.enable_tls", true);
  // SV-16925 - DTBF030
  lockPref("security.tls.version.min", 2);
  // SV-16925 - DTBF030
  lockPref("security.tls.version.max", 4);

  // SV-111841 - DTBF210
  lockPref("privacy.trackingprotection.fingerprinting.enabled", true);

  // V-252881 - Retaining Data Upon Shutdown
  lockPref("browser.sessionstore.privacy_level", 0);

  // SV-251573 - Customizing the New Tab Page
  lockPref("browser.newtabpage.activity-stream.enabled", false);
  lockPref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
  lockPref("browser.newtabpage.activity-stream.showSponsored", false);
  lockPref("browser.newtabpage.activity-stream.feeds.snippets", false);

  // V-251580 - Disabling Feedback Reporting
  lockPref("browser.chrome.toolbar_tips", false);
  lockPref("browser.selfsupport.url", "");
  lockPref("extensions.abuseReport.enabled", false);
  lockPref("extensions.abuseReport.url", "");

  // V-251558 - Controlling Data Submission
  lockPref("datareporting.policy.dataSubmissionEnabled", false);
  lockPref("datareporting.healthreport.uploadEnabled", false);
  lockPref("datareporting.policy.firstRunURL", "");
  lockPref("datareporting.policy.notifications.firstRunURL", "");
  lockPref("datareporting.policy.requiredURL", "");

  // V-252909 - Disabling Firefox Studies
  lockPref("app.shield.optoutstudies.enabled", false);
  lockPref("app.normandy.enabled", false);
  lockPref("app.normandy.api_url", "");

  // V-252908 - Disabling Pocket
  lockPref("extensions.pocket.enabled", false);

  // V-251555 - Preventing Improper Script Execution
  lockPref("dom.disable_window_flip", true);

  // V-251554 - Restricting Window Movement and Resizing
  lockPref("dom.disable_window_move_resize", true);

  // V-251551 - Disabling Form Fill Assistance
  lockPref("browser.formfill.enable", false);

  // V-251550 - Blocking Unauthorized MIME Types
  lockPref("plugin.disable_full_page_plugin_for_types", "application/pdf,application/fdf,application/xfdf,application/lso,application/lss,application/iqy,application/rqy,application/lsl,application/xlk,application/xls,application/xlt,application/pot,application/pps,application/ppt,application/dos,application/dot,application/wks,application/bat,application/ps,application/eps,application/wch,application/wcm,application/wb1,application/wb3,application/rtf,application/doc,application/mdb,application/mde,application/wbk,application/ad,application/adp");
''
