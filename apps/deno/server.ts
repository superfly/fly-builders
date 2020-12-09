import { serve } from "https://deno.land/std/http/server.ts";

const PORT = parseInt(Deno.env.get("PORT") || "8080") || 8080;

console.log("listening on", PORT);

async function helloServer(){
  for await (const req of serve({hostname:"0.0.0.0",port:PORT})) {
    //const enc = new TextEncoder();
    const body = `Hello from Deno!`;
    req.respond({ status:200, body: body });
    console.log(`${req.method} ${req.url}`)
  }
};

helloServer();

