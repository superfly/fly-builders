import { serve } from "https://deno.land/std@v0.40.0/http/server.ts";

const { PORT = "8080" } = Deno.env();

console.log("listening on", PORT);

async function helloServer(){
  for await (const req of serve(`:${PORT}`)) {
    const enc = new TextEncoder();
    const body = `Hello from Deno!`;
    req.respond({ body: enc.encode(body+"\n"+JSON.stringify(req.headers)) });
    console.log(`${req.method} ${req.url}`)
  }
};

helloServer();

