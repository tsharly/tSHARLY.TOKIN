--Begin msg_checks.lua By @TH3BOSS  ch_| @lBOSSl
local function pre_process(msg)
if not msg.query then
local status = getChatAdministrators(msg.to.id)
local data = load_data(_config.moderation.data)
local chat = msg.to.id
local user = msg.from.id
local is_channel = msg.to.type == "supergroup"
local is_chat = msg.to.type == "group"
local auto_leave = 'AutoLeaveBot'
local TIME_CHECK = 2
if is_channel or is_chat then
if msg.text and msg.text:match("(.*)") then
if not data[tostring(msg.to.id)] and not redis:get(auto_leave) and not is_sudo(msg) then
send_msg(msg.to.id, "🌟|  سوف اغادر _ المجموعه ليست  في قائمة _ *مجموعاتي* ", nil, "md")
leave_group(chat)
end
end

if data[tostring(chat)] then
mutes = data[tostring(chat)]['mutes']
settings = data[tostring(chat)]['settings']
else
return
end

if msg.newuser then
if msg.newuser.username ~= nil then
if string.sub(msg.newuser.username:lower(), -3) == 'bot' and not is_owner(msg) and lock_bot == "yes" then
kick_user(msg.newuser.id, chat)
end
end
end

if msg.service and mute_tgservice == "yes" then
del_msg(chat, tonumber(msg.id))
end

-- Total user msgs
if not msg.cb and msg.text then
local hashxmsgs = 'msgs:'..msg.from.id..':'..msg.to.id
redis:incr(hashxmsgs)
end

if not msg.cb and not is_mod(msg) and not is_whitelist(msg.from.id, msg.to.id) then

if is_silent_user(msg.from.id, msg.to.id) then
del_msg(chat, tonumber(msg.id))
return
end

if msg.to.type ~= 'private'  then

if lock_flood == "yes" then
local hash = 'user:'..user..':msgs'
local msgs = tonumber(redis:get(hash) or 0)
local NUM_MSG_MAX = 5
if data[tostring(chat)] then
if data[tostring(chat)]['settings']['num_msg_max'] then
NUM_MSG_MAX = tonumber(data[tostring(chat)]['settings']['num_msg_max'])
end
end
if msgs > NUM_MSG_MAX then
if msg.from.username then
user_name = "@"..check_markdown(msg.from.username)
else
user_name = escape_markdown(msg.from.first_name)
end
if not redis:get('sender:'..user..':flood') then
del_msg(chat, msg.id)
kick_user(user, chat)
send_msg(chat, "🌟| _العضو_ :  "..user_name.."\n 🌟|_ الايدي_ : ["..user.."]\n🌟|_  عذرا ممنوع التكرار في هذه المجموعه لقد تم طردك 👮‍♀️_\n🌟|  مـطـور الـسـورس : الـزعـيـم محمد هشام  👮‍♀️ ", nil, "md")
redis:setex('sender:'..user..':flood', 30, true)
end
end
redis:setex(hash, TIME_CHECK, msgs+1)
end
end

if msg.pinned_message and is_channel then
if lock_pin == "yes" and not is_owner(msg) then
local pin_msg = data[tostring(msg.to.id)]['pin']
if pin_msg then
pinChatMessage(msg.to.id, pin_msg)
elseif not pin_msg then
unpinChatMessage(msg.to.id)
end
send_msg(msg.to.id, '<b>🌟|  الايدي :</b> <code>'..msg.from.id..'</code>\n<b>🌟|  المعرف :</b> '..usernamex..'\n<i>🌟| عذرا التثبيث في هذه المجموعه مقفل ?  </i>', msg.id, "html")
end
end

if msg.message_edited and lock_edit == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif msg.fwd_from and mute_forward == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif msg.text then
local link_msg = msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.text:match("[Tt].[Mm][Ee]/") or msg.text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")
if mute_text == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif string.len(msg.text) > 450 and lock_spam == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif link_msg and lock_link == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif ( msg.text:match("@") or msg.text:match("#")) and lock_tag == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif is_filter(msg, msg.text) then
 del_msg(chat, tonumber(msg.id))
end

elseif msg.photo and mute_photos == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif msg.video and mute_video == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif msg.document and mute_document == "yes" and msg.document.mime_type ~= "audio/mpeg" and msg.document.mime_type ~= "video/mp4" then
 del_msg(chat, tonumber(msg.id))
elseif msg.sticker and mute_sticker == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif msg.document and msg.document.mime_type == "video/mp4" and mute_gif == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif msg.contact and mute_contact == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif msg.location and mute_location == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif msg.voice and mute_voice == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif msg.document and msg.document.mime_type == "audio/mpeg" and mute_audio == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif msg.caption then
local link_caption = msg.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.caption:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.caption:match("[Tt].[Mm][Ee]/") or msg.caption:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")

if link_caption and lock_link == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif (msg.caption:match("@") or msg.caption:match("#")) and lock_tag == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif is_filter(msg, msg.caption) then
 del_msg(chat, tonumber(msg.id))
end

elseif msg.entities then
  for i,entity in pairs(msg.entities) do

if entity.type == "url" or entity.type == "text_link" then
if lock_webpage == "yes" then
 del_msg(chat, tonumber(msg.id))
end
end

if entity.type == "bold" or entity.type == "code" or entity.type == "italic" then
if lock_markdown == "yes" then
del_msg(chat, tonumber(msg.id))
end
end
end


end


end
end
end
end
return {
	patterns = {},
	pre_process = pre_process
}
--End msg_checks.lua @TH3BOSS  ch | @lBOSSl
