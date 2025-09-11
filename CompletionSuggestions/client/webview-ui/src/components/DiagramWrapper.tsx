import * as go from "gojs";
import { ReactDiagram } from "gojs-react";
import React, { useRef, useEffect } from "react";

interface DiagramWrapperProps {
  nodeDataArray: Array<go.ObjectData>;
  linkDataArray: Array<go.ObjectData>;
  modelData: go.ObjectData;
  skipsDiagramUpdate: boolean;
  onDiagramEvent:(e: string, elements: any) => void;
  onModelChange: (e: go.IncrementalData) => void;
}

// Define diagram initialization outside component to avoid recreation on renders
const initDiagram = (): go.Diagram => {
  const diagram = new go.Diagram({
    "undoManager.isEnabled": false,
    "clickCreatingTool.archetypeNodeData": {
      text: "new node",
      color: "lightblue",
    },
    model: new go.GraphLinksModel({
      linkKeyProperty: "key",
      // positive keys for nodes
      makeUniqueKeyFunction: (m: go.Model, data: any) => {
        let k = data.key || 1;
        while (m.findNodeDataForKey(k)) k++;
        data.key = k;
        return k;
      },
      // negative keys for links
      makeUniqueLinkKeyFunction: (m: go.GraphLinksModel, data: any) => {
        let k = data.key || -1;
        while (m.findLinkDataForKey(k)) k--;
        data.key = k;
        return k;
      },
    }),
  });

  // define a simple Node template
  diagram.nodeTemplate = new go.Node("Auto")
    .bindTwoWay("location", "loc", go.Point.parse, go.Point.stringify)
    .add(
      new go.Shape("RoundedRectangle", {
        name: "SHAPE",
        fill: "white",
        strokeWidth: 0,
        portId: "",
        fromLinkable: true,
        toLinkable: true,
        cursor: "pointer",
      }).bind("fill", "color"),
      new go.TextBlock({
        margin: 8,
        editable: true,
        font: "400 .875rem Roboto, sans-serif",
      }).bindTwoWay("text")
    );

  return diagram;
};

export const DiagramWrapper: React.FC<DiagramWrapperProps> = ({
  nodeDataArray,
  linkDataArray,
  modelData,
  skipsDiagramUpdate,
  onDiagramEvent,
  onModelChange,
}) => {
  const diagramRef = useRef<ReactDiagram>(null);

  // Handle component update - equivalent to componentDidUpdate
  useEffect(() => {
    const diagram = diagramRef.current?.getDiagram();
    if (diagram instanceof go.Diagram) {
      console.log("Updating node/link data");
      diagram.startTransaction("updateData");
      const model = diagram.model;
      if (model instanceof go.GraphLinksModel) {
        model.mergeNodeDataArray(nodeDataArray);
        model.mergeLinkDataArray(linkDataArray);
      }
      diagram.commitTransaction("updateData");
    }
  }, [nodeDataArray, linkDataArray]);

  // Add diagram event listeners - equivalent to componentDidMount
  // useEffect(() => {
  //   const diagram = diagramRef.current?.getDiagram();
  //   if (diagram instanceof go.Diagram) {
  //     diagram.addDiagramListener("ChangedSelection", onDiagramEvent);
      
  //     // Cleanup event listeners on unmount - equivalent to componentWillUnmount
  //     return () => {
  //       diagram.removeDiagramListener("ChangedSelection", onDiagramEvent);
  //     };
  //   }
  // }, [onDiagramEvent]);

  return (
    <ReactDiagram
      ref={diagramRef}
      divClassName="diagram-component"
      initDiagram={initDiagram}
      nodeDataArray={nodeDataArray}
      linkDataArray={linkDataArray}
      modelData={modelData}
      onModelChange={onModelChange}
      skipsDiagramUpdate={skipsDiagramUpdate}
    />
  );
};