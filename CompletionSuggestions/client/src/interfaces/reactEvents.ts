import { ReactEventMessage } from "./common";
/*
Declares event messages that are accepted by the webview or react app.
Prefix: "react"
*/

// Alloy instance message from React
export interface ReactAlloyInstanceMessage extends ReactEventMessage {
  eventType: "react:alloyInstance";
  body: {
    alloyCommand: string;
    instanceData: any; // Consider defining a more specific type for instanceData
  };
}

export interface ReactAlloyNextInstanceMEssage extends ReactEventMessage {
  eventType: "react:alloyNextInstance";
  body: {
    alloyCommand: string;
    instanceData: any; // Consider defining a more specific type for instanceData
  };
}
