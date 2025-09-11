import React, { useState, useCallback, use } from "react";
import { VscodeButton, VscodeDivider } from "@vscode-elements/react-elements";
import * as go from "gojs";

import "./App.css";
import "@vscode/codicons/dist/codicon.css";

import Toolbar from "./components/Toolbar";
import TabViews from "./components/TabViews";
import { useAlloyData } from "./hooks/useAlloyData";
import { useToolbarActions } from "./hooks/useToolbarActions";

const App: React.FC = () => {
  const { nodeDataArray, linkDataArray, textData, tableData, alloyCommand } =
    useAlloyData();
  const [selectedKey, setSelectedKey] = useState<number | null>(null);
  const [modelData, setModelData] = useState({ canRelink: true });
  const [skipsDiagramUpdate, setSkipsDiagramUpdate] = useState(false);
  const { handleShowLegacyView, handleNextInstance } =
    useToolbarActions(alloyCommand);

  const handleDiagramEvent = useCallback((e: string, elements: any) => {
    if (e === "ChangedSelection") {
      const sel = elements.nodes?.[0];
      setSelectedKey(sel ? sel.id : null);
    }
  }, []);

  const handleModelChange = useCallback((obj: go.IncrementalData) => {
    // Handle diagram model changes
    console.log("Model changed:", obj);
  }, []);

  return (
    <div>
      <div>
        <div slot="start">
          <h1>Alloy Scenario Explorer</h1>
        </div>
        <Toolbar
          onNextInstance={handleNextInstance}
          onShowLegacyView={handleShowLegacyView}
        />

        <VscodeDivider />
        <div slot="end">
          <div>
            <TabViews
              nodeDataArray={nodeDataArray}
              linkDataArray={linkDataArray}
              modelData={modelData}
              skipsDiagramUpdate={skipsDiagramUpdate}
              textData={textData}
              tableData={tableData}
              onDiagramEvent={handleDiagramEvent}
              onModelChange={handleModelChange}
            />
          </div>
        </div>
      </div>
    </div>
  );
};

export default App;
