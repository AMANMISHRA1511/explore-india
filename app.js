const $=s=>document.querySelector(s);
const esc=(v='')=>String(v).replace(/[&<>'"]/g,c=>({'&':'&amp;','<':'&lt;','>':'&gt;',"'":'&#39;','"':'&quot;'}[c]));
let allPlaces=[], visiblePlaces=[], selected=null;

async function loadBundled(){
  const r=await fetch('data/india-destinations.json');
  if(!r.ok) throw new Error('Bundled data could not load');
  return await r.json();
}
async function loadSupabase(){
  const c=window.EXPLORE_CONFIG||{};
  if(!c.supabaseUrl||!c.supabaseAnonKey||c.supabaseAnonKey.includes('PASTE_')) throw new Error('Supabase key not configured');
  const db=supabase.createClient(c.supabaseUrl,c.supabaseAnonKey);
  const r=await db.from('explore_places').select('*,explore_categories(name),explore_states(name),explore_districts(name),explore_place_images(image_url,is_primary)').eq('status','published').limit(1000);
  if(r.error) throw r.error;
  return (r.data||[]).map((p,i)=>({
    ...p,id:p.id||i+1,category:p.explore_categories?.name||p.category||'Destination',
    state:p.explore_states?.name||p.state||'',district:p.explore_districts?.name||p.district||'',
    description:p.short_description||p.description||'',full_description:p.full_description||p.short_description||'',
    rating:p.average_rating||p.rating||4.5,best_season:p.best_season||'All year',
    image:(p.explore_place_images||[]).find(x=>x.is_primary)?.image_url||(p.explore_place_images||[])[0]?.image_url||p.image||'',
    highlights:p.highlights||['Local culture','Photography','Nearby stays'],
    tips:p.tips||['Confirm local timings before visiting','Respect local rules and customs']
  }));
}
function fillFilters(regions){
  const states=[...new Set([...regions,...allPlaces.map(p=>p.state).filter(Boolean)])].sort();
  $('#stateFilter').innerHTML='<option value="">All states and UTs</option>'+states.map(x=>`<option>${esc(x)}</option>`).join('');
  const cats=[...new Set(allPlaces.map(p=>p.category).filter(Boolean))].sort();
  $('#categoryFilter').innerHTML='<option value="">All categories</option>'+cats.map(x=>`<option>${esc(x)}</option>`).join('');
  $('#regionGrid').innerHTML=states.map(s=>`<button data-state="${esc(s)}">${esc(s)}</button>`).join('');
  $('#regionGrid').querySelectorAll('button').forEach(b=>b.onclick=()=>{$('#stateFilter').value=b.dataset.state;apply();$('#discover').scrollIntoView({behavior:'smooth'})});
}
function apply(){
  const q=$('#searchInput').value.trim().toLowerCase(), state=$('#stateFilter').value, cat=$('#categoryFilter').value, season=$('#seasonFilter').value;
  visiblePlaces=allPlaces.filter(p=>{
    const text=[p.name,p.category,p.state,p.district,p.description,p.full_description].join(' ').toLowerCase();
    return(!q||text.includes(q))&&(!state||p.state===state)&&(!cat||p.category===cat)&&(!season||String(p.best_season).includes(season));
  });
  const sort=$('#sortFilter').value;
  if(sort==='rating') visiblePlaces.sort((a,b)=>(+b.rating||0)-(+a.rating||0));
  if(sort==='name') visiblePlaces.sort((a,b)=>a.name.localeCompare(b.name));
  render();
}
function render(){
  $('#resultCount').textContent=`${visiblePlaces.length} destination${visiblePlaces.length===1?'':'s'} found`;
  $('#cards').innerHTML=visiblePlaces.length?visiblePlaces.map((p,i)=>`<article class="place-card" tabindex="0" data-index="${i}">
    <div class="place-image" style="background-image:linear-gradient(180deg,transparent 50%,rgba(0,0,0,.72)),url('${esc(p.image)}')">
      <span>${esc(p.category)}</span><b>★ ${esc(p.rating||'New')}</b><div><h3>${esc(p.name)}</h3><p>${esc([p.district,p.state].filter(Boolean).join(', '))}</p></div>
    </div>
    <div class="place-content"><p>${esc(p.description||'Explore this destination across India.')}</p>
    <div class="meta"><span>Best: ${esc(p.best_season||'All year')}</span><span>${esc(p.visit_hours||4)} hrs</span></div>
    <button>View complete guide</button></div></article>`).join(''):'<div class="empty">No destinations match your search. Try another state, category or keyword.</div>';
  $('#cards').querySelectorAll('.place-card').forEach(card=>{
    card.onclick=()=>openDetails(visiblePlaces[+card.dataset.index]);
    card.onkeydown=e=>{if(e.key==='Enter')openDetails(visiblePlaces[+card.dataset.index])};
  });
}
function openDetails(p){
  selected=p; $('#modalName').textContent=p.name; $('#modalCategory').textContent=p.category; $('#modalLocation').textContent=[p.district,p.state].filter(Boolean).join(', ');
  $('#modalDescription').textContent=p.full_description||p.description;
  $('#modalCover').style.backgroundImage=`linear-gradient(180deg,transparent 35%,rgba(0,0,0,.88)),url("${p.image}")`;
  $('#modalHighlights').innerHTML=(p.highlights||[]).map(x=>`<span>${esc(x)}</span>`).join('');
  $('#modalTips').innerHTML=(p.tips||[]).map(x=>`<li>${esc(x)}</li>`).join('');
  $('#modalFacts').innerHTML=`<div><small>Rating</small><b>★ ${esc(p.rating||'New')}</b></div><div><small>Best season</small><b>${esc(p.best_season||'All year')}</b></div><div><small>Suggested time</small><b>${esc(p.visit_hours||4)} hours</b></div><div><small>Entry fee</small><b>${+p.entry_fee?'₹'+p.entry_fee:'Check locally'}</b></div>`;
  const query=p.latitude&&p.longitude?`${p.latitude},${p.longitude}`:`${p.name}, ${p.state}`;
  $('#mapButton').href=`https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(query)}`;
  $('#nearbyButton').href=`https://www.google.com/maps/search/?api=1&query=${encodeURIComponent('hotels resorts restaurants near '+p.name)}`;
  $('#detailsModal').classList.add('show'); $('#detailsModal').setAttribute('aria-hidden','false'); document.body.style.overflow='hidden';
}
function closeDetails(){ $('#detailsModal').classList.remove('show'); $('#detailsModal').setAttribute('aria-hidden','true'); document.body.style.overflow='';}
function downloadGuide(){
  if(!selected)return;
  const text=`EXPLORE INDIA DESTINATION GUIDE\n\n${selected.name}\n${selected.district}, ${selected.state}\nCategory: ${selected.category}\nRating: ${selected.rating}\nBest season: ${selected.best_season}\nSuggested visit: ${selected.visit_hours||4} hours\n\nABOUT\n${selected.full_description||selected.description}\n\nHIGHLIGHTS\n${(selected.highlights||[]).map(x=>'• '+x).join('\n')}\n\nTRAVEL TIPS\n${(selected.tips||[]).map(x=>'• '+x).join('\n')}\n\nMAP\nhttps://www.google.com/maps/search/?api=1&query=${encodeURIComponent(selected.latitude+','+selected.longitude)}\n\nGenerated by Explore India`;
  const blob=new Blob([text],{type:'text/plain;charset=utf-8'}),a=document.createElement('a');
  a.href=URL.createObjectURL(blob);a.download=selected.slug+'-travel-guide.txt';a.click();URL.revokeObjectURL(a.href);
}
async function init(){
  let bundled=await loadBundled(); let regions=bundled.regions||[];
  try{const remote=await loadSupabase(); allPlaces=remote.length?remote:bundled.places}catch(e){console.info('Using bundled national dataset:',e.message);allPlaces=bundled.places}
  $('#heroCount').textContent=allPlaces.length+'+'; fillFilters(regions); visiblePlaces=[...allPlaces]; render();
}
$('#searchForm').onsubmit=e=>{e.preventDefault();apply();$('#discover').scrollIntoView({behavior:'smooth'})};
['stateFilter','categoryFilter','seasonFilter','sortFilter'].forEach(id=>$('#'+id).onchange=apply);
$('#resetFilters').onclick=()=>{$('#searchInput').value='';['stateFilter','categoryFilter','seasonFilter','sortFilter'].forEach(id=>$('#'+id).selectedIndex=0);apply()};
$('#quickFilters').querySelectorAll('button').forEach(b=>b.onclick=()=>{$('#categoryFilter').value=b.dataset.category;apply();$('#discover').scrollIntoView({behavior:'smooth'})});
$('#closeModal').onclick=closeDetails; $('#detailsModal').onclick=e=>{if(e.target.id==='detailsModal')closeDetails()}; document.addEventListener('keydown',e=>{if(e.key==='Escape')closeDetails()});
$('#downloadButton').onclick=downloadGuide;
init().catch(e=>{$('#cards').innerHTML=`<div class="empty">Data loading failed: ${esc(e.message)}</div>`});
