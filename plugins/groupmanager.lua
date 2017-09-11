
local function modadd(msg)
    -- superuser and admins only (because sudo are always has privilege)
    if not is_sudo(msg) then
return '🌟| _أنـت لـسـت الـمـطـور _ ⚙️'
end
    local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] then
  return '_🌟| المجموعه _* ['..msg.to.title..']*_ بالتأكيد تم تفعيلها ☑️_'
end
local status = getChatAdministrators(msg.to.id).result
for k,v in pairs(status) do
if v.status == "creator" then
if v.user.username then
creator_id = v.user.id
user_name = '@'..check_markdown(v.user.username)
else
user_name = check_markdown(v.user.first_name)
end
end
end
-- create data array in moderation.json
data[tostring(msg.to.id)] = {
owners = {[tostring(creator_id)] = user_name},
mods ={},
banned ={},
is_silent_users ={},
filterlist ={},
replay ={},
whitelist ={},

settings = {
set_name = msg.to.title,
lock_link = 'yes',
lock_tag = 'no',
lock_spam = 'yes',
lock_edit = 'no',
lock_webpage = 'no',
lock_markdown = 'no',
flood = 'yes',
lock_bots = 'yes',
lock_pin = 'no',
lock_woring = 'no',
replay = 'no',
welcome = 'no',
lock_join = 'no',
num_msg_max = '5',
},
   mutes = {
mute_forward = 'yes',
mute_audio = 'no',
mute_video = 'no',
mute_contact = 'yes',
mute_text = 'no',
mute_photo = 'no',
mute_gif = 'no',
mute_location = 'no',
mute_document = 'no',
mute_sticker = 'no',
mute_voice = 'no',
mute_tgservice = 'no',
mute_inline = 'no'
}
}
  save_data(_config.moderation.data, data)
      local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = {}
        save_data(_config.moderation.data, data)
      end
      data[tostring(groups)][tostring(msg.to.id)] = msg.to.id
      save_data(_config.moderation.data, data)
return '_🌟| المجموعه _ *['..msg.to.title..'] تم  تفعيلها بنجاح ☑️*'
end

local function modrem(msg)
    -- superuser and admins only (because sudo are always has privilege)
      if not is_sudo(msg) then
return '🌟| _أنـت لـسـت الـمـطـور _ ⚙️'
   end
    local data = load_data(_config.moderation.data)
    local receiver = msg.to.id
  if not data[tostring(msg.to.id)] then
return '_🌟| المجموعه _* ['..msg.to.title..']*_ بالتأكيد تم تعطيلها ☑️_'
  end

  data[tostring(msg.to.id)] = nil
  save_data(_config.moderation.data, data)
     local groups = 'groups'
      if not data[tostring(groups)] then
        data[tostring(groups)] = nil
        save_data(_config.moderation.data, data)
      end data[tostring(groups)][tostring(msg.to.id)] = nil
      save_data(_config.moderation.data, data)
return '_🌟| المجموعه _* ['..msg.to.title..']*_ تم تعطيلها ☑️_'

end

local function modlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
    return  "🌟| _هذه المجموعه ليست من حمايتي ☑️_"
 end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['mods']) == nil then --fix way
return  "🌟| _لا يوجد ادمن في هذه المجموعه ☑️_"
end
   message = '🌟| *قائمه الادمنيه :*\n'
  for k,v in pairs(data[tostring(msg.to.id)]['mods'])
do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function ownerlist(msg)
    local data = load_data(_config.moderation.data)
    local i = 1
  if not data[tostring(msg.to.id)] then
    return  "🌟| _هذه المجموعه ليست من حمايتي ☑️_"
end
  -- determine if table is empty
  if next(data[tostring(msg.to.id)]['owners']) == nil then --fix way
return  "🌟| _ لا يوجد هنا مدير ⚙️_"
end
   message = '🌟| *قائمه المدراء :*\n'
  for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
    message = message ..i.. '- '..v..' [' ..k.. '] \n'
   i = i + 1
end
  return message
end

local function filter_word(msg, word)
    local data = load_data(_config.moderation.data)
    if not data[tostring(msg.to.id)]['filterlist'] then
      data[tostring(msg.to.id)]['filterlist'] = {}
      save_data(_config.moderation.data, data)
    end
    if data[tostring(msg.to.id)]['filterlist'][(word)] then
 return  "🌟| _ الكلمه_ *"..word.."* _هي بالتأكيد من قائمه المنع☑️_"
      end
    data[tostring(msg.to.id)]['filterlist'][(word)] = true
    save_data(_config.moderation.data, data)
 return  "🌟| _ الكلمه_ *"..word.."* _تمت اضافتها الى قائمه المنع ☑️_"
    end

local function unfilter_word(msg, word)
    local data = load_data(_config.moderation.data)
    if not data[tostring(msg.to.id)]['filterlist'] then
      data[tostring(msg.to.id)]['filterlist'] = {}
      save_data(_config.moderation.data, data)
    end
    if data[tostring(msg.to.id)]['filterlist'][word] then
      data[tostring(msg.to.id)]['filterlist'][(word)] = nil
      save_data(_config.moderation.data, data)
return  "🌟| _ الكلمه_ *"..word.."* _تم السماح بها ☑️_"
    else
      return  "🌟| _ الكلمه_ *"..word.."* _هي بالتأكيد مسموح بها☑️_"
    end
  end


---------------Lock replay-------------------
local function lock_replay(msg, data, target)
if not is_mod(msg) then
 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
end
local replay = data[tostring(target)]["settings"]["replay"] 
if replay == "no" then
return '🌟| _مرحبا عزيزي_ \n🌟| _الردود بالتأكيد تم ايقافه ☑️_'
else
data[tostring(target)]["settings"]["replay"] = "no"
save_data(_config.moderation.data, data) 
return '🌟| _مرحبا عزيزي_ \n🌟| _تم ايقاف الردود  ☑️_'
end
end

local function unlock_replay(msg, data, target)
 if not is_mod(msg) then
 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
end 
local replay = data[tostring(target)]["settings"]["replay"]
 if replay == "yes" then
return '🌟| _مرحبا عزيزي_ \n🌟| _الردود بالتأكيد تم تشغيله ☑️_'
else 
data[tostring(target)]["settings"]["replay"] = "yes"
save_data(_config.moderation.data, data) 
return '🌟| _مرحبا عزيزي_ \n🌟| _تم تشغيل الردود  ☑️_'
end
end

---------------Lock Link-------------------
local function lock_link(msg, data, target)

if not is_mod(msg) then
 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
end

local lock_link = data[tostring(target)]["settings"]["lock_link"] 
if lock_link == "yes" then
return '🌟| _مرحبا عزيزي_ \n🌟| _الروابط بالتأكيد تم قفلها_ ☑️'
else
data[tostring(target)]["settings"]["lock_link"] = "yes"
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل الروابط_ ☑️'

end
end

