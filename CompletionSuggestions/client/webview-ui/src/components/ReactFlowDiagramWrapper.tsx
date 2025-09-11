import React, { useCallback, useRef, useEffect } from 'react';
import {
    ReactFlow,
  ReactFlowProvider,
  useNodesState,
  useEdgesState,
  useReactFlow,
  Node,
  Edge,
  Controls,
  Background,
  MarkerType,
  NodeChange,
  EdgeChange,
  Connection,
  addEdge
} from '@xyflow/react';
import '@xyflow/react/dist/style.css'

// Props similar to WrapperProps from DiagramWrapper
interface ReactFlowDiagramWrapperProps {
  nodeDataArray: Array<any>;
  linkDataArray: Array<any>;
  modelData: any;
  skipsDiagramUpdate: boolean;
  onDiagramEvent: (eventType: string, elements: any) => void;
  onModelChange: (changes: any) => void;
}

// Node type used internally by ReactFlow
const nodeColor = (nodeData: any) => {
  return nodeData.color || '#ffffff';
};

const ReactFlowDiagramWrapper: React.FC<ReactFlowDiagramWrapperProps> = ({
  nodeDataArray,
  linkDataArray,
  modelData,
  skipsDiagramUpdate,
  onDiagramEvent,
  onModelChange
}) => {
  // Convert GoJS node format to ReactFlow node format
  const convertNodesToReactFlow = useCallback((nodeArray: any[]): Node[] => {
    return nodeArray.map(node => ({
      id: node.key.toString(),
      position: node.loc ? { 
        x: parseInt(node.loc.split(' ')[0]), 
        y: parseInt(node.loc.split(' ')[1]) 
      } : { x: 0, y: 0 },
      data: { 
        label: node.text,
        ...node 
      },
      style: { 
        background: node.color || 'white', 
        borderRadius: 5,
        padding: 8,
        fontFamily: "'Roboto', sans-serif",
        fontSize: '0.875rem'
      },
      draggable: true,
    }));
  }, []);

  // Convert GoJS link format to ReactFlow edge format
  const convertLinksToReactFlow = useCallback((linkArray: any[]): Edge[] => {
    return linkArray.map(link => ({
      id: link.key.toString(),
      source: link.from.toString(),
      target: link.to.toString(),
      markerEnd: {
        type: MarkerType.ArrowClosed,
      },
      data: { 
        ...link 
      }
    }));
  }, []);

  const [nodes, setNodes, onNodesChange] = useNodesState(
    convertNodesToReactFlow(nodeDataArray)
  );
  
  const [edges, setEdges, onEdgesChange] = useEdgesState(
    convertLinksToReactFlow(linkDataArray)
  );

  // Update nodes and edges when props change
  useEffect(() => {
    if (!skipsDiagramUpdate) {
      setNodes(convertNodesToReactFlow(nodeDataArray));
      setEdges(convertLinksToReactFlow(linkDataArray));
    }
  }, [nodeDataArray, linkDataArray, skipsDiagramUpdate, setNodes, setEdges, convertNodesToReactFlow, convertLinksToReactFlow]);

  // Handle node selection
  const onSelectionChange = useCallback(
    ({ nodes: selectedNodes, edges: selectedEdges }: { nodes: Node[], edges: Edge[] }) => {
      onDiagramEvent('ChangedSelection', { nodes: selectedNodes, edges: selectedEdges });
    },
    [onDiagramEvent]
  );

  // Handle node position changes
//   const handleNodeChanges = useCallback(
//     (changes: NodeChange[]) => {
//       onNodesChange(changes);
      
//       // Convert changes to format expected by onModelChange
//       const nodesChanges = changes.filter(change => change.type === 'position' && change.position).map(change => ({
//         key: change.id,
//         loc: `${change.position?.x} ${change.position?.y}`
//       }));
      
//       if (nodesChanges.length > 0) {
//         onModelChange({ nodeDataArray: nodesChanges, linkDataArray: [] });
//       }
//     },
//     [onNodesChange, onModelChange]
//   );

  // Handle edge/connection changes
//   const handleEdgeChanges = useCallback(
//     (changes: EdgeChange[]) => {
//       onEdgesChange(changes);
      
//       // Process edge changes to format expected by onModelChange
//       const edgesChanges = changes.map(change => ({
//         key: change.type,
//         // Include other edge properties if needed
//       }));
      
//       if (edgesChanges.length > 0) {
//         onModelChange({ nodeDataArray: [], linkDataArray: edgesChanges });
//       }
//     },
//     [onEdgesChange, onModelChange]
//   );

  // Handle new connections
//   const onConnect = useCallback(
//     (connection: Connection) => {
//       const newEdge = {
//         ...connection,
//         id: `-${Date.now()}`, // Generate negative ID like in GoJS
//         markerEnd: { type: MarkerType.ArrowClosed },
//       };
      
//       setEdges(eds => addEdge(newEdge, eds));
      
//       // Notify parent about the change
//       onModelChange({ 
//         nodeDataArray: [], 
//         linkDataArray: [{ 
//           key: newEdge.id, 
//           from: connection.source, 
//           to: connection.target 
//         }] 
//       });
//     },
//     [setEdges, onModelChange]
//   );

  // Node dragging stopped - handle the final position update
  const onNodeDragStop = useCallback(
    (_: React.MouseEvent, node: Node) => {
      onModelChange({
        nodeDataArray: [{ 
          key: node.id, 
          loc: `${node.position.x} ${node.position.y}` 
        }], 
        linkDataArray: []
      });
    },
    [onModelChange]
  );

  return (
    <div style={{ width: '100%', height: '100%' }}>
    <ReactFlow
        nodes={nodes}
        edges={edges}
    //   onNodesChange={handleNodeChanges}
    //   onEdgesChange={handleEdgeChanges}
    //   onConnect={onConnect}
        onNodeDragStop={onNodeDragStop}
        onSelectionChange={onSelectionChange}
        fitView
        attributionPosition="bottom-right"
        deleteKeyCode="Delete"
        multiSelectionKeyCode="Control"
        selectionKeyCode="Shift"
    >
        <Controls />
        <Background color="#aaa" gap={16} />
    </ReactFlow>
    </div>
  );
};

export default ReactFlowDiagramWrapper;