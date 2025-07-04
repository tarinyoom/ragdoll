import type { Request } from '@cloudflare/workers-types';

export interface RequestContext {
  request: Request;
  functionPath: string;
  waitUntil: (promise: Promise<any>) => void;
  env: Record<string, unknown>;
  next: () => Promise<Response>;
}

export async function onRequest(context: RequestContext): Promise<Response> {
  return new Response("Hello from Pages Function!", {
    headers: { "Content-Type": "text/plain" },
  });
}
