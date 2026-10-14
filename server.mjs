import { readFileSync, existsSync, statSync } from 'node:fs';
import { resolve, join, extname } from 'node:path';
import { createServer } from 'node:http';
const root = process.argv[2] || resolve(process.cwd(), 'dist');
const port = Number(process.env.PORT || 3000);
const mime = { '.html':'text/html', '.js':'application/javascript', '.css':'text/css', '.json':'application/json', '.png':'image/png', '.jpg':'image/jpeg', '.svg':'image/svg+xml', '.wasm':'application/wasm' };
const server = createServer((req, res) => {
  try {
    const url = new URL(req.url, 'http://localhost');
    let path = resolve(root, '.' + decodeURIComponent(url.pathname));
    if (path !== resolve(root) && !path.startsWith(resolve(root) + '/')) { res.writeHead(404); res.end(); return; }
    try { if (statSync(path).isDirectory()) path = join(path, 'index.html'); } catch { path = join(root, 'index.html'); }
    const content = readFileSync(path);
    res.setHeader('Content-Type', mime[extname(path)] || 'application/octet-stream');
    res.setHeader('Cache-Control', 'no-cache');
    res.end(content);
  } catch { res.writeHead(404); res.end('Not found'); }
});
server.listen(port, '0.0.0.0', () => console.log(`serving ${root} on :${port}`));
