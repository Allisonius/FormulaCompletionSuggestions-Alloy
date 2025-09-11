// New file: components/TabViews.tsx
import React from 'react';
import {
  VscodeTabHeader,
  VscodeTabPanel,
  VscodeTabs,
} from "@vscode-elements/react-elements";
import ReactFlowDiagramWrapper from "./ReactFlowDiagramWrapper";
import { DiagramWrapper } from './DiagramWrapper';
import * as go from "gojs";

interface TabViewsProps {
  nodeDataArray: Array<go.ObjectData>;
  linkDataArray: Array<go.ObjectData>;
  modelData: go.ObjectData;
  skipsDiagramUpdate: boolean;
  textData: string;
  tableData: string;
  onDiagramEvent: (e: string, elements: any) => void;
  onModelChange: (obj: go.IncrementalData) => void;
}

const TabViews: React.FC<TabViewsProps> = ({
  nodeDataArray,
  linkDataArray,
  modelData,
  skipsDiagramUpdate,
  textData,
  tableData,
  onDiagramEvent,
  onModelChange
}) => {
  return (
    <VscodeTabs selectedIndex={0}>
      <VscodeTabHeader slot="header">Viz View</VscodeTabHeader>
      <VscodeTabPanel>
        <DiagramWrapper
          nodeDataArray={nodeDataArray}
          linkDataArray={linkDataArray}
          modelData={modelData}
          skipsDiagramUpdate={skipsDiagramUpdate}
          onDiagramEvent={onDiagramEvent}
          onModelChange={onModelChange}
        />
      </VscodeTabPanel>
      
      <VscodeTabHeader slot="header">Text View</VscodeTabHeader>
      <VscodeTabPanel>
        <div>
          <h2>Text View</h2>
          <div style={{ whiteSpace: "pre-wrap", fontFamily: "monospace" }}>
            {textData}
          </div>
        </div>
      </VscodeTabPanel>
      
      <VscodeTabHeader slot="header">Table View</VscodeTabHeader>
      <VscodeTabPanel>
        <div>
          <h2>Table View</h2>
          <div style={{ whiteSpace: "pre-wrap", fontFamily: "monospace" }}>
            {tableData}
          </div>
        </div>
      </VscodeTabPanel>
    </VscodeTabs>
  );
};

export default TabViews;