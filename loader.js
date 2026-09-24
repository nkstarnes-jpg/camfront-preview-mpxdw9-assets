(async function() {
  const parts = 44;
  const base = 'https://raw.githubusercontent.com/nkstarnes-jpg/camfront-preview-mpxdw9-assets/main/';
  const chunks = [];
  for (let i = 0; i < parts; i++) {
    const res = await fetch(base + 'main.dart.js.part' + i);
    if (!res.ok) throw new Error('part ' + i + ' ' + res.status);
    chunks.push(await res.text());
  }
  (0, eval)(chunks.join(''));
})().catch(function(err) {
  console.error(err);
  document.body.innerHTML = '<pre style="color:#fff;background:#300;padding:12px">Camfront failed to load: '+err+'</pre>';
});
