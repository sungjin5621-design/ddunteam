/* Shared backend adapter for the existing single-file UI. */
const CLOUD_CLAN_ID='ddunteam';
const CLOUD_URL=window.DDUNTEAM_CONFIG?.supabaseUrl||'';
const CLOUD_KEY=window.DDUNTEAM_CONFIG?.supabasePublishableKey||'';
const cloudClient = window.supabase.createClient(CLOUD_URL,CLOUD_KEY);
let cloudUser=null, cloudOwnerId=null, cloudReady=false;

function cloudConfigured(){return !!CLOUD_URL && !!CLOUD_KEY && !CLOUD_URL.includes('YOUR_PROJECT') && !CLOUD_KEY.includes('YOUR_')}
function cloudErr(e){console.error(e);toast(e?.message||'서버와 통신하지 못했습니다.');}
async function cloudInit(){
  if(!cloudConfigured()){toast('Supabase 설정이 필요합니다. 배포 파일의 환경 설정을 먼저 입력해주세요.');return;}
  let {data:{session}}=await cloudClient.auth.getSession();
  if(!session){const r=await cloudClient.auth.signInAnonymously();if(r.error)return cloudErr(r.error);session=r.data.session;}
  cloudUser=session.user;
  await cloudLoad();
  cloudReady=true;
  const ownerBtn=document.getElementById('ownerClaimBtn'); if(ownerBtn) ownerBtn.style.display=cloudOwnerId?'none':'inline-grid';
  cloudSubscribe();
  renderAll();
}
async function cloudLoad(){
  const [c,m,n,s,k]=await Promise.all([
    cloudClient.from('clans').select('*').eq('id',CLOUD_CLAN_ID).single(),
    cloudClient.from('clan_members').select('*').eq('clan_id',CLOUD_CLAN_ID),
    cloudClient.from('clan_notices').select('*').eq('clan_id',CLOUD_CLAN_ID).order('created_at',{ascending:false}),
    cloudClient.from('clan_schedules').select('*').eq('clan_id',CLOUD_CLAN_ID).order('event_date',{ascending:true}).order('start_hour',{ascending:true}),
    cloudClient.from('clan_categories').select('*').eq('clan_id',CLOUD_CLAN_ID).order('order_value',{ascending:true})
  ]);
  for(const r of [c,m,n,s,k])if(r.error)return cloudErr(r.error);
  cloudOwnerId=c.data.owner_user_id;
  clanMessage=c.data.message||'뚠뚠팀 혈맹 운영 페이지';
  currentServer=c.data.current_server||'바츠 03';
  members=m.data.map(x=>[x.nickname,x.level,x.weapon,x.role,x.id,x.notes,x.user_id]);
  notices=n.data.map(x=>({id:x.id,title:x.title,date:new Date(x.created_at).toISOString().slice(0,10).replaceAll('-','.'),body:x.body,image:x.image_url,tag:x.tag,author:x.author_nickname,created_at:x.created_at,updated_at:x.updated_at}));
  schedules=s.data.map(x=>({id:x.id,date:x.event_date,start:x.start_hour,end:x.end_hour,title:x.title,count:x.count_text}));
  categories=k.data.map(x=>({id:x.category_key,label:x.label,order:x.order_value,fixed:x.fixed}));
  const mine=members.find(x=>x[6]===cloudUser.id);
  currentNick=mine?mine[0]:'설정 필요';
}
function cloudSubscribe(){
  cloudClient.channel('ddunteam-live').on('postgres_changes',{event:'*',schema:'public',table:'clans',filter:'id=eq.ddunteam'},()=>cloudRefresh()).on('postgres_changes',{event:'*',schema:'public',table:'clan_members',filter:'clan_id=eq.ddunteam'},()=>cloudRefresh()).on('postgres_changes',{event:'*',schema:'public',table:'clan_notices',filter:'clan_id=eq.ddunteam'},()=>cloudRefresh()).on('postgres_changes',{event:'*',schema:'public',table:'clan_schedules',filter:'clan_id=eq.ddunteam'},()=>cloudRefresh()).on('postgres_changes',{event:'*',schema:'public',table:'clan_categories',filter:'clan_id=eq.ddunteam'},()=>cloudRefresh()).subscribe();
}
let refreshTimer=null;
async function cloudRefresh(){clearTimeout(refreshTimer);refreshTimer=setTimeout(async()=>{try{await cloudLoad();renderAll();}catch(e){cloudErr(e)}},120);}

function rankOf(n){if(!n)return '';const m=members.find(x=>x[0]===n);return m?m[3]:''}
function canManage(){return !!cloudUser && (cloudUser.id===cloudOwnerId || ['군주','수호'].includes(rankOf(currentNick)))}

