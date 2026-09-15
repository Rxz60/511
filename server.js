const express=require("express");
const crypto=require("crypto");
const path=require("path");

const app=express();
const PORT=process.env.PORT||3000;
const API_KEY=process.env.HENDAR_API_KEY||"YOUR_API_KEY";

app.use(express.json({limit:"5mb"}));
app.use(express.static(path.join(__dirname,"public")));

const scripts=new Map();

app.post("/api/obfuscate",async(req,res)=>{
try{
const {source}=req.body;

if(!source||typeof source!=="string"){
return res.status(400).json({success:false,message:"الكود غير صالح"});
}

const response=await fetch("https://api.hendar.dev/v1/obfuscate",{
method:"POST",
headers:{
"Content-Type":"application/json",
"Authorization":"Bearer "+API_KEY
},
body:JSON.stringify({
source,
preset:"Medium",
luaVersion:"Lua51"
})
});

const data=await response.json();

if(!response.ok){
return res.status(response.status).json(data);
}

const code=data.obfuscated||data.code||data.output||data.result||data.data?.obfuscated||data.data?.code||data.data?.output;

if(!code){
return res.status(500).json({
success:false,
message:"لم يرجع API كوداً مشوشاً"
});
}

const id=crypto.randomBytes(18).toString("hex");
const token=crypto.randomBytes(32).toString("hex");

scripts.set(id,{
code:String(code),
token,
createdAt:Date.now()
});

res.json({
success:true,
raw:"/raw/"+id,
execute:"/execute/"+id+"?token="+token
});

}catch(e){
res.status(500).json({
success:false,
message:"حدث خطأ في الخادم"
});
}
});

app.get("/raw/:id",(req,res)=>{
const item=scripts.get(req.params.id);

res.setHeader("Content-Type","application/json; charset=utf-8");

if(!item){
return res.status(404).send(JSON.stringify({
success:false,
message:"Not Found"
},null,2));
}

res.status(404).send(JSON.stringify({
success:false,
message:"Not Found"
},null,2));
});

app.get("/execute/:id",async(req,res)=>{
const item=scripts.get(req.params.id);

if(!item||req.query.token!==item.token){
return res.status(404).type("application/json").send(JSON.stringify({
success:false,
message:"Not Found"
},null,2));
}

res.setHeader("Content-Type","text/plain; charset=utf-8");
res.send(item.code);
});

app.get("*",(req,res)=>{
res.sendFile(path.join(__dirname,"public","index.html"));
});

app.listen(PORT,()=>{
console.log("SP HUB running on port "+PORT);
});
