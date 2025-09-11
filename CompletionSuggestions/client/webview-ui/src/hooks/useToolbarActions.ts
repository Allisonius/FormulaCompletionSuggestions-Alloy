import { useCallback, useEffect } from "react";
import { vscode } from "../utilities/vscode";

export const useToolbarActions = (alloyCommand: string) => {
  useEffect(() => {
    console.log("Current alloyCommand in useToolbarActions:", alloyCommand);
  }, [alloyCommand]);

  const handleShowLegacyView = useCallback(() => {
    console.log("Legacy view requested for command:", alloyCommand);
    vscode.postMessage({
      eventType: "ext:showLegacyView",
      body: { alloyCommand: alloyCommand },
    });
  }, [alloyCommand]);

  const handleNextInstance = useCallback(() => {
    console.log("Next instance requested");
    vscode.postMessage({ eventType: "ext:nextInstance" });
  }, []);

  return {
    handleShowLegacyView,
    handleNextInstance,
  };
};
