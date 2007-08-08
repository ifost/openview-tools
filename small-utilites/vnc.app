Application "VNC" {
 Description {
  "VNCViewer",
  "Allows for PC remote control",
  "installed.",
""
}
Version "Version 1.1";
Copyright {
  "Copyright (c) 1999-2001 Alex Dune,Greg Baker",
  "All rights reserved",
}

PopupItem <10> "Take control of..."
 CONTEXT "AllContexts" TargetSymbolType
 Computer:ANY f.action "RemoteControl";

Action "RemoteControl" {
 SelectionRule (isNode);
 MinSelected 1;
 MaxSelected 1;
 Command "hpterm -e 
           vncviewer ${OVwSelection1}:0";
 }
}
