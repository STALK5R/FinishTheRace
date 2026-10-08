import {readFile,writeFile} from 'node:fs/promises';
const base=new URL('../',import.meta.url);
const [brand,app,client]=await Promise.all(['worker/brand.json','worker/app.js','worker/client.js'].map(p=>readFile(new URL(p,base),'utf8')));
await writeFile(new URL('worker/index.js',base),'const BRAND='+brand+';\n'+app+'\nconst CLIENT='+JSON.stringify(client)+';\n');
console.log('Built self-contained Cloudflare Worker.');
