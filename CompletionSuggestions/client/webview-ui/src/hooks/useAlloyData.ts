// New file: hooks/useAlloyData.ts
import { useState, useEffect, useCallback } from "react";
import * as go from "gojs";
import { ReactEventMessage } from "../../../src/interfaces/common";

interface Node {
  key: string;
  text: string;
  [key: string]: any;
}

export const useAlloyData = () => {
  const [nodeDataArray, setNodeDataArray] = useState<Array<go.ObjectData>>([]);
  const [linkDataArray, setLinkDataArray] = useState<Array<go.ObjectData>>([]);
  const [textData, setTextData] = useState("");
  const [tableData, setTableData] = useState("");
  const [alloyCommand, setAlloyCommand] = useState("");

  const updateDiagram = useCallback((data: any) => {
    console.log("REACT :: Updating diagram with data: ", data);
    const sigs: Array<any> = data.sigs;
    const atoms: Array<any> = data.atoms;
    const relations: Array<any> = data.relations;

    const groupDataArray: Array<Node> = sigs.map((sig: any) => ({
      key: sig,
      text: sig,
      isGroup: true,
    }));

    const nodes: Array<Node> = atoms.map((atom: any) => ({
      key: atom.id,
      text: atom.name,
      color: "lightblue",
      group: atom.sig,
    }));

    const links = relations.map((relation: any) => ({
      key: relation.id,
      label: relation.label,
      from: relation.source,
      to: relation.target,
    }));

    setNodeDataArray([...nodes]);
    setLinkDataArray(links);
    setTextData(data.textContent);
    setTableData(data.tableContent);
  }, []);

  const handleMessage = useCallback(
    (event: any) => {
      console.log("REACT :: Received message: ", event);
      const eventMessage = event.data as ReactEventMessage;
      switch (eventMessage.eventType) {
        // case "hello":
        //   console.log("Hello from the webview!");
        //   break;
        case "react:showInstance":
          const messageBody = eventMessage.body;
          const { alloyCommand, instanceData } = messageBody;
          console.log("REACT :: Received command: ", alloyCommand);
          setAlloyCommand(alloyCommand);
          const data = instanceData;
          console.log("REACT :: Received instance: ", data);
          const value = JSON.parse(data);
          updateDiagram(value);
          break;
        case "react:nextInstance":
          const nextInstanceBody = eventMessage.body;
          const { instanceData: nextInstanceData } = nextInstanceBody;
          const nextData = nextInstanceData;
          console.log("REACT :: Received next instance: ", nextData);
          const nextValue = JSON.parse(nextData);
          updateDiagram(nextValue);
          break;
      }
    },
    [updateDiagram, setAlloyCommand]
  );

  useEffect(() => {
    window.addEventListener("message", handleMessage);
    return () => {
      window.removeEventListener("message", handleMessage);
    };
  }, [handleMessage]);

  return {
    nodeDataArray,
    linkDataArray,
    textData,
    tableData,
    alloyCommand,
  };
};