async function setCurrentNick(){
  const n=document.getElementById('nickInput').value.trim();
  if(!n)return toast('닉네임을 입력해주세요.');
  if(!cloudReady)return toast('서버 연결 중입니다.');
  const {data,error}=await cloudClient.rpc('claim_nickname',{p_clan_id:CLOUD_CLAN_ID,p_nickname:n});
  if(error)return cloudErr(error);
  currentNick=n;renderCurrent();renderMembers();toast(n+'님으로 설정했습니다.');
}
async function saveMember(i){
  if(!canManage())return toast('혈맹원 관리는 페이지 소유자/군주/수호만 가능합니다.');
  const n=document.getElementById('f0').value.trim(),lvl=+document.getElementById('f1').value,w=document.getElementById('f2').value,r=document.getElementById('f3').value;
  if(!n)return toast('닉네임을 입력해주세요.');
  if(i!==null && members[i][0]==='베키' && n!=='베키')return toast('페이지 소유자 닉네임은 변경할 수 없습니다.');
  const payload={clan_id:CLOUD_CLAN_ID,nickname:n,level:lvl,weapon:w,role:r};
  const q=i===null?cloudClient.from('clan_members').insert(payload):cloudClient.from('clan_members').update(payload).eq('id',members[i][4]);
  const {error}=await q;if(error)return cloudErr(error);
  await cloudRefresh();closeModal();toast('혈맹원 정보가 저장되었습니다.');
}
async function removeSelected(){
  if(!canManage())return toast('혈맹원 관리는 페이지 소유자/군주/수호만 가능합니다.');
  if(selectedMember===null)return toast('삭제할 혈맹원을 선택해주세요.');
  if(members[selectedMember][0]==='베키')return toast('페이지 소유자는 제거할 수 없습니다.');
  if(!confirm(members[selectedMember][0]+'님을 제거할까요?'))return;
  const {error}=await cloudClient.from('clan_members').delete().eq('id',members[selectedMember][4]);if(error)return cloudErr(error);
  selectedMember=null;await cloudRefresh();toast('혈맹원을 제거했습니다.');
}
async function saveMemberNote(i){
  if(!canManage())return toast('특이사항은 페이지 소유자/군주/수호만 관리할 수 있습니다.');
  const note=document.getElementById('memberNote').value.trim();
  const {error}=await cloudClient.from('clan_members').update({notes:note}).eq('id',members[i][4]);if(error)return cloudErr(error);
  members[i][5]=note;closeModal();toast('특이사항을 저장했습니다.');
}
function openMemberProfile(i){
  const m=members[i],privileged=canManage(),note=m[5]||'';
  openModal('<div class="modal-head"><div><h3>'+escapeHtml(m[0])+' 프로필</h3><div class="banner-sub">Lv.'+m[1]+' · '+escapeHtml(m[2])+' · '+escapeHtml(m[3])+'</div></div><button class="close" onclick="closeModal()">×</button></div><div class="member-profile"><div class="profile-avatar">'+escapeHtml(m[0][0])+'</div><div><div class="title">'+escapeHtml(m[0])+'</div><div class="sub">레벨 '+m[1]+' · 웨폰 '+escapeHtml(m[2])+'</div><div class="sub">등급 '+escapeHtml(m[3])+'</div></div></div>'+(privileged?'<div class="memo-box"><div class="memo-label">운영진 특이사항</div><textarea id="memberNote" class="nick" style="min-height:130px">'+escapeHtml(note)+'</textarea><div class="modal-actions"><button class="primary" onclick="saveMemberNote('+i+')">메모 저장</button></div></div>':'')+'<div class="modal-actions"><button onclick="closeModal()">닫기</button></div>');
}

async function saveNotice(i){
  if(!canManage())return toast('공지 작성/수정/삭제는 페이지 소유자/군주/수호만 가능합니다.');
  const t=document.getElementById('ntitle').value.trim(),b=document.getElementById('nbody').value.trim(),tag=document.getElementById('ntag').value;
  if(!t||!b)return toast('제목과 내용을 입력해주세요.');
  let imageUrl=pendingImage||'';
  if(imageUrl.startsWith('data:')){
    const f=await fetch(imageUrl).then(r=>r.blob());
    const ext=(f.type.split('/')[1]||'png').replace('jpeg','jpg');
    const path=CLOUD_CLAN_ID+'/'+crypto.randomUUID()+'.'+ext;
    const up=await cloudClient.storage.from('notice-images').upload(path,f,{contentType:f.type,upsert:false});
    if(up.error)return cloudErr(up.error);
    imageUrl=cloudClient.storage.from('notice-images').getPublicUrl(path).data.publicUrl;
  }
  const payload={clan_id:CLOUD_CLAN_ID,title:t,body:b,image_url:imageUrl,tag,author_nickname:currentNick};
  const q=i===null?cloudClient.from('clan_notices').insert(payload):cloudClient.from('clan_notices').update(payload).eq('id',notices[i].id);
  const {error}=await q;if(error)return cloudErr(error);
  pendingImage='';await cloudRefresh();closeModal();toast(i===null?'공지사항을 등록했습니다.':'공지사항을 수정했습니다.');
}
async function deleteNotice(i){
  if(!canManage())return toast('공지 삭제는 페이지 소유자/군주/수호만 가능합니다.');
  if(!confirm('이 공지사항을 삭제할까요?'))return;
  const {error}=await cloudClient.from('clan_notices').delete().eq('id',notices[i].id);if(error)return cloudErr(error);await cloudRefresh();toast('공지사항을 삭제했습니다.');
}

