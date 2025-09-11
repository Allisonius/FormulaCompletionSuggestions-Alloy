import { ExtensionEventMessage } from "./common";

// Get instance message
export interface GetInstanceMessage extends ExtensionEventMessage {
  eventType: "ext:getInstance";
  body: {
    alloyCommand: string;
  };
}

// Show legacy view message
export interface ShowLegacyViewMessage extends ExtensionEventMessage {
  eventType: "ext:showLegacyView";
  body: {
    alloyCommand: string;
  };
}
