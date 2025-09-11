/**
 * Interfaces for messages passed between the extension and webview
 */

export type ExtensionEventType = `${"ext:"}${string}`;
export type ReactEventType = `${"react:"}${string}`;

// Base message interface
export interface EventMessage {
  eventType: string;
  body?: any; // Consider defining a more specific type for body
}

export interface ReactEventMessage extends EventMessage {
  eventType: ReactEventType;
}

export interface ExtensionEventMessage extends EventMessage {
  eventType: ExtensionEventType;
}