local function unlock_link(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end 

local lock_link = data[tostring(target)]["settings"]["lock_link"]
 if lock_link == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الروابط بالتأكيد تم فتحها_ ☑️'

else 
data[tostring(target)]["settings"]["lock_link"] = "no" save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح الروابط_ ☑️'

end
end

---------------Lock Tag-------------------
local function lock_tag(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local lock_tag = data[tostring(target)]["settings"]["lock_tag"] 
if lock_tag == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _التاك(#) بالتأكيد تم قفله_ ☑️'

else
 data[tostring(target)]["settings"]["lock_tag"] = "yes"
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل التاك(#)_ ☑️'

end
end

local function unlock_tag(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
 
end
local lock_tag = data[tostring(target)]["settings"]["lock_tag"]
 if lock_tag == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _التاك(#) بالتأكيد تم فتحه_ ☑️'

else 
data[tostring(target)]["settings"]["lock_tag"] = "no" save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح التاك(#)_ ☑️'
end
end

---------------Lock Mention-------------------
local function lock_mention(msg, data, target)
 
if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local lock_mention = data[tostring(target)]["settings"]["lock_mention"] 
if lock_mention == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _التذكير بالتأكيد تم قفله_ ☑️'

else
 data[tostring(target)]["settings"]["lock_mention"] = "yes"
save_data(_config.moderation.data, data)

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل التذكير_ ☑️'

end
end

local function unlock_mention(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
 
end 

local lock_mention = data[tostring(target)]["settings"]["lock_mention"]
 if lock_mention == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _التذكير بالتأكيد تم فتحه_ ☑️'

else 
data[tostring(target)]["settings"]["lock_mention"] = "no" save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح التذكير _☑️'

end
end


---------------Lock Edit-------------------
local function lock_edit(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local lock_edit = data[tostring(target)]["settings"]["lock_edit"] 
if lock_edit == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _التعديل بالتأكيد تم قفله_ ☑️'

else
 data[tostring(target)]["settings"]["lock_edit"] = "yes"
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل التعديل_ ☑️'

end
end

local function unlock_edit(msg, data, target)
if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
end 

local lock_edit = data[tostring(target)]["settings"]["lock_edit"]
 if lock_edit == "no" then
return '🌟| _مرحبا عزيزي_ \n🌟| _التعديل بالتأكيد تم فتحه_ ☑️'
else 
data[tostring(target)]["settings"]["lock_edit"] = "no" save_data(_config.moderation.data, data) 
return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح التعديل_ ☑️'
end
end

---------------Lock spam-------------------
local function lock_spam(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local lock_spam = data[tostring(target)]["settings"]["lock_spam"] 
if lock_spam == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الكلايش بالتأكيد تم قفلها_ ☑️'

else
 data[tostring(target)]["settings"]["lock_spam"] = "yes"
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل الكلايش_ ☑️'

end
end

local function unlock_spam(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
 
end 

local lock_spam = data[tostring(target)]["settings"]["lock_spam"]
 if lock_spam == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الكلايش بالتأكيد تم فتحها_ ☑️'

else 
data[tostring(target)]["settings"]["lock_spam"] = "no" 
save_data(_config.moderation.data, data)

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح الكلايش_ ☑️'

end
end

---------------Lock Flood-------------------
local function lock_flood(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local lock_flood = data[tostring(target)]["settings"]["flood"] 
if lock_flood == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _التكرار بالتأكيد تم قفله_ ☑️'

else
 data[tostring(target)]["settings"]["flood"] = "yes"
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل التكرار_ ☑️'

end
end

local function unlock_flood(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end 

local lock_flood = data[tostring(target)]["settings"]["flood"]
 if lock_flood == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _التكرار بالتأكيد تم فتحه_ ☑️'

else 
data[tostring(target)]["settings"]["flood"] = "no" save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح التكرار_ ☑️'

end
end

---------------Lock Bots-------------------
local function lock_bots(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"] 
if lock_bots == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _البوتات بالتأكيد تم قفلها_ ☑️'

else
 data[tostring(target)]["settings"]["lock_bots"] = "yes"
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل البوتات_ ☑️'

end
end

local function unlock_bots(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
 
end

local lock_bots = data[tostring(target)]["settings"]["lock_bots"]
 if lock_bots == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _البوتات بالتأكيد تم فتحها_ ☑️'

else 
data[tostring(target)]["settings"]["lock_bots"] = "no" save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح البوتات_ ☑️'

end
end

---------------Lock Join-------------------
local function lock_join(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local lock_join = data[tostring(target)]["settings"]["lock_join"] 
if lock_join == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الاضافه بالتأكيد تم قفلها  _ ☑️'

else
 data[tostring(target)]["settings"]["lock_join"] = "yes"
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل الاضافه_ ☑️'

end
end

local function unlock_join(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
end

local lock_join = data[tostring(target)]["settings"]["lock_join"]
 if lock_join == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الاضافه بالتأكيد تم فتحها  _ ☑️'

else 
data[tostring(target)]["settings"]["lock_join"] = "no"
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح الاضافه_ ☑️'

end
end

---------------Lock Markdown-------------------
local function lock_markdown(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"] 
if lock_markdown == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الماركدوان بالتأكيد تم قفله _ ☑️'

else
 data[tostring(target)]["settings"]["lock_markdown"] = "yes"
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل الماركدوان_ ☑️'

end
end

local function unlock_markdown(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
 
end

local lock_markdown = data[tostring(target)]["settings"]["lock_markdown"]
 if lock_markdown == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الماركدوان بالتأكيد تم فتحه_ ☑️'

else 
data[tostring(target)]["settings"]["lock_markdown"] = "no" save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح الماركدوان_ ☑️'

end
end

---------------Lock Webpage-------------------
local function lock_webpage(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"] 
if lock_webpage == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الويب بالتأكيد تم قفله_ ☑️'

else
 data[tostring(target)]["settings"]["lock_webpage"] = "yes"
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل الويب_☑️'

end
end

local function unlock_webpage(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
 
end

local lock_webpage = data[tostring(target)]["settings"]["lock_webpage"]
 if lock_webpage == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الويب بالتأكيد تم فتحه_ ☑️'

else 
data[tostring(target)]["settings"]["lock_webpage"] = "no"
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح الويب_ ☑️'

end
end

---------------Lock Pin-------------------
local function lock_pin(msg, data, target) 

if not is_mod(msg) then
 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
end
local lock_pin = data[tostring(target)]["settings"]["lock_pin"] 
if lock_pin == "yes" then
return '🌟| _مرحبا عزيزي_ \n🌟| _التثبيت بالتأكيد تم قفله_ ☑️'
else
 data[tostring(target)]["settings"]["lock_pin"] = "yes"
save_data(_config.moderation.data, data) 
return "🌟| _مرحبا عزيزي_ \n🌟| _تم قفل التثبيت_☑️"
end
end

local function unlock_pin(msg, data, target)
 if not is_mod(msg) then
 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
end
local lock_pin = data[tostring(target)]["settings"]["lock_pin"]
 if lock_pin == "no" then
return '🌟| _مرحبا عزيزي_ \n🌟| _التثبيت بالتأكيد تم فتحه_ ☑️'
else 
data[tostring(target)]["settings"]["lock_pin"] = "no"
save_data(_config.moderation.data, data) 
return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح التثبيت_ ☑️'
end
end
--------Mutes---------

---------------Mute Gif-------------------
local function mute_gif(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"] 
if mute_gif == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _المتحركه بالتأكيد تم قفلها_ ☑️'

else
 data[tostring(target)]["mutes"]["mute_gif"] = "yes" 
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل المتحركه_ ☑️'

end
end

local function unmute_gif(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end 

local mute_gif = data[tostring(target)]["mutes"]["mute_gif"]
 if mute_gif == "no" then
return '🌟| _مرحبا عزيزي_ \n🌟| _المتحركه بالتأكيد تم فتحها_ ☑️'

else 
data[tostring(target)]["mutes"]["mute_gif"] = "no"
 save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح المتحركه_ ☑️'

end
end
---------------Mute Game-------------------
local function mute_game(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local mute_game = data[tostring(target)]["mutes"]["mute_game"] 
if mute_game == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الالعاب بالتأكيد تم قفلها_ ☑️'

else
 data[tostring(target)]["mutes"]["mute_game"] = "yes" 
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل الالعاب_ ☑️'

end
end

local function unmute_game(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
 
end

local mute_game = data[tostring(target)]["mutes"]["mute_game"]
 if mute_game == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الألعاب بالتأكيد تم فتحها_ ☑️'

else 
data[tostring(target)]["mutes"]["mute_game"] = "no"
 save_data(_config.moderation.data, data)

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح الألعاب_ ☑️'

end
end
---------------Mute Inline-------------------
local function mute_inline(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"] 
if mute_inline == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الانلاين بالتأكيد تم قفله_ ☑️'

else
 data[tostring(target)]["mutes"]["mute_inline"] = "yes" 
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل الانلاين_ ☑️'

end
end

local function unmute_inline(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end 

local mute_inline = data[tostring(target)]["mutes"]["mute_inline"]
 if mute_inline == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الانلاين بالتأكيد تم فتحه_ ☑️'

else 
data[tostring(target)]["mutes"]["mute_inline"] = "no"
 save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح الانلاين_ ☑️'

end
end
---------------Mute Text-------------------
local function mute_text(msg, data, target) 

if not is_mod(msg) then
 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local mute_text = data[tostring(target)]["mutes"]["mute_text"] 
if mute_text == "yes" then
return '🌟| _مرحبا عزيزي_ \n🌟| _الدرشه بالتأكيد تم قفلها_ ☑️'

else
 data[tostring(target)]["mutes"]["mute_text"] = "yes" 
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل الدردشه_ ☑️'

end
end

local function unmute_text(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
 
end

local mute_text = data[tostring(target)]["mutes"]["mute_text"]
 if mute_text == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الدردشه بالتأكيد تم فتحها_ ☑️'

else 
data[tostring(target)]["mutes"]["mute_text"] = "no"
 save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح الدردشه_ ☑️'

end
end
---------------Mute photo-------------------
local function mute_photo(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local mute_photo = data[tostring(target)]["mutes"]["mute_photo"] 
if mute_photo == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الصور بالتأكيد تم قفلها_ ☑️'

else
 data[tostring(target)]["mutes"]["mute_photo"] = "yes" 
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل الصور_ ☑️'

end
end

local function unmute_photo(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end
 
local mute_photo = data[tostring(target)]["mutes"]["mute_photo"]
 if mute_photo == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الصور بالتأكيد تم فتحها_ ☑️'

else 
data[tostring(target)]["mutes"]["mute_photo"] = "no"
 save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح الصور_ ☑️'

end
end
---------------Mute Video-------------------
local function mute_video(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local mute_video = data[tostring(target)]["mutes"]["mute_video"] 
if mute_video == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الفيديو بالتأكيد تم قفلها_ ☑️'

else
 data[tostring(target)]["mutes"]["mute_video"] = "yes" 
save_data(_config.moderation.data, data)

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل الفيديو_ ☑️'

end
end

local function unmute_video(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end 

local mute_video = data[tostring(target)]["mutes"]["mute_video"]
 if mute_video == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الفيديو يالتأكيد تم فتحها_ ☑️'

else 
data[tostring(target)]["mutes"]["mute_video"] = "no"
 save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح الفيديو_ ☑️'
end
end
---------------Mute Audio-------------------
local function mute_audio(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"] 
if mute_audio == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _البصمات بالتأكيد تم قفلها_ ☑️'

else
 data[tostring(target)]["mutes"]["mute_audio"] = "yes" 
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل البصمات_ ☑️'

end
end

local function unmute_audio(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end 

local mute_audio = data[tostring(target)]["mutes"]["mute_audio"]
 if mute_audio == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _البصمات بالتأكيد تم فتحها_ ☑️'

else 
data[tostring(target)]["mutes"]["mute_audio"] = "no"
 save_data(_config.moderation.data, data)

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح البصمات_ ☑️'

end
end
---------------Mute Voice-------------------
local function mute_voice(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"] 
if mute_voice == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الصوت بالتأكيد تم قفله_ ☑️'

else
 data[tostring(target)]["mutes"]["mute_voice"] = "yes" 
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل الصوت_ ☑️'
end

end

local function unmute_voice(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end 

local mute_voice = data[tostring(target)]["mutes"]["mute_voice"]
 if mute_voice == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الصوت بالتأكيد تم فتحه_ ☑️'

else 
data[tostring(target)]["mutes"]["mute_voice"] = "no"
 save_data(_config.moderation.data, data)

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح الصوت_ ☑️'

end
end
---------------Mute Sticker-------------------
local function mute_sticker(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"] 
if mute_sticker == "yes" then

return '🌟| _مرحبا عزيزي_ \n��¦ _الملصقات بالتأكيد تم قفلها_ ☑️'

else
 data[tostring(target)]["mutes"]["mute_sticker"] = "yes" 
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل الملصقات_ ☑️'

end
end

local function unmute_sticker(msg, data, target)

 if not is_mod(msg) then
 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
end

local mute_sticker = data[tostring(target)]["mutes"]["mute_sticker"]
 if mute_sticker == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الملصقات بالتأكيد تم فتحها_ ☑️'

else 
data[tostring(target)]["mutes"]["mute_sticker"] = "no"
 save_data(_config.moderation.data, data)

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح الملصقات_ ☑️'
 
end
end
---------------Mute Contact-------------------
local function mute_contact(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"] 
if mute_contact == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _جهات الاتصال بالتأكيد تم قفلها_ ☑️'

else
 data[tostring(target)]["mutes"]["mute_contact"] = "yes" 
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل جهات الاتصال_ ☑️'

end
end

local function unmute_contact(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end 

local mute_contact = data[tostring(target)]["mutes"]["mute_contact"]
 if mute_contact == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _جهات الاتصال بالتأكيد تم فتحها_ ☑️'

else 
data[tostring(target)]["mutes"]["mute_contact"] = "no"
 save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح جهات الاتصال_ ☑️'

end
end
---------------Mute Forward-------------------
local function mute_forward(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local mute_forward = data[tostring(target)]["mutes"]["mute_forward"] 
if mute_forward == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _التوجيه بالتأكيد تم قفلها_ ☑️'

else
 data[tostring(target)]["mutes"]["mute_forward"] = "yes" 
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل التوجيه_ ☑️'

end
end

local function unmute_forward(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end 

local mute_forward = data[tostring(target)]["mutes"]["mute_forward"]
 if mute_forward == "no" then
return '🌟| _مرحبا عزيزي_ \n🌟| _التوجيه بالتأكيد تم فتحها_ ☑️'
else 
data[tostring(target)]["mutes"]["mute_forward"] = "no"
 save_data(_config.moderation.data, data)

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح التوجيه_ ☑️'
end
end
---------------Mute Location-------------------
local function mute_location(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local mute_location = data[tostring(target)]["mutes"]["mute_location"] 
if mute_location == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الموقع بالتأكيد تم قفله_ ☑️'

else
 data[tostring(target)]["mutes"]["mute_location"] = "yes" 
save_data(_config.moderation.data, data)

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل الموقع_ ☑️'

end
end

local function unmute_location(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end 

local mute_location = data[tostring(target)]["mutes"]["mute_location"]
 if mute_location == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الموقع بالتأكيد تم فتحه_ ☑️'

else 
data[tostring(target)]["mutes"]["mute_location"] = "no"
 save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح الموقع_ ☑️'

end
end
---------------Mute Document-------------------
local function mute_document(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local mute_document = data[tostring(target)]["mutes"]["mute_document"] 
if mute_document == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الملفات بالتأكيد تم قفلها_ ☑️'

else
 data[tostring(target)]["mutes"]["mute_document"] = "yes" 
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل الملفات_ ☑️'

end
end

local function unmute_document(msg, data, target)

 if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
end
 

local mute_document = data[tostring(target)]["mutes"]["mute_document"]
 if mute_document == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الملفات بالتأكيد تم فتحها_ ☑️'

else 
data[tostring(target)]["mutes"]["mute_document"] = "no"
 save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح الملفات_ ☑️'

end
end
---------------Mute TgService-------------------
local function mute_tgservice(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"] 
if mute_tgservice == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الاشعارات بالتأكيد تم فتحها_ ☑️'

else
 data[tostring(target)]["mutes"]["mute_tgservice"] = "yes" 
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل الاشعارات_ ☑️'
end
end

local function unmute_tgservice(msg, data, target)

 if not is_mod(msg) then
 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
end

local mute_tgservice = data[tostring(target)]["mutes"]["mute_tgservice"]
 if mute_tgservice == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الاشعارات بالتأكيد تم فتحها_ ☑️'
else 
data[tostring(target)]["mutes"]["mute_tgservice"] = "no"
 save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _الاشعارات بالتأكيد تم فتحها_ ☑️'

end
end

---------------Mute Keyboard-------------------
local function mute_keyboard(msg, data, target) 

if not is_mod(msg) then

 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"

end

local mute_keyboard = data[tostring(target)]["mutes"]["mute_keyboard"] 
if mute_keyboard == "yes" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الكيبورد بالتأكيد تم قفله_ ☑️'

else
 data[tostring(target)]["mutes"]["mute_keyboard"] = "yes" 
save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل الكيبورد_ ☑️'

end
end

local function unmute_keyboard(msg, data, target)

 if not is_mod(msg) then
 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
end

local mute_keyboard = data[tostring(target)]["mutes"]["mute_keyboard"]
 if mute_keyboard == "no" then

return '🌟| _مرحبا عزيزي_ \n🌟| _الكيبورد بالتأكيد تم فتحه_ ☑️'
 
else 
data[tostring(target)]["mutes"]["mute_keyboard"] = "no"
 save_data(_config.moderation.data, data) 

return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح الكيبورد_ ☑️'
 
end
end

function group_settings(msg, target) 	
 local target = msg.to.id 
local data = load_data(_config.moderation.data)
if not is_mod(msg) then
 return "🌟| _هذا الامر يخص الادمنيه فقط _ 🚶"
end
if data[tostring(target)] then 	
if data[tostring(target)]["settings"]["num_msg_max"] then 	
NUM_MSG_MAX = tonumber(data[tostring(target)]['settings']['num_msg_max'])
else 	
NUM_MSG_MAX = 5
end
end
local expire_date = ''
local expi = redis:ttl('ExpireDate:'..msg.to.id)
local day = math.floor(expi / 86400) + 1
if expi == -1 then
	expire_date = 'مفتوح🎖'
    elseif day == 1 then
	expire_date = 'يوم واحد' 
	elseif day == 2 then
   	expire_date = 'يومين'
	elseif day == 3 then
   	expire_date = '3 ايام'
   	else
	expire_date = day..' يوم'
end
local settings = data[tostring(target)]["settings"] 
local mutes = data[tostring(target)]["mutes"] 

 text = "🗯¦` اعدادات الوسائط :`"
 .."\n🌟| قفل المتحركه : "..mutes.mute_gif
 --.."\n🌟| قفل الدردشه : "..mutes.mute_text
 .."\n🌟| قفل الانلاين : "..mutes.mute_inline
 --.."\n🌟| قفل الالعاب : "..mutes.mute_game
 .."\n🌟| قفل الصور : "..mutes.mute_photo
 .."\n🌟| قفل الفيديو : "..mutes.mute_video
 .."\n🌟| قفل البصمات : "..mutes.mute_audio
 .."\n🌟| قفل الصوت : "..mutes.mute_voice
 .."\n🌟| قفل الملصقات : "..mutes.mute_sticker
 .."\n🌟| قفل الجهات : "..mutes.mute_contact
 .."\n🌟| قفل التوجيه : "..mutes.mute_forward
-- .."\n🌟| قفل الموقع : "..mutes.mute_location
-- .."\n🌟| قفل الملفات : "..mutes.mute_document
 .."\n🌟| قفل الاشعارات : "..mutes.mute_tgservice
-- .."\n🌟| قفل الكيبورد : "..mutes.mute_keyboard

.."\n\n🗯¦` اعدادات المجموعه :` "
 .."\n🌟| قفل التعديل : "..settings.lock_edit
 .."\n🌟| قفل الروابط : "..settings.lock_link
 .."\n🌟| قفل الاضافه : "..settings.lock_join
 .."\n🌟| قفل التاك : "..settings.lock_tag
 .."\n🌟| قفل التكرار : "..settings.flood
-- .."\n🌟| قفل الكلايش : "..settings.lock_spam
-- .."\n🌟| قفل الويب : "..settings.lock_webpage
-- .."\n🌟| قفل الماركدوان : "..settings.lock_markdown
 .."\n🌟| قفل التثبيت : "..settings.lock_pin
 .."\n🌟| قفل البوتات : "..settings.lock_bots
 .."\n🌟| عدد التكرار : "..NUM_MSG_MAX
.."\n\n🗯¦` اعدادات اخرى : `"
.."\n🌟| تشغيل الترحيب : "..settings.welcome
.."\n🌟| تشغيل الردود : "..settings.replay
.."\n🌟| تشغيل التحذير : "..settings.lock_woring

.." \n\n🌟| الاشتراك :` "..expire_date
 .."`\n🌟| TSHARLY V1 |"
 .."\n🌟| قنـاه الــسـورس : @SNaK_BoT\n"



text = string.gsub(text, 'yes', '☑️')
text = string.gsub(text, 'no', '❌')
return text
end

local function phplua(msg, matches)
local data = load_data(_config.moderation.data)
local target = msg.to.id
----------------Begin Msg Matches--------------
if msg.to.type == 'private' then return end

if matches[1] == "تفعيل" and is_sudo(msg) then
return modadd(msg)
   end
if matches[1] == "تعطيل" and is_sudo(msg) then
return modrem(msg)
 end
 
 if not data[tostring(msg.to.id)] then return end
 
if matches[1] == "الاداريين" and is_mod(msg) then
return ownerlist(msg)
   end
if matches[1] == "قائمه المنع" and is_mod(msg) then
return filter_list(msg)
   end
if matches[1] == "الادمنيه" and is_mod(msg) then
return modlist(msg)
   end
if matches[1] == "الاعضاء المميزين" and is_mod(msg) then
return whitelist(msg.to.id)
   end

if matches[1] == "ايدي" then
   if not matches[2] and not msg.reply_to_message then
local status = getUserProfilePhotos(msg.from.id, 0, 0)
local rank
if is_sudo(msg) then
rank = 'المطور مالتي 😻'
elseif is_owner(msg) then
rank = 'مدير المجموعه 😽'
elseif is_mod(msg) then
rank = 'ادمن في البوت 😺'
else
rank = 'مجرد عضو 😼'
end
if msg.from.username then
userxn = "@"..(msg.from.username or "---")
else
userxn = "لا يتوفر"
end
local msgs = tonumber(redis:get('msgs:'..msg.from.id..':'..msg.to.id) or 0)
if status.result.total_count ~= 0 then
	sendPhotoById(msg.to.id, status.result.photos[1][1].file_id, msg.id, '🌟| اسمك : '..msg.from.first_name..'\n🌟| معرفك : '..userxn..'\n🌟| ايديك : '..msg.from.id..'\n🌟| رتبتك : '..rank..'\n💬¦ عدد رسائلك : ['..msgs..'] رسالة 👮‍♀️\n')
	else
return '🌟|لا توجد صورة في بروفايلك !!! \n🌟| اسمك : '..msg.from.first_name..'\n🌟| معرفك : '..userxn..'\n🌟| ايديك : '..msg.from.id..'\n🌟| رتبتك : '..rank..'\n💬¦ عدد رسائلك : ['..msgs..'] رسالة 👮‍♀️\n'
end
   elseif not msg.reply_to_message and string.match(matches[2], '@[%a%d_]')  and matches[2] ~= "التوجيه" and is_mod(msg) then
    local status = resolve_username(matches[2])
		if not status.result then
			return '🌟|لا يوجد عضو بهذا المعرف ...'
		end
     return ""..status.information.id..""
   elseif matches[2] == "التوجيه" and msg.reply_to_message and msg.reply.fwd_from then
     return ""..msg.reply.fwd_from.id..""
   end
end
if matches[1] == "تثبيت" and is_mod(msg) and msg.reply_id then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
    data[tostring(msg.to.id)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
pinChatMessage(msg.to.id, msg.reply_id)
return "🌟| _مرحبآ عزيزي_\n🌟| _ تم تثبيت الرساله_ ☑️"
elseif not is_owner(msg) then
   return "🌟| للمدراء فقط 🎖"
 end
 elseif lock_pin == 'no' then
    data[tostring(msg.to.id)]['pin'] = msg.reply_id
	  save_data(_config.moderation.data, data)
pinChatMessage(msg.to.id, msg.reply_id)
return "🌟| _مرحبآ عزيزي_\n🌟| _ تم تثبيت الرساله_ ☑️"
end
end
if matches[1] == 'الغاء التثبيت' and is_mod(msg) then
local lock_pin = data[tostring(msg.to.id)]["settings"]["lock_pin"] 
 if lock_pin == 'yes' then
if is_owner(msg) then
unpinChatMessage(msg.to.id)
return "🌟| _مرحبآ عزيزي_\n🌟| _ تم الغاء تثبيت الرساله_ ☑️"
elseif not is_owner(msg) then
   return "🌟| للمدراء فقط 🎖"
 end
 elseif lock_pin == 'no' then
unpinChatMessage(msg.to.id)
return "🌟| _مرحبآ عزيزي_\n🌟| _ تم الغاء تثبيت الرساله_ ☑️"
end
end

if matches[1] == 'الحمايه' then
return group_settings(msg, target)
end
if matches[1] == "رفع المدير" and is_sudo(msg) then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] then
    return "🌟| العضو :  "..username.."\n🌟| الايدي :  ["..msg.reply.id.."]\n🌟| انه بالتأكيد مدير"
    else
  data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  "..username.."\n🌟| الايدي :  ["..msg.reply.id.."] \n🌟| تم ترقيتة بيصبح مدير"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "🌟| لا يوجد عضو بهذا المعرف."
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['owners'][tostring(matches[2])] then
    return "🌟| العضو :  "..user_name.."\n🌟| الايدي :  ["..matches[2].."]\n🌟| انه بالتأكيد مدير"
    else
  data[tostring(msg.to.id)]['owners'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  "..user_name.."\n🌟| الايدي :  ["..matches[2].."] \n🌟| تم ترقيتة بيصبح مدير"
   end
   elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
  if not resolve_username(matches[2]).result then
   return "🌟| لا يوجد عضو بهذا المعرف."
    end
   local status = resolve_username(matches[2]).information
   if data[tostring(msg.to.id)]['owners'][tostring(status.id)] then
    return "🌟| العضو :  @"..check_markdown(status.username).."\n🌟| الايدي :  ["..status.id.."]\n🌟| انه بالتأكيد مدير"
    else
  data[tostring(msg.to.id)]['owners'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  @"..check_markdown(status.username).."\n🌟| الايدي :  ["..status.id.."] \n🌟| تم ترقيتة بيصبح مدير"
   end
end
end
if matches[1] == "تنزيل المدير" and is_sudo(msg) then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] then
    return "🌟| العضو :  "..username.."\n🌟| الايدي :  ["..msg.reply.id.."]\n🌟| انه بالتأكيد تم تنزيله من الادارة "
    else
  data[tostring(msg.to.id)]['owners'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  "..username.."\n🌟| الايدي :  ["..msg.reply.id.."]\n🌟| تم تنزيله من الادارة "
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "🌟| لا يوجد عضو بهذا المعرف."
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['owners'][tostring(matches[2])] then
    return "🌟| العضو :  "..user_name.."\n🌟| الايدي :  ["..matches[2].."]\n🌟| انه بالتأكيد تم تنزيله من الادارة "
    else
  data[tostring(msg.to.id)]['owners'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  "..user_name.."\n🌟| الايدي :  ["..matches[2].."]\n🌟| تم تنزيله من الادارة "
      end
   elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
  if not resolve_username(matches[2]).result then
   return "🌟| لا يوجد عضو بهذا المعرف."
    end
   local status = resolve_username(matches[2]).information
   if not data[tostring(msg.to.id)]['owners'][tostring(status.id)] then
    return "🌟| العضو :  @"..check_markdown(status.username).."\n🌟| الايدي :  ["..status.id.."]\n🌟| انه بالتأكيد تم تنزيله من الادارة "
    else
  data[tostring(msg.to.id)]['owners'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  @"..check_markdown(status.username).."\n🌟| الايدي :  ["..status.id.."]\n🌟| تم تنزيله من الادارة "
      end
end
end
if matches[1] == "رفع ادمن" and is_owner(msg) then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] then
    return "🌟| العضو :  "..username.."\n🌟| الايدي :  ["..msg.reply.id.."]\n🌟| انه بالتأكيد ادمن "
    else
  data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  "..username.."\n🌟| الايدي :  ["..msg.reply.id.."]\n🌟| تم رفع ادمن "
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "🌟| لا يوجد عضو بهذا المعرف."
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['mods'][tostring(matches[2])] then
    return "🌟| العضو :  "..user_name.."\n🌟| الايدي :  ["..matches[2].."]\n🌟| انه بالتأكيد ادمن "
    else
  data[tostring(msg.to.id)]['mods'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  "..user_name.."\n🌟| الايدي :  ["..matches[2].."]\n🌟| تم رفع ادمن "
   end
   elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
  if not resolve_username(matches[2]).result then
   return "🌟| لا يوجد عضو بهذا المعرف."
    end
   local status = resolve_username(matches[2]).information
   if data[tostring(msg.to.id)]['mods'][tostring(user_id)] then
    return "🌟| العضو :  @"..check_markdown(status.username).."\n🌟| الايدي :  ["..status.id.."]\n🌟| انه بالتأكيد ادمن "
    else
  data[tostring(msg.to.id)]['mods'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  @"..check_markdown(status.username).."\n🌟| الايدي :  ["..status.id.."]\n🌟| تم رفع ادمن "
   end
end
end
if matches[1] == "تنزيل ادمن" and is_owner(msg) then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] then
    return "🌟| العضو :  "..username.."\n🌟| الايدي :  ["..msg.reply.id.."]\n🌟| انه بالتأكيد تم تنزيله من الادمنيه "
    else
  data[tostring(msg.to.id)]['mods'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  "..username.."\n🌟| الايدي :  ["..msg.reply.id.."]\n🌟| تم تنزيله من الادمنيه "
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "🌟| لا يوجد عضو بهذا المعرف."
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['mods'][tostring(matches[2])] then
    return "🌟| العضو :  "..user_name.."\n🌟| الايدي :  ["..matches[2].."]\n🌟| انه بالتأكيد تم تنزيله من الادمنيه "
    else
  data[tostring(msg.to.id)]['mods'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  "..user_name.."\n🌟| الايدي :  ["..matches[2].."]\n🌟| تم تنزيله م�� الادمنيه "
      end
   elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
  if not resolve_username(matches[2]).result then
   return "🌟| لا يوجد عضو بهذا المعرف."
    end
   local status = resolve_username(matches[2]).information
   if not data[tostring(msg.to.id)]['mods'][tostring(status.id)] then
    return "🌟| العضو :  @"..check_markdown(status.username).."\n🌟| الايدي :  ["..status.id.."] \n🌟| انه بالتأكيد تم تنزيله من الادمنيه "
    else
  data[tostring(msg.to.id)]['mods'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  @"..check_markdown(status.username).."\n🌟| الايدي :  ["..status.id.."]\n🌟| تم تنزيله من الادمنيه "
      end
end
end
if matches[1] == "رفع عضو مميز"  and is_mod(msg) then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] then
    return "🌟| العضو :  "..username.."\n🌟| الايدي :  ["..msg.reply.id.."]\n🌟| انه بالتأكيد تم رفعه عضو مميز "
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] = username
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  "..username.."\n🌟| الايدي :  ["..msg.reply.id.."] \n🌟| تم رفع عضو مميز "
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "🌟| لا يوجد عضو بهذا المعرف."
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if data[tostring(msg.to.id)]['whitelist'][tostring(matches[2])] then
    return "🌟| العضو :  "..user_name.."\n🌟| الايدي :  "..matches[2].."\n🌟| انه بالتأكيد تم رفعه عضو مميز "
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(matches[2])] = user_name
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  "..user_name.."\n🌟| الايدي :  "..matches[2].."\n🌟| تم رفع عضو مميز "
   end
   elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
  if not resolve_username(matches[2]).result then
   return "🌟| لا يوجد عضو بهذا المعرف."
    end
   local status = resolve_username(matches[2]).information
   if data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] then
    return "🌟| العضو :  @"..check_markdown(status.username).."\n🌟| الايدي :  ["..status.id.."] \n🌟| انه بالتأكيد تم رفعه عضو مميز "
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] = check_markdown(status.username)
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  @"..check_markdown(status.username).."\n🌟| الايدي :  ["..status.id.."] \n🌟| تم رفع عضو مميز "
   end
end
end
if matches[1] == "تنزيل عضو مميز" and is_mod(msg) then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] then
    return "🌟| العضو :  "..username.."\n🌟| الايدي :  ["..msg.reply.id.."] \n🌟| انه بالتأكيد تم تنزيله عضو مميز "
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(msg.reply.id)] = nil
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  "..username.."\n🌟| الايدي :  ["..msg.reply.id.."] \n🌟| تم تنزيل عضو مميز "
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "🌟| لا يوجد عضو بهذا المعرف."
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
	  if not data[tostring(msg.to.id)]['whitelist'][tostring(matches[2])] then
    return "🌟| العضو :  "..user_name.."\n🌟| الايدي :  "..matches[2].."\n🌟| انه بالتأكيد تم تنزيله الاعضاء المميزين "
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(matches[2])] = nil
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  "..user_name.."\n🌟| الايدي :  "..matches[2].." \n🌟| تم تنزيل الاعضاء المميزين "
      end
   elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
  if not resolve_username(matches[2]).result then
   return "🌟| لا يوجد عضو بهذا المعرف."
    end
   local status = resolve_username(matches[2]).information
   if not data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] then
    return "🌟| العضو :  @"..check_markdown(status.username).."\n🌟| الايدي :  ["..status.id.."] \n🌟| انه بالتأكيد تم تنزيله الاعضاء المميزين "
    else
  data[tostring(msg.to.id)]['whitelist'][tostring(status.id)] = nil
    save_data(_config.moderation.data, data)
    return "🌟| العضو :  @"..check_markdown(status.username).."\n🌟| الايدي :  ["..status.id.."] \n🌟| تم تنزيل الاعضاء المميزين "
      end
end
end
if matches[1]:lower() == "قفل" and is_mod(msg) then
if matches[2] == "الروابط" then
return lock_link(msg, data, target)
end
if matches[2] == "التاك" then
return lock_tag(msg, data, target)
end
if matches[2] == "التعديل" then
return lock_edit(msg, data, target)
end
if matches[2] == "الكلايش" then
return lock_spam(msg, data, target)
end
if matches[2] == "التكرار" then
return lock_flood(msg, data, target)
end
if matches[2] == "البوتات" then
return lock_bots(msg, data, target)
end
if matches[2] == "المالركدوان" then
return lock_markdown(msg, data, target)
end
if matches[2] == "الويب" then
return lock_webpage(msg, data, target)
end
if matches[2] == "التثبيت" and is_owner(msg) then
return lock_pin(msg, data, target)
end
if matches[2] == "الاضافه" then
return lock_join(msg, data, target)
end
end
if matches[1]:lower() == "فتح" and is_mod(msg) then
if matches[2] == "الروابط" then
return unlock_link(msg, data, target)
end
if matches[2] == "التاك" then
return unlock_tag(msg, data, target)
end
if matches[2] == "التعديل" then
return unlock_edit(msg, data, target)
end
if matches[2] == "الكلايش" then
return unlock_spam(msg, data, target)
end
if matches[2] == "التكرار" then
return unlock_flood(msg, data, target)
end
if matches[2] == "البوتات" then
return unlock_bots(msg, data, target)
end
if matches[2] == "الماركدوان" then
return unlock_markdown(msg, data, target)
end
if matches[2] == "الويب" then
return unlock_webpage(msg, data, target)
end
if matches[2] == "التثبيت" and is_owner(msg) then
return unlock_pin(msg, data, target)
end
if matches[2] == "الاضافه" then
return unlock_join(msg, data, target)
end
end
if matches[1]:lower() == "قفل" and is_mod(msg) then
if matches[2] == "المتحركه" then
return mute_gif(msg, data, target)
end
if matches[2] == "الدردشه" then
return mute_text(msg ,data, target)
end
if matches[2] == "الصور" then
return mute_photo(msg ,data, target)
end
if matches[2] == "الفيدديو" then
return mute_video(msg ,data, target)
end
if matches[2] == "الصوت" then
return mute_audio(msg ,data, target)
end
if matches[2] == "البصمات" then
return mute_voice(msg ,data, target)
end
if matches[2] == "الملصقات" then
return mute_sticker(msg ,data, target)
end
if matches[2] == "الجهات" then
return mute_contact(msg ,data, target)
end
if matches[2] == "التوجيه" then
return mute_forward(msg ,data, target)
end
if matches[2] == "الموقع" then
return mute_location(msg ,data, target)
end
if matches[2] == "الملفات" then
return mute_document(msg ,data, target)
end
if matches[2] == "الاشعارات" then
return mute_tgservice(msg ,data, target)
end
if matches[2] == 'الكل' then
    local close_all ={
 mute_gif(msg, data, target),
 mute_photo(msg ,data, target),
 mute_audio(msg ,data, target),
 mute_voice(msg ,data, target),
 mute_sticker(msg ,data, target),
 mute_forward(msg ,data, target),
 mute_contact(msg ,data, target),
 mute_location(msg ,data, target),
 mute_document(msg ,data, target),
 mute_inline(msg ,data, target),
 lock_link(msg, data, target),
 lock_tag(msg, data, target),
 lock_mention(msg, data, target),
 lock_edit(msg, data, target),
 lock_spam(msg, data, target),
 lock_bots(msg, data, target),
 lock_webpage(msg, data, target),
 mute_video(msg ,data, target),
   }
  return '🌟| _مرحبا عزيزي_ \n🌟| _تم قفل الكل _ ☑️',close_all
end
end
if matches[1]:lower() == "فتح" and is_mod(msg) then
if matches[2] == "المتحركه" then
return unmute_gif(msg, data, target)
end
if matches[2] == "الدردشه" then
return unmute_text(msg, data, target)
end
if matches[2] == "الصور" then
return unmute_photo(msg ,data, target)
end
if matches[2] == "الفيديو" then
return unmute_video(msg ,data, target)
end
if matches[2] == "الصوت" then
return unmute_audio(msg ,data, target)
end
if matches[2] == "البصمات" then
return unmute_voice(msg ,data, target)
end
if matches[2] == "الملصفات" then
return unmute_sticker(msg ,data, target)
end
if matches[2] == "الجهات" then
return unmute_contact(msg ,data, target)
end
if matches[2] == "التوجيه" then
return unmute_forward(msg ,data, target)
end
if matches[2] == "الموقع" then
return unmute_location(msg ,data, target)
end
if matches[2] == "الملفات" then
return unmute_document(msg ,data, target)
end
if matches[2] == "الاشعارات" then
return unmute_tgservice(msg ,data, target)
end
 if matches[2] == 'الكل' then
    local open_all ={
 unmute_gif(msg, data, target),
 unmute_photo(msg ,data, target),
 unmute_audio(msg ,data, target),
 unmute_voice(msg ,data, target),
 unmute_sticker(msg ,data, target),
 unmute_forward(msg ,data, target),
 unmute_contact(msg ,data, target),
 unmute_location(msg ,data, target),
 unmute_document(msg ,data, target),
 unlock_link(msg, data, target),
 unlock_tag(msg, data, target),
 unlock_mention(msg, data, target),
 unlock_edit(msg, data, target),
 unlock_spam(msg, data, target),
 unlock_bots(msg, data, target),
 unlock_webpage(msg, data, target),
 unmute_video(msg ,data, target),
 unmute_inline(msg ,data, target)
    }
 
return '🌟| _مرحبا عزيزي_ \n🌟| _تم فتح الكل _ ☑️',open_all
end
end
  if matches[1] == 'منع' and matches[2] and is_mod(msg) then
    return filter_word(msg, matches[2])
  end
  if matches[1] == 'الغاء منع' and matches[2] and is_mod(msg) then
    return unfilter_word(msg, matches[2])
  end
  if matches[1] == 'تغيير الرابط' and is_mod(msg) then
  local administration = load_data(_config.moderation.data)
  local link = exportChatInviteLink(msg.to.id)
	if not link then
		return "*البوت ليس منشئ المجموعة قم بأضافة الرابط بأرسال* [ ضع رابط ]"
	else
		administration[tostring(msg.to.id)]['settings']['linkgp'] = link.result
		save_data(_config.moderation.data, administration)
		return "*🌟| _شكرأ لك 😻_\n🌟| _تم حفظ الرابط بنجاح _☑️ *"
	end
   end
		if matches[1] == 'ضع رابط' and is_owner(msg) then
		data[tostring(target)]['settings']['linkgp'] = 'waiting'
			save_data(_config.moderation.data, data)
return "🌟| _مرحبآ عزيزي_\n🌟| _رجائا ارسل الرابط الآن _🔃"
	   end
		if msg.text then
   local is_link = msg.text:match("^([https?://w]*.?telegram.me/joinchat/%S+)$") or msg.text:match("^([https?://w]*.?t.me/joinchat/%S+)$")
			if is_link and data[tostring(target)]['settings']['linkgp'] == 'waiting' and is_owner(msg) then
				data[tostring(target)]['settings']['linkgp'] = msg.text
				save_data(_config.moderation.data, data)
return "🌟| _شكرأ لك 😻_\n🌟| _تم حفظ الرابط بنجاح _☑️"
       end
		end
    if matches[1] == 'الرابط' and is_mod(msg) then
      local linkgp = data[tostring(target)]['settings']['linkgp']
      if not linkgp then
return "🌟| _اوه 🙀 لا يوجد هنا رابط_\n🌟| _رجائا اكتب [ضع رابط]_🔃"
      end
      return "🌟| رابط المجموعة  :\n🌟| اضغط هنا 👇🏿\n🌟|[{ "..escape_markdown(msg.to.title).." }]("..linkgp..")"
         
     end
  if matches[1] == "ضع القوانين" and matches[2] and is_mod(msg) then
    data[tostring(target)]['rules'] = matches[2]
	  save_data(_config.moderation.data, data)
return '🌟| _مرحبآ عزيزي_\n🌟| _تم حفظ القوانين بنجاح_☑️\n🌟| _اكتب [ القوانين ] لعرضها 💬_'
  end
  if matches[1] == "القوانين" then
 if not data[tostring(target)]['rules'] then
     rules = "🌟| _مرحبأ عزيري_ 👋🏻 _القوانين كلاتي_ 👇🏻\n🌟| _ممنوع نشر الروابط_ \n🌟| _ممنوع التكلم او نشر صور اباحيه_ \n🌟| _ممنوع  اعاده توجيه_ \n🌟| _ممنوع التكلم بلطائفه_ \n🌟| _الرجاء احترام المدراء والادمنيه _😅\n🌟| @SNaK_BoT 💤"
        else
     rules =  "*🌟|القوانين :*\n"..data[tostring(target)]['rules']
      end
    return rules
  end

  if matches[1]:lower() == 'ضع تكرار' and is_mod(msg) then
			if tonumber(matches[2]) < 1 or tonumber(matches[2]) > 50 then
				return "🌟| _حدود التكرار ,  يجب ان تكون ما بين _ *[2-50]*"
      end
			local flood_max = matches[2]
			data[tostring(msg.to.id)]['settings']['num_msg_max'] = flood_max
			save_data(_config.moderation.data, data)
    return "🌟|_ تم وضع التكرار :_ *[ "..matches[2].." ]*"
       end

		if matches[1]:lower() == 'مسح' and is_owner(msg) then
			if matches[2] == 'الادمنيه' then
				if next(data[tostring(msg.to.id)]['mods']) == nil then
return "🌟| _اوه ☢ هنالك خطأ_ 🚸\n🌟| _عذرا لا يوجد ادمنيه ليتم مسحهم_ ☑️"
            end
				for k,v in pairs(data[tostring(msg.to.id)]['mods']) do
					data[tostring(msg.to.id)]['mods'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
return "🌟| _مرحبآ عزيزي_ \n🌟| _تم حذف الادمنيه بنجاح_ ☑️"
         end
			if matches[2] == 'قائمه المنع' then
				if next(data[tostring(msg.to.id)]['filterlist']) == nil then
					return "🌟| _عذرا لا توجد كلمات ممنوعه ليتم حذفها_ ☑️"
				end
				for k,v in pairs(data[tostring(msg.to.id)]['filterlist']) do
					data[tostring(msg.to.id)]['filterlist'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
				return "🌟| _مرحبآ عزيزي_ \n🌟| _تم حذف الكلمات الممنوعه  ☑️"
			end
			if matches[2] == 'القوانين' then
				if not data[tostring(msg.to.id)]['rules'] then
return "🌟| _اوه ☢ هنالك خطأ_ 🚸\n🌟| _عذرا لا يوجد قوانين ليتم مسحه_ ☑️"
				end
					data[tostring(msg.to.id)]['rules'] = nil
					save_data(_config.moderation.data, data)
return "🌟| _مرحبآ عزيزي_ \n🌟| _تم حذف القوانين بنجاح_ ☑️"
       end
			if matches[2] == 'الترحيب' then
				if not data[tostring(msg.to.id)]['setwelcome'] then
return "🌟| _اوه ☢ هنالك خطأ_ 🚸\n🌟| _عذرا لا يوجد ترحيب ليتم مسحه_ ☑️"
				end
					data[tostring(msg.to.id)]['setwelcome'] = nil
					save_data(_config.moderation.data, data)
return "🌟| _مرحبآ عزيزي_ \n🌟| _تم حذف الترحيب بنجاح_ ☑️"
       end
			if matches[2] == 'الوصف' then
        if msg.to.type == "group" then
				if not data[tostring(msg.to.id)]['about'] then
return "🌟| _عذرا لا يوجد وصف ليتم مسحه_ ☑️"
				end
					data[tostring(msg.to.id)]['about'] = nil
					save_data(_config.moderation.data, data)
        elseif msg.to.type == "supergroup" then
   setChatDescription(msg.to.id, "")
             end
return "🌟| _مرحبآ عزيزي_ \n🌟| _تم حذف الوصف بنجاح_ ☑️"
		   	end
        end
		if matches[1]:lower() == 'مسح' and is_sudo(msg) then
			if matches[2] == 'الاداريين' then
				if next(data[tostring(msg.to.id)]['owners']) == nil then
return "🌟| _عذرا لا يوجد مدراء ليتم مسحهم_ ☑️"
				end
				for k,v in pairs(data[tostring(msg.to.id)]['owners']) do
					data[tostring(msg.to.id)]['owners'][tostring(k)] = nil
					save_data(_config.moderation.data, data)
				end
return "🌟| _مرحبآ عزيزي_ \n🌟| _تم حذف المدراء بنجاح_ ☑️"
			end
     end
if matches[1] == "ضع اسم" and matches[2] and is_mod(msg) then
local gp_name = matches[2]
setChatTitle(msg.to.id, gp_name)
end
if matches[1] == 'ضع صوره' and is_mod(msg) then
gpPhotoFile = "./data/photos/group_photo_"..msg.to.id..".jpg"
     if not msg.caption and not msg.reply_to_message then
			data[tostring(msg.to.id)]['settings']['set_photo'] = 'waiting'
			save_data(_config.moderation.data, data)
return "🌟| _مرحبآ عزيزي_\n🌟| _رجائا الان ارسل الصورة _ 👮‍♀️"
     elseif not msg.caption and msg.reply_to_message then
if msg.reply_to_message.photo then
if msg.reply_to_message.photo[3] then
fileid = msg.reply_to_message.photo[3].file_id
elseif msg.reply_to_message.photo[2] then
fileid = msg.reply_to_message.photo[2].file_id
   else
fileid = msg.reply_to_message.photo[1].file_id
  end
downloadFile(fileid, gpPhotoFile)
sleep(1)
setChatPhoto(msg.to.id, gpPhotoFile)
    data[tostring(msg.to.id)]['settings']['set_photo'] = gpPhotoFile
    save_data(_config.moderation.data, data)
    end
  return "🌟| مرحبآ عزيزي\n🌟| تم تعين صورة المجموعة 👮‍♀️ "
     elseif msg.caption and not msg.reply_to_message then
if msg.photo then
if msg.photo[3] then
fileid = msg.photo[3].file_id
elseif msg.photo[2] then
fileid = msg.photo[2].file_id
   else
fileid = msg.photo[1].file_id
  end
downloadFile(fileid, gpPhotoFile)
sleep(1)
setChatPhoto(msg.to.id, gpPhotoFile)
    data[tostring(msg.to.id)]['settings']['set_photo'] = gpPhotoFile
    save_data(_config.moderation.data, data)
    end
  return "🌟| مرحبآ عزيزي\n🌟| تم تعين صورة المجموعة 👮‍♀️ "
		end
  end
if matches[1] == "مسح الصوره" and is_mod(msg) then
deleteChatPhoto(msg.to.id)
  return "🌟| تم حذف صورة *المجموعة* 👮‍♀️ "
end
  if matches[1] == "ضع وصف" and matches[2] and is_mod(msg) then
     if msg.to.type == "supergroup" then
   setChatDescription(msg.to.id, matches[2])
       data[tostring(msg.to.id)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
    elseif msg.to.type == "group" then
    data[tostring(msg.to.id)]['about'] = matches[2]
	  save_data(_config.moderation.data, data)
     end
     return "🌟| _تم وضع الوصف بنجاح_☑️"
  end
  if matches[1] == "الوصف" then
 if not data[tostring(msg.to.id)]['about'] then
     about =  "🌟| لا يوجد وصف للمجموعة"
        else
     about = "*🌟| وصف المجموعة :*\n"..data[tostring(chat)]['about']
      end
    return about
  end



--------------------- Welcome -----------------------
if matches[1] == "تشغيل" and is_mod(msg) then
	    local target = msg.to.id
        if matches[2] == "الردود" then
return unlock_replay(msg, data, target)
end
if matches[2] == "الترحيب" then
			welcome = data[tostring(msg.to.id)]['settings']['welcome']
		if welcome == "yes" then
return "🌟| _مرحبا عزيزي_\n🌟| _تشغيل الترحيب شغال مسبقاً_ ☑️"
			else
		data[tostring(msg.to.id)]['settings']['welcome'] = "yes"
	    save_data(_config.moderation.data, data)
return "🌟| _مرحبا عزيزي_\n🌟| _تم تشغيل الترحيب_ ☑️"
		end
	end
	if matches[2] == "التحذير" then
			lock_woring = data[tostring(msg.to.id)]['settings']['lock_woring']
		if lock_woring == "yes" then
return "🌟| _مرحبا عزيزي_\n🌟| _تشغيل التحذير شغال مسبقاً_ ☑️"
			else
		data[tostring(msg.to.id)]['settings']['lock_woring'] = "yes"
	    save_data(_config.moderation.data, data)
return "🌟| _مرحبا عزيزي_\n🌟| _تم تشغيل التحذير_ ☑️"
		end
		end
		end
if matches[1] == "ايقاف" and is_mod(msg) then
	    local target = msg.to.id
        if matches[2] == "الردود" then
        return lock_replay(msg, data, target)
        end
         if matches[2] == "الترحيب" then
    welcome = data[tostring(msg.to.id)]['settings']['welcome']
	if welcome == "no" then
	return "🌟| _مرحبا عزيزي_\n🌟| _الترحيب بالتأكيد متوقف_ ☑️"
			else
		data[tostring(msg.to.id)]['settings']['welcome'] = "no"
	    save_data(_config.moderation.data, data)
return "🌟| _مرحبا عزيزي_\n🌟| _تم ايقاف الترحيب_ ☑️"
			end
end

      if matches[2] == "التحذير" then
    lock_woring = data[tostring(msg.to.id)]['settings']['lock_woring']
	if lock_woring == "no" then
	return "🌟| _مرحبا عزيزي_\n🌟| _التحذير بالتأكيد متوقف_ ☑️"
			else
		data[tostring(msg.to.id)]['settings']['lock_woring'] = "no"
	    save_data(_config.moderation.data, data)
return "🌟| _مرحبا عزيزي_\n🌟| _تم ايقاف التحذير_ ☑️"
			end
	end
	end

	if matches[1] == "ضع الترحيب" and matches[2] and is_mod(msg) then
		data[tostring(msg.to.id)]['setwelcome'] = matches[2]
	    save_data(_config.moderation.data, data)
		return "🌟| _تم وضع الترحيب بنجاح كلاتي 👋🏻_\n*"..matches[2].."*\n\n🌟| _ملاحظه_\n🌟| _تستطيع اضهار القوانين بواسطه _ ➣ *{rules}*  \n🌟| _تستطيع اضهار الاسم بواسطه_ ➣ *{name}*\n🌟| _تستطيع اضهار المعرف بواسطه_ ➣ *{username}*"
	end
if matches[1] == "الترحيب"  and is_mod(msg) then
		if data[tostring(msg.to.id)]['setwelcome']  then
	    return data[tostring(msg.to.id)]['setwelcome']  
	    else
		return "🌟| مرحباً عزيزي 😻✋🏻 \n🌟| نـورت المجمـوعه 🌝❤️ \n🌟| ثواني من وقتك اضغط هنا ↙️ \n @SNaK_BoT"
	end
end
if matches[1]== 'رسائلي' or matches[1]=='رسايلي' then
local msgs = tonumber(redis:get('msgs:'..msg.from.id..':'..msg.to.id) or 0)
return '💬¦ عدد رسائلك : `'..msgs..'` رسالة 👮‍♀️ \n\n'
 end
----------------End Msg Matches--------------
end
local function pre_process(msg)
-- print(serpent.block(msg, {comment=false}))
local data = load_data(_config.moderation.data)
  if data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings'] and data[tostring(msg.to.id)]['settings']['set_photo'] == 'waiting' and is_mod(msg) then
gpPhotoFile = "./data/photos/group_photo_"..msg.to.id..".jpg"
    if msg.photo then
  if msg.photo[3] then
fileid = msg.photo[3].file_id
elseif msg.photo[2] then
fileid = msg.photo[2].file_id
   else
fileid = msg.photo[1].file_id
  end
downloadFile(fileid, gpPhotoFile)
sleep(1)
setChatPhoto(msg.to.id, gpPhotoFile)
    data[tostring(msg.to.id)]['settings']['set_photo'] = gpPhotoFile
    save_data(_config.moderation.data, data)
     end
		send_msg(msg.to.id, "🌟| مرحبآ عزيزي\n🌟| تم تعين صورة المجموعة 👮‍♀️ ", msg.id, "md")
  end

		local data = load_data(_config.moderation.data)
 if msg.newuser then
	if data[tostring(msg.to.id)] and data[tostring(msg.to.id)]['settings'] then
		wlc = data[tostring(msg.to.id)]['settings']['welcome']
		if wlc == "yes" and tonumber(msg.newuser.id) ~= tonumber(bot.id) then
    if data[tostring(msg.to.id)]['setwelcome'] then
     welcome = data[tostring(msg.to.id)]['setwelcome']
      else
	welcome = "🌟| مرحباً عزيزي 😻✋🏻 \n🌟| نـورت المجمـوعه 🌝❤️ \n🌟| ثواني من وقتك اضغط هنا ↙️ \n @SNaK_BoT"

end
 if data[tostring(msg.to.id)]['rules'] then
rules = data[tostring(msg.to.id)]['rules']
else
     rules = "🌟| _مرحبأ عزيري_ 👋🏻 _القوانين كلاتي_ 👇🏻\n🌟| _ممنوع نشر الروابط_ \n🌟| _ممنوع التكلم او نشر صور اباحيه_ \n🌟| _ممنوع  اعاده توجيه_ \n🌟| _ممنوع التكلم بلطائفه_ \n🌟| _الرجاء احترام المدراء والادمنيه _😅\n🌟| @SNaK_BoT 💤"
end
if msg.newuser.username then
user_name = "@"..check_markdown(msg.newuser.username)
else
user_name = ""
end
		welcome = welcome:gsub("{rules}", rules)
		welcome = welcome:gsub("{name}", escape_markdown(msg.newuser.print_name))
		welcome = welcome:gsub("{username}", user_name)
		welcome = welcome:gsub("{gpname}", msg.to.title)
		send_msg(msg.to.id, welcome, msg.id, "md")
        end
		end
	end
 if msg.newuser then
 if msg.newuser.id == bot.id then
   local rsala = [[🤖| اهلا بك في سـورس تشـارلـي 🌝❤️
💧|لحماية المجموعات بحمايتي القصوى 
🎽|راسل المطور لتفعيل حمايتي في مجموعتك ...]]
	sendPhoto(msg.to.id, "data/photos/TSHARLY.jpg", rsala, msg.id)
end
end
end
return {
  patterns = {
"^(تفعيل)$",
"^(تعطيل)$",
"^(رفع المدير)$",
"^(تنزيل المدير)$",
"^(رفع المدير) (.*)$",
"^(تنزيل المدير) (.*)$",
"^(رفع ادمن)$",
"^(تنزيل ادمن)$",
"^(رفع ادمن) (.*)$",
"^(تنزيل ادمن) (.*)$",
"^(رفع عضو مميز)$",
"^(تنزيل عضو مميز)$",
"^(رفع عضو مميز) (.*)$",
"^(تنزيل عضو مميز) (.*)$",
"^(الاعضاء المميزين)$",
"^(قفل) (.*)$",
"^(فتح) (.*)$",
"^(الحمايه)$",
"^(منع) (.*)$",
"^(الغاء المنع) (.*)$",
"^(قائمه المنع)$",
"^(الاداريين)$",
"^(الادمنيه)$",
"^(ضع القوانين) (.*)$",
"^(القوانين)$",
"^(ضع رابط)$",
"^(الرابط)$",
"^(تغيير الرابط)$",
"^(ضع صوره)$",
"^(مسح الصوره)$",
"^(ايدي)$",
"^(ايدي) (.*)$",
"^(مسح) (.*)$",
"^(ضع اسم) (.*)$",
"^(الترحيب)$",
"^(تشغيل) (.*)$",
"^(ايقاف) (.*)$",
"^(ضع الترحيب) (.*)$",
"^(تثبيت)$",
"^(الغاء التثبيت)$",
"^(الوصف)$",
"^(رسائلي)$",
"^(رسايلي)$",
"^(ضع وصف) (.*)$",
"^(ضع تكرار) (%d+)$",
"^([https?://w]*.?telegram.me/joinchat/%S+)$",
"^([https?://w]*.?t.me/joinchat/%S+)$"
},
  run = phplua,
  pre_process = pre_process
}