async function saveSchedule(id){
  if(!canManage())return toast('일정 관리는 페이지 소유자/군주/수호만 가능합니다.');
  const date=document.getElementById('sd').value,start=+document.getElementById('ss').value,end=+document.getElementById('se').value,title=document.getElementById('st').value.trim(),count=document.getElementById('sc').value.trim();
  if(!date||!title||end<=start||start<0||end>24)return toast('날짜/시간/내용을 확인해주세요.');
  const payload={clan_id:CLOUD_CLAN_ID,event_date:date,start_hour:start,end_hour:end,title,count_text:count,created_by_nickname:currentNick};
  const q=id===null?cloudClient.from('clan_schedules').insert(payload):cloudClient.from('clan_schedules').update(payload).eq('id',id);const {error}=await q;if(error)return cloudErr(error);await cloudRefresh();openSchedule();toast('일정을 저장했습니다.');
}
async function deleteSchedule(id){if(!canManage())return toast('일정 관리는 페이지 소유자/군주/수호만 가능합니다.');const {error}=await cloudClient.from('clan_schedules').delete().eq('id',id);if(error)return cloudErr(error);await cloudRefresh();openSchedule();toast('일정을 삭제했습니다.');}

async function saveServer(){if(!canManage())return toast('서버 변경은 페이지 소유자/군주/수호만 가능합니다.');const v=document.getElementById('serverSelect').value;const {error}=await cloudClient.from('clans').update({current_server:v,updated_at:new Date().toISOString()}).eq('id',CLOUD_CLAN_ID);if(error)return cloudErr(error);currentServer=v;await cloudRefresh();closeModal();toast('현재 서버를 '+v+'로 변경했습니다.');}
async function saveClanMessage(){if(!canManage())return toast('혈맹 남긴말 수정은 페이지 소유자/군주/수호만 가능합니다.');const v=document.getElementById('clanMessageInput').value.trim();if(!v)return toast('남긴말을 입력해주세요.');const {error}=await cloudClient.from('clans').update({message:v,updated_at:new Date().toISOString()}).eq('id',CLOUD_CLAN_ID);if(error)return cloudErr(error);clanMessage=v;const e=document.getElementById('clanMessage');if(e)e.textContent=v;closeModal();toast('혈맹 남긴말을 저장했습니다.');}

async function saveCategoryOrder(){
  if(!canManage())return toast('권한이 없습니다.');
  const values=categories.filter(c=>!c.fixed).map(c=>({id:c.id,value:+document.getElementById('order-'+c.id).value}));
  if(values.some(x=>!Number.isInteger(x.value)||x.value<1))return toast('order는 1 이상의 정수로 입력해주세요.');
  values.sort((a,b)=>a.value-b.value).forEach((x,i)=>{const c=categories.find(c=>c.id===x.id);c.order=i+1;});
  for(const c of categories.filter(x=>!x.fixed)){const {error}=await cloudClient.from('clan_categories').update({order_value:c.order}).eq('clan_id',CLOUD_CLAN_ID).eq('category_key',c.id);if(error)return cloudErr(error)}
  await cloudRefresh();closeModal();showPage('main',document.querySelector('#tabs button'));toast('카테고리 순서를 저장했습니다.');
}

async function claimOwner(){
  const code=prompt('페이지 소유자 등록 코드를 입력하세요.');if(!code)return;
  const {error}=await cloudClient.rpc('claim_owner',{p_clan_id:CLOUD_CLAN_ID,p_owner_code:code});if(error)return cloudErr(error);
  await cloudRefresh();toast('페이지 소유자로 등록했습니다.');
}

// Keep the current UI's initial render, but load the shared backend first.
document.addEventListener('DOMContentLoaded',()=>{const b=document.createElement('button');b.id='ownerClaimBtn';b.className='pencil';b.textContent='소유자 등록';b.style.display='none';b.onclick=claimOwner;const c=document.querySelector('.current-row');if(c)c.appendChild(b);cloudInit();});
