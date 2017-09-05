--Begin msg_checks.lua By @blcon  ch_| @verxbot
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
if data[tostring(chat)] then
if data[tostring(chat)]['settings']['time_check'] then
TIME_CHECK = tonumber(data[tostring(chat)]['settings']['time_check'])
end
end
if is_channel or is_chat then
if msg.text then
if msg.text:match("(.*)") then
if not data[tostring(msg.to.id)] and not redis:get(auto_leave) and not is_admin(msg) then
send_msg(msg.to.id, "💢¦  _هذه المجموعه لست في قائمة _ *مجموعاتي*", nil, "md")
leave_group(chat)
end
end
end
if data[tostring(chat)] and data[tostring(chat)]['mutes'] then
mutes = data[tostring(chat)]['mutes']
else
return
end
	if mutes.mute_all then
		mute_all = mutes.mute_all
	else
		mute_all = 'no'
	end
	if mutes.mute_gif then
		mute_gif = mutes.mute_gif
	else
		mute_gif = 'no'
	end
   if mutes.mute_photo then
		mute_photos = mutes.mute_photo
	else
		mute_photos = 'no'
	end
	if mutes.mute_sticker then
		mute_sticker = mutes.mute_sticker
	else
		mute_sticker = 'no'
	end
	if mutes.mute_contact then
		mute_contact = mutes.mute_contact
	else
		mute_contact = 'no'
	end
	if mutes.mute_text then
		mute_text = mutes.mute_text
	else
		mute_text = 'no'
	end
	if mutes.mute_forward then
		mute_forward = mutes.mute_forward
	else
		mute_forward = 'no'
	end
	if mutes.mute_location then
		mute_location = mutes.mute_location
	else
		mute_location = 'no'
	end
   if mutes.mute_document then
		mute_document = mutes.mute_document
	else
		mute_document = 'no'
	end
	if mutes.mute_voice then
		mute_voice = mutes.mute_voice
	else
		mute_voice = 'no'
	end
	if mutes.mute_audio then
		mute_audio = mutes.mute_audio
	else
		mute_audio = 'no'
	end
	if mutes.mute_video then
		mute_video = mutes.mute_video
	else
		mute_video = 'no'
	end
	if mutes.mute_tgservice then
		mute_tgservice = mutes.mute_tgservice
	else
		mute_tgservice = 'no'
	end
	if data[tostring(chat)] and data[tostring(chat)]['settings'] then
		settings = data[tostring(chat)]['settings']
	else
		return
	end
	if settings.lock_link then
		lock_link = settings.lock_link
	else
		lock_link = 'no'
	end
	if settings.lock_bots then
		lock_bot = settings.lock_bots
	else
		lock_bot = 'no'
	end
	if settings.lock_tag then
		lock_tag = settings.lock_tag
	else
		lock_tag = 'no'
	end
	if settings.lock_pin then
		lock_pin = settings.lock_pin
	else
		lock_pin = 'no'
	end
	if settings.lock_mention then
		lock_mention = settings.lock_mention
	else
		lock_mention = 'no'
	end
	if settings.lock_edit then
		lock_edit = settings.lock_edit
	else
		lock_edit = 'no'
	end
	if settings.lock_spam then
		lock_spam = settings.lock_spam
	else
		lock_spam = 'no'
	end
	if settings.flood then
		lock_flood = settings.flood
	else
		lock_flood = 'no'
	end
	if settings.lock_markdown then
		lock_markdown = settings.lock_markdown
	else
		lock_markdown = 'no'
	end
	if settings.lock_webpage then
		lock_webpage = settings.lock_webpage
	else
		lock_webpage = 'no'
	end
    -- Total user msgs
local hashxmsgs = 'msgs:'..msg.from.id..':'..msg.to.id
redis:incr(hashxmsgs)

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
if not msg.cb and not is_mod(msg) and not is_whitelist(msg.from.id, msg.to.id) then


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
send_msg(chat, "💢¦ _العضو_ :  "..user_name.."\n 💢¦_ الايدي_ : ["..user.."]\n💢¦_  عذرا ممنوع التكرار في هذه المجموعه لقد تم طردك ??_\n💢¦  مـطـور الـسـورس : عمر السراي ?? ", nil, "md")
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
send_msg(msg.to.id, '<b>💢¦  الايدي :</b> <code>'..msg.from.id..'</code>\n<b>💢¦  المعرف :</b> '..usernamex..'\n<i>💢¦ عذرا التثبيث في هذه المجموعه مقفل ?  </i>', msg.id, "html")
end
end

if msg.message_edited and lock_edit == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif msg.fwd_from and mute_forward == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif msg.text then
local link_msg = msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Mm][Ee]/") or msg.text:match("[Tt][Ee][Ll][Ee][Gg][Rr][Aa][Mm].[Dd][Oo][Gg]/") or msg.text:match("[Tt].[Mm][Ee]/") or msg.text:match("[Tt][Ll][Gg][Rr][Mm].[Mm][Ee]/")

if string.len(msg.text) > 450 and lock_spam == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif link_msg and lock_link == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif ( msg.text:match("@") or msg.text:match("#")) and lock_tag == "yes" then
 del_msg(chat, tonumber(msg.id))
elseif is_filter(msg, msg.text) then
 del_msg(chat, tonumber(msg.id))
elseif mute_text == "yes" then
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

end


end
end
end
end
return {
	patterns = {},
	pre_process = pre_process
}
--End msg_checks.lua @blcon  ch | @verxbot
