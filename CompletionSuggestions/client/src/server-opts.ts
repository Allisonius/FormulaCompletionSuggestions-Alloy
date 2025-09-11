import { exec } from "child_process";
import {
  Executable,
  ServerOptions,
  StreamInfo,
  TransportKind,
} from "vscode-languageclient/node";
import * as net from "net";
import * as vscode from "vscode";
import * as fs from "fs";
import { spawn } from "child_process";

export default class ServerRunner {
  private readonly _context: vscode.ExtensionContext;

  constructor(context: vscode.ExtensionContext) {
    this._context = context;
  }
  // had to make public for extensions.ts to use on line 24
  // const isPortInUse = await serverRunner._checkPortInUse();
  public _checkPortInUse(): Promise<boolean> {
    return new Promise((resolve, reject) => {
      const client = new net.Socket();

      client.once("error", (err: any) => {
        if (err.code === "ECONNREFUSED") {
          resolve(false); // Port is not in use
        } else {
          resolve(true); // Port is in use or some other error occurred
        }
      });

      client.once("connect", () => {
        client.end();
        resolve(true); // Port is in use
      });

      client.connect(5007, "127.0.0.1");
    });
  }

  // Had to make public for line 28 in extensions.ts
  // await serverRunner._runServer();
  public _runServer(): Promise<string> {
    return new Promise((resolve, reject) => {
      const jarPath = this._context.asAbsolutePath(
        "server/build/libs/alloy-language-server.jar"
      );

      if (!fs.existsSync(jarPath)) {
        console.error("JAR file not found at:", jarPath);
        reject("JAR file not found");
        return;
      }

  console.log("JarPath: ", jarPath);
  const child = spawn("java", ["-jar", jarPath], { env: process.env });

      let serverReady = false;
      const maxRetries = 10;
      const delay = 500;
      let retries = 0;

      // MOST IMPORTANT
      // this function will ONLY resolve IF the server outputs data that contains a string that includes the exact substring "starting socket server"
      // if the output of the server upon start is changed, this will break.
      // the result will be that the client will hang forever waiting for the server to respond.
      const checkServerOutput = async (data: Buffer) => {
        const message = data.toString();
        console.log(`server::info: ${message}`);
        // TODO: Rather than checking the log output, we should check if the server has started listenning on the port
        if (message.includes("Starting socket server")) {
          console.log("Server is ready");
          serverReady = true;
          // Wait 100ms after server is ready
          await new Promise((resolveWait) => setTimeout(resolveWait, 100));
          resolve("Server started");
          clearInterval(interval); // Stop the loop
        }
      };

      // what is this doing?
      // this is listening to the data from the server process
      // and calling the checkServerOutput function upon new data to check if the server is ready
      // this is perpetual until this promise is resolved
      child.stdout.on("data", checkServerOutput);

      child.stderr.on("data", (data) => {
        console.error(`server::err: ${data}`);
      });

      child.on("error", (error) => {
        console.error(`exec error: ${error}`);
        reject("Error starting language server");
      });

      child.on("close", (code) => {
        if (!serverReady && code !== 0) {
          console.log(`process exited with code ${code}`);
          reject("Error starting language server");
        }
      });

      // this is hanging the promise for a certain amount of time so that "data" can update over time and trigger the checkServerOutput until the server is ready
      // at which point the promise resolves and this handles what happens when the server never becomes ready
      const interval = setInterval(() => {
        if (serverReady) {
          clearInterval(interval);
        } else if (retries >= maxRetries) {
          console.error("Server did not start within the expected time.");
          child.kill(); // Kill the child process if it’s still running
          clearInterval(interval);
          reject("Server startup timed out");
        } else {
          retries++;
          console.log(
            `Waiting for server to be ready... (${retries}/${maxRetries})`
          );
        }
      }, delay);
    });
  }

  public async getNoSpawnSocketServerOptions(): Promise<ServerOptions> {
    let serverOptions = async () => {
      // const isPortInUse = await this._checkPortInUse();
      // if (!isPortInUse) {
      //   throw new Error(
      //     "Port 5007 is not in use. Please start the server manually."
      //   );
      // } else {
      //   console.log("Port 5007 is already in use. Server is running.");
      // }

      let connectionInfo = {
        port: 5007,
      };
      let socket = net.connect(connectionInfo);
      let result: StreamInfo = {
        writer: socket,
        reader: socket,
      };
      return Promise.resolve(result);
    };
    return serverOptions;
  }

  public async getSocketServerOptions(): Promise<ServerOptions> {
    let serverOptions = async () => {
      const isPortInUse = await this._checkPortInUse();
      if (!isPortInUse) {
        console.log("Port 5007 is not in use. Starting the server...");
        await this._runServer();
      } else {
        console.log("Port 5007 is already in use. Assuming server is running.");
        throw new Error(
          "Port 5007 is already in use. Assuming server is running."
        );
      }

      let connectionInfo = {
        port: 5007,
      };
      let socket = net.connect(connectionInfo);
      let result: StreamInfo = {
        writer: socket,
        reader: socket,
      };
      return Promise.resolve(result);
    };
    return serverOptions;
  }

  public async getStdioServerOptions(): Promise<ServerOptions> {
    const jarPath = this._context.asAbsolutePath(
      "server/build/libs/alloy-language-server.jar"
    );

    console.log("JarPath: ", jarPath);

    if (!fs.existsSync(jarPath)) {
      throw new Error("JAR file not found at: " + jarPath);
    }

    // log java home path and java version
    exec("java -version", (error, stdout, stderr) => {
      if (error) {
        console.error(`Error executing java -version: ${error.message}`);
        return;
      }
      console.log(`Java Version Output: ${stdout}`);
      console.error(`Java Version Error: ${stderr}`);
    });

    const serverArgs = ["-jar", jarPath, "-s", "-v"];
    if (process.env["GENERATOR_COMPLETION"] === "true") {
      serverArgs.push("-g");
      console.log("Generator completion mode enabled");
    }

    const options: Executable = {
      command: "java",
      args: serverArgs,
      transport: TransportKind.stdio,
      options: {
        env: {
          JAVA_HOME: process.env.JAVA_HOME,
          DEBUG: true,
          shell: false,
        },
      },
    };

    // Define server options for stdio connection
    const serverOptions: ServerOptions = {
      run: options,
      debug: options,
    };

    return serverOptions;
  }
}
