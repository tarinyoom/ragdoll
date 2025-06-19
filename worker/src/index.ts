export default {
  async fetch(request: Request): Promise<Response> {
    const data = { message: "Hello world!" };
    return new Response(JSON.stringify(data), {
      headers: {
        "Content-Type": "application/json",
      },
    });
  }
}
