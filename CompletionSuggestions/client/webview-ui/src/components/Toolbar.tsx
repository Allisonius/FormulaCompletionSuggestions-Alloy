// New file: components/Toolbar.tsx
import React from "react";
import VscodeToolbarButton from "@vscode-elements/react-elements/dist/components/VscodeToolbarButton";
import VscodeToolbarContainer from "@vscode-elements/react-elements/dist/components/VscodeToolbarContainer";
import { get } from "http";

interface ToolbarProps {
  onNextInstance: () => void;
  onShowLegacyView: () => void;
}

const Toolbar: React.FC<ToolbarProps> = ({
  onNextInstance,
  onShowLegacyView,
}) => {
  return (
    <>
      <VscodeToolbarContainer>
        <VscodeToolbarButton
          //   icon="symbol-keyword"
          data-tooltip="Show Next Instance"
          onClick={onNextInstance}
        >
          Next Instance
        </VscodeToolbarButton>
        <VscodeToolbarButton
          //   icon="symbol-keyword"
          data-tooltip="Legacy Scenario Explorer"
          onClick={onShowLegacyView}
        >
          Legacy View
        </VscodeToolbarButton>
      </VscodeToolbarContainer>
    </>
  );
};

export default Toolbar;
