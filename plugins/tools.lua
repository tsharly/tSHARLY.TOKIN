local function getindex(t,id) 
for i,v in pairs(t) do 
if v == id then 
return i 
end 
end 
return nil 
end

local function reload_plugins( ) 
  plugins = {} 
  load_plugins() 
end

--By @blcon
local function already_sudo(user_id)
  for k,v in pairs(_config.sudo_users) do
    if user_id == v then
      return k
    end
  end
  -- If not found
  return false
end

--By @SoLiD
local function sudolist(msg)
local sudo_users = _config.sudo_users
text = "*💢¦ قائمه المطورين : *\n"
for i=1,#sudo_users do
    text = text..i.." - "..sudo_users[i].."\n"
end
return text
end


local function chat_list(msg)
	i = 1
	local data = load_data(_config.moderation.data)
    local groups = 'groups'
    if not data[tostring(groups)] then
        return 'لا يوجد مجموعات مفعلة حاليا .'
    end
    local message = '💢¦ قـائمـه الـكـروبـات :\n\n'
    for k,v in pairsByKeys(data[tostring(groups)]) do
		local group_id = v
		if data[tostring(group_id)] then
			settings = data[tostring(group_id)]['settings']
		end
        for m,n in pairsByKeys(settings) do
			if m == 'set_name' then
				name = n:gsub("", "")
				chat_name = name:gsub("‮", "")
				 group_name_id = name .. ' \n* ايدي : [<code>' ..group_id.. '</code>]\n'

					group_info = i..' ـ '..group_name_id

				i = i + 1
			end
        end
		message = message..group_info
    end
	send_msg(msg.to.id, message,nil,"html")
end

local function botrem(msg)
	local data = load_data(_config.moderation.data)
	data[tostring(msg.to.id)] = nil
	save_data(_config.moderation.data, data)
	local groups = 'groups'
	if not data[tostring(groups)] then
		data[tostring(groups)] = nil
		save_data(_config.moderation.data, data)
	end
	data[tostring(groups)][tostring(msg.to.id)] = nil
	save_data(_config.moderation.data, data)
	if redis:get('CheckExpire::'..msg.to.id) then
		redis:del('CheckExpire::'..msg.to.id)
	end
	if redis:get('ExpireDate:'..msg.to.id) then
		redis:del('ExpireDate:'..msg.to.id)
	end
  leave_group(msg.to.id)
end

local function warning(msg)
local expiretime = redis:ttl('ExpireDate:'..msg.to.id)
if expiretime == -1 then
return
else
local d = math.floor(expiretime / 86400) + 1
if tonumber(d) == 1 and not is_sudo(msg) and is_mod(msg) then
send_msg(msg.to.id,'💢¦ يرجى التواصل مع مطور البوت لتجديد اشتراك البوت والا ساخرج تلقائيا ‼️', msg.id, 'md')
end
end
end
local function pre_process(msg)
if msg.to.type ~= 'private' then
local data = load_data(_config.moderation.data)
local gpst = data[tostring(msg.to.id)]
local chex = redis:get('CheckExpire::'..msg.to.id)
local exd = redis:get('ExpireDate:'..msg.to.id)
if gpst and not chex and msg.from.id ~= sudo_id and not is_sudo(msg) then
redis:set('CheckExpire::'..msg.to.id,true)
redis:set('ExpireDate:'..msg.to.id,true)
redis:setex('ExpireDate:'..msg.to.id, 86400, true)
send_msg(msg.to.id, '💢¦_تم دعم المجموعه لمده يوم واحد يرجى التحدث مع مطوري لتجديد الوقت_',msg.id,'md')
end
if chex and not exd and msg.from.id ~= sudo_id and not is_sudo(msg) then
local text1 = '💢¦ اشتراك المجموعه انتهى💢 \n💢¦ '..msg.to.title..'\n\nID:  <code>'..msg.to.id..'</code>\nاذا تريد البوت ان يترک المجموعه نفذ هذا الامر التالي\n\nغادر + '..msg.to.id..'\nلدخول هذا المجموعه اتبع الامر :\nدخول + '..msg.to.id..'\n_________________\nعندما تريد تفعيل الاشتراك في المجموعه اتبع الامر الاتي :💢...\n\n<b>للاشتراك لمدة شهر:</b>\nالاشتراك 1 '..msg.to.id..'\n\n<b>للاشتراك لمدة 3 اشهر:</b>\nالاشتراك 2 '..msg.to.id..'\n\n<b>للاشتراك بدون حدود💢💢💢💢:</b>\nالاشتراك 3 '..msg.to.id
local text2 = '💢¦ الاشتراك في هذه المجموعه انتهى \n💢¦ سيخرج البوت تلقائيامن المجموعه \n💢¦ لتفعيل الاشتراك مجددا راسل المطور @blcon.'
send_msg(sudo_id, text1, nil, 'html')
send_msg(msg.to.id, text2, msg.id, 'html')
botrem(msg)
else
local expiretime = redis:ttl('ExpireDate:'..msg.to.id)
local day = (expiretime / 86400)
if tonumber(day) > 0.208 and not is_sudo(msg) and is_mod(msg) then
warning(msg)
end
end
end
end


local function run(msg, matches)


if msg.to.type == 'supergroup' or msg.to.type == 'group' then
if matches[1] == 'شحن' and matches[2] and not matches[3] and is_sudo(msg) then
if tonumber(matches[2]) > 0 and tonumber(matches[2]) < 1001 then
local extime = (tonumber(matches[2]) * 86400)
redis:setex('ExpireDate:'..msg.to.id, extime, true)
if not redis:get('CheckExpire::'..msg.to.id) then
redis:set('CheckExpire::'..msg.to.id)
end
send_msg(msg.to.id, '💢¦تم شحن الاشتراك ل [<code>'..matches[2]..'</code>] يوم ⌚️',msg.id, 'html')
send_msg(sudo_id, ' 💢¦تم تمديد فترة الاشتراك لـ[<code>'..matches[2]..'</code>].\n 💢¦ في المجموعة [<code>'..msg.to.title..'</code>]',msg.id, 'html')
else
send_msg(msg.to.id,  '_ اختر من 1 الى 1000 فقط ⌚️    ._',msg.id, 'md')
end
end

if matches[1]:lower() == 'الاشتراك' and is_mod(msg) and not matches[2] then
local expi = redis:ttl('ExpireDate:'..msg.to.id)
if expi == -1 then
	send_msg(msg.to.id, '_المجموعة مفعله مدى الحياة⌚️_', msg.id, 'md')
else
local day = math.floor(expi / 86400) + 1
	if day == 1 then
	day = 'يوم واحد' 
	elseif day == 2 then
   	day = 'يومين'
	elseif day == 3 then
   	day = '3 ايام'
   	else
	day = day..' يوم'
end
 send_msg(msg.to.id, '💢¦ باقي '..day..' وينتهي اشتراك البوت 💯', msg.id, 'md')
end
end


if matches[1]:lower() == 'الاشتراك' and matches[2] == '1' and not matches[3] then
			local timeplan1 = 2592000
			redis:setex('ExpireDate:'..msg.to.id, timeplan1, true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end
send_msg(sudo_id, '💢¦ تم تفعيل المجموعة [<code>'..msg.to.title..'</code>]\n💢¦الاشتراك : شهر واحد 🛠 )', msg.id, 'html')
send_msg(msg.to.id, '💢¦ تم تفعیل المجموعه ستبقی صالحة الی 30 یوم⌚️', msg.id, 'md')
		end
if matches[1]:lower() == 'الاشتراك' and matches[2] == '2' and not matches[3] then
			local timeplan2 = 7776000
			redis:setex('ExpireDate:'..msg.to.id,timeplan2,true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end
send_msg(sudo_id, '💢¦ تم تفعيل المجموعة [<code>'..msg.to.title..'</code>]\n💢¦ الاشتراك : 3 اشهر 🛠 )', msg.id, 'html')
send_msg(msg.to.id, '💢¦ تم تفعيل البوت بنجاح وصلاحيته لمدة 90 يوم  )', msg.id, 'md')
		end
if matches[1]:lower() == 'الاشتراك' and matches[2] == '3' and not matches[3] then
			redis:set('ExpireDate:'..msg.to.id,true)
			if not redis:get('CheckExpire::'..msg.to.id) then
				redis:set('CheckExpire::'..msg.to.id,true)
			end
send_msg(sudo_id, '💢¦ تم تفعيل المجموعة [<code>'..msg.to.title..'</code>]\n💢¦ الاشتراك : مدى الحياه', msg.id, 'html')
send_msg(msg.to.id, '💢¦ تم تفعيل البوت بنجاح وصلاحيته مدى الحياه )', msg.id, 'md')
end
end


    local data = load_data(_config.moderation.data)
   if matches[1] == "المطورين" and is_sudo(msg) then
    return sudolist(msg)
   end
  if tonumber(msg.from.id) == tonumber(sudo_id) then
   if matches[1] == "رفع مطور" then
   if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if already_sudo(tonumber(msg.reply.id)) then
    return "💢¦ _العضو_ : "..username.." \n💢¦ _الايدي_ :  ["..msg.reply.id.."]\n💢¦ انه بالتاكيد مطور"
    else
          table.insert(_config.sudo_users, tonumber(msg.reply.id)) 
      print(msg.reply.id..' added to sudo users') 
     save_config() 
     reload_plugins(true) 
    return "💢¦ _العضو_ : "..username.." \n💢¦ _الايدي_ :  ["..msg.reply.id.."]\n💢¦ تم ترقيتة ليصبح مطور"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
   if not getUser(matches[2]).result then
   return "💢¦ لا يوجد عضو بهذا المعرف"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
   if already_sudo(tonumber(matches[2])) then
    return "💢¦ _العضو_ :   "..user_name.." ["..matches[2].."]\n💢¦ انه بالتاكيد مطور"
    else
           table.insert(_config.sudo_users, tonumber(matches[2])) 
      print(matches[2]..' added to sudo users') 
     save_config() 
     reload_plugins(true) 
    return "💢¦ _العضو_ :   "..user_name.." ["..matches[2].."] \n💢¦ تم ترقيتة ليصبح مطور"
   end
   elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
   if not resolve_username(matches[2]).result then
   return "💢¦ لا يوجد عضو بهذا المعرف"
    end
   local status = resolve_username(matches[2])
   if already_sudo(tonumber(status.information.id)) then
    return "💢¦ _العضو_ :   @"..check_markdown(status.information.username).." ["..status.information.id.."] \n💢¦ انه بالتاكيد مطور"
    else
          table.insert(_config.sudo_users, tonumber(status.information.id)) 
      print(status.information.id..' added to sudo users') 
     save_config() 
     reload_plugins(true) 
    return "💢¦ _العضو_ :   @"..check_markdown(status.information.username).." ["..status.information.id.."] \n💢¦ تم ترقيتة ليصبح مطور"
     end
  end
end
   if matches[1] == "تنزيل مطور" then
      if not matches[2] and msg.reply_to_message then
	if msg.reply.username then
	username = "@"..check_markdown(msg.reply.username)
    else
	username = escape_markdown(msg.reply.print_name)
    end
   if not already_sudo(tonumber(msg.reply.id)) then
    return "💢¦ _العضو_ : "..username.." \n💢¦ _الايدي_ :  ["..msg.reply.id.."]\n💢¦ انه بالتاكيد تم تنزيله من المطورين"
    else
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(msg.reply.id)))
		save_config()
     reload_plugins(true) 
    return "💢¦ _العضو_ : "..username.." \n💢¦ _الايدي_ :  ["..msg.reply.id.."]\n💢¦ تم تنزيله من المطورين"
      end
	  elseif matches[2] and matches[2]:match('^%d+') then
  if not getUser(matches[2]).result then
   return "💢¦ لا يوجد عضو بهذا المعرف"
    end
	  local user_name = '@'..check_markdown(getUser(matches[2]).information.username)
	  if not user_name then
		user_name = escape_markdown(getUser(matches[2]).information.first_name)
	  end
   if not already_sudo(tonumber(matches[2])) then
    return "💢¦ _العضو_ :   "..user_name.." \n💢¦ _الايدي_ :  ["..matches[2].."]\n💢¦ انه بالتاكيد تم تنزيله من المطورين"
    else
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(matches[2])))
		save_config()
     reload_plugins(true) 
    return "💢¦ _العضو_ :   "..user_name.." \n💢¦ _الايدي_ :  ["..matches[2].."] \n💢¦ تم تنزيله من المطورين"
      end
   elseif matches[2] and string.match(matches[2], '@[%a%d_]')  then
   if not resolve_username(matches[2]).result then
   return "💢¦ لا يوجد عضو بهذا المعرف"
    end
   local status = resolve_username(matches[2])
   if not already_sudo(tonumber(status.information.id)) then
    return "💢¦ _العضو_ :   @"..check_markdown(status.information.username).." \n💢¦ _الايدي_ :  ["..status.information.id.."] \n💢¦ انه بالتاكيد تم تنزيله من المطورين"
    else
          table.remove(_config.sudo_users, getindex( _config.sudo_users, tonumber(status.information.id)))
		save_config()
     reload_plugins(true) 
    return "💢¦ _العضو_ :   @"..check_markdown(status.information.username).." \n💢¦ _الايدي_ :  ["..status.information.id.."] \n💢¦ تم تنزيله من المطورين"
          end
      end
   end
end

  if is_sudo(msg) then


if matches[1] == 'المجموعات' and is_sudo(msg) then
return chat_list(msg)
    end
if matches[1] == 'تعطيل' and matches[2] and string.match(matches[2], '^%d+$') then
    local data = load_data(_config.moderation.data)
			-- Group configuration removal
			data[tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
			local groups = 'groups'
			if not data[tostring(groups)] then
				data[tostring(groups)] = nil
				save_data(_config.moderation.data, data)
			end
			data[tostring(groups)][tostring(matches[2])] = nil
			save_data(_config.moderation.data, data)
	   send_msg(matches[2], "💢¦ تم تعطيل البوت من قبل المطور للاستفسار راسل @blcon", nil, 'md')
    return '💢¦ المجموعة : *'..matches[2]..'* تم تعطيلها'
		end
     if matches[1] == 'فير توكن غادر' and is_sudo(msg) then
  leave_group(msg.to.id)
   end
     if matches[1] == 'بث' and matches[2] and string.match(matches[2], '^%d+$') and matches[3] then
		local text = matches[3]
send_msg(matches[2], text)	end
 
   if matches[1] == 'اذاعه' and matches[2]  then		
  local data = load_data(_config.moderation.data)		
  local bc = matches[2]		
  local i = 1
  for k,v in pairs(data) do				
send_msg(k, bc)
i = i+1
end	
send_msg(msg.to.id, '💢¦ تم اذاعة الرساله الى ['..i..'] مجموعة ')

end
if matches[2] == 'الخروج التلقائي' and is_sudo(msg) then
--Enable Auto Leave
     if matches[1] == 'تفعيل' then
    redis:del('AutoLeaveBot')
   return '💢¦ تم تفعيل الخروج التلقائي'
--Disable Auto Leave
     elseif matches[1] == 'تعطيل' then
    redis:set('AutoLeaveBot', true)
   return '💢¦ تم تعطيل الخروج التلقائي'
--Auto Leave Status
end
end
if matches[1] =="الخروج التلقائي" then
        if not redis:get('AutoLeaveBot') then
   return '💢¦ الخروج التلقائي: مفعل'
       else
   return '💢¦ الخروج التلقائي: معطل'
      end
    end
---------------Help Tools----------------
if matches[1]== 'رسائلي' or matches[1]=='رسايلي' then
local msgs = tonumber(redis:get('msgs:'..msg.from.id..':'..msg.to.id) or 0)
return '🗯 عدد رسائلك المرسله : [`'..msgs..'`] رساله \n\n'
 end
if matches[1]:lower() == 'معلوماتي' or matches[1]:lower() == 'موقعي'  then
if msg.from.first_name then
if msg.from.username then username = '@'..msg.from.username
else username = '<i>ما مسوي  😹💔</i>'
end
if is_sudo(msg) then rank = 'المطور مالتي 😻'
elseif is_owner(msg) then rank = 'مدير المجموعه 😽'
elseif is_admin(msg) then rank = 'اداري في البوت 😼'
elseif is_mod(msg) then rank = 'ادمن في البوت 😺'
else rank = 'مجرد عضو 😹'
end
local text = '<b>💯️¦ اهـلا بـك معلوماتك :</b>\n\n<b>💢¦ الاسم الاول :</b> <i>'..msg.from.first_name
..'</i>\n<b>💢¦ الاسم الثاني :</b> <i>'..(msg.from.last_name or "---")
..'</i>\n<b>💢¦ المعرف:</b> '..username
..'\n<b>💢¦ الايدي :</b> [ <code>'..msg.from.id
..'</code> ]\n<b>💢¦ ايدي الكروب :</b> [ <code>'..msg.to.id
..'</code> ]\n<b>💢¦ موقعك :</b> <i>'..rank
..'</i>\n💢¦ مـطـور الـسـورس : @blcon\n💢¦ قـنـاه الـسـورس : @verxbot'
tdcli.sendMessage(msg.to.id, msg.id_, 1, text, 1, 'html')
end
end



if matches[1] == "الاوامر" then
if not is_mod(msg) then return "💢¦ للاداريين فقط 🎖" end
return 'مـرحـ(👋)ـبـا يـا '..msg.from.first_name..'\n'..[[
الاوامـر الـ؏ـامـة
✥-----------------⚜✮⚜-----------------✥
💢¦ م1 ➙ اوامر الادارة
💢¦ م2 ➙ اوامر اعدادات المجموعه
💢¦ م3 ➙ اوامر الحـمـايـة
💢¦ م4 ➙ الاوامـر الـ؏ـامـة
💢¦ م المطور ➙ اوامر المطور
💢¦ اوامر الرد ➙ لاضافه رد معين

❖••••••••••••••⚜❂⚜••••••••••••••❖
راسلني للاستفسار 💡↭ @blcon
]]
end

if matches[1]== 'م1' then
if not is_mod(msg) then return "💢¦ للاداريين فقط 🎖" end
return [[
🎖  اوامر الرفع والتنزيل📍
✥-----------------⚜️✮⚜️-----------------✥

💢¦ رفع ادمن : لرفع ادمن في البوت
💢¦ تنزيل ادمن : لتنزيل ادمن من البوت
💢¦ رفع عضو مميز : لرفع عضو مميز في البوت
💢¦ تنزيل عضو مميز : لتنزيل عضو مميز من البوت
💢¦ الادمنيه : لعرض قائمة الادمنيه
💢¦ الاداريين : لعرض قائمة الاداريين

✥-----------------⚜️✮⚜️-----------------✥
💬 اوامر الطرد والحضر 🀄️

💢¦ بلوك بالرد : لطرد العضو من المجموعه
💢¦ حظر : لحظر وطرد عضو من المجموعه 
💢¦ الغاء الحظر : لالغاء الحظر عن عضو 
💢¦ منع : لمنع كلمه داخل المجموعه
💢¦ الغاء منع : لالغاء منع الكلمه  
💢¦ كتم  : لكتم عضو بواسطة الرد
💢¦ الغاء الكتم  : لالغاء الكتم بواسطة الرد

✥-----------------⚜️✮⚜️-----------------✥
راسلني للاستفسار 💡↭ @blcon
]]
end

if matches[1]== 'م2' then
if not is_mod(msg) then return "💢¦ للاداريين فقط 🎖" end
return [[
📌 اوامر الوضع للمجموعه 🀄️
✥-----------------⚜️✮⚜️-----------------✥

💢¦ ضع الترحيب + الكلمه  :↜ لوضع ترحيب  
💢¦ ضع قوانين :↜ لوضع قوانين 
💢¦ ضع وصف :↜ لوضع وصف  
💢¦ ضـع رابط :↜ لوضع الرابط  
💢¦ الـرابـط  خاص :↜  لارسال الرابط  خاص
💢¦ الـرابـط :↜  لعرض الرابط  

✥-----------------⚜️✮⚜️-----------------✥
📌 اوامر رؤية الاعدادات 🀄️

💢¦ القوانين : لعرض  القوانين 
💢¦ الادمنيه : لعرض  الادمنيه 
💢¦ الاداريين : لعرض  الاداريين 
💢¦ المكتومين :↜لعرض  المكتومين 
💢¦ المطور : لعرض معلومات المطور 
💢¦ معلوماتي :↜لعرض معلوماتك  
💢¦ الحمايه : لعرض اعدادات المجموعه 
💢¦ الوسائط : لعرض اعدادات الميديا 
💢¦ المجموعه : لعرض معلومات المجموعه 
✥-----------------⚜️✮⚜️-----------------✥
راسلني للاستفسار 💡↭ @blcon
]]
  end

if matches[1]== 'م3' then
if not is_mod(msg) then return "💢¦ للاداريين فقط 🎖" end
return [[
⚡️ اوامر حماية المجموعه ⚡️

✥-----------------⚜️✮⚜️-----------------✥

💢¦️ قفل ┇ فتح :  التثبيت
💢¦️ قفل ┇ فتح :  التعديل
💢¦️ قفل ┇ فتح :  البصمات
💢¦️ قفل ┇ فتح :  الــفيديو
💢¦️ قفل ┇ فتح : الـصـوت 
💢¦️ قفل ┇ فتح :  الـصــور 
💢¦️ قفل ┇ فتح :  الملصقات
💢¦️ قفل ┇ فتح :  المتحركه
💢¦️ قفل ┇ فتح : الدردشه
💢¦️ قفل ┇ فتح : الملصقات
💢¦️ قفل ┇ فتح : الروابط
💢¦️ قفل ┇ فتح : التاك
💢¦️ قفل ┇ فتح : البوتات
💢¦️ قفل ┇ فتح : الكلايش
💢¦️ قفل ┇ فتح : التكرار
💢¦️ قفل ┇ فتح :  التوجيه
💢¦️ قفل ┇ فتح : الجهات 
💢¦️ قفل ┇ فتح : المجموعه 
💢¦️ قفل ┇ فتح : الــكـــل
✥-----------------⚜️✮⚜️-----------------✥

📌¦ تشغيل ┇ ايقاف : الترحيب 
💬¦ تشغيل ┇ ايقاف : الردود 
📢¦ تشغيل ┇ ايقاف : التحذير
✥-----------------⚜️✮⚜️-----------------✥

راسلني للاستفسار 💡↭ @blcon
]]
end

if matches[1]== 'م4' then
if not is_mod(msg) then return "💢¦ للاداريين فقط 🎖" end
return [[
📍💭 اوامر اضافيه 🔹🚀🔹
        
✥-----------------⚜️✮⚜️-----------------✥
🕵🏻 معلوماتك الشخصيه 🙊
💢¦ اسمي : لعرض اسمك 🎈
💢¦ معرفي : لعرض معرفك 🎈
💢¦ ايديي : لعرض ايديك 🎈
💢¦ رقمي : لعرض رقمك  🎈
✥-----------------⚜️✮⚜️-----------------✥
💢¦ اوامر التحشيش 😄
📌 تحب + (اسم الشخص)
📌 بوس + (اسم الشخص) 
📌 كول + (اسم الشخص) 
📌 كله + الرد + (الكلام) 
✥-----------------⚜️✮⚜️-----------------✥
راسلني للاستفسار 💡↭ @blcon

]]
end

if matches[1]== "م المطور" then
if not is_sudo(msg) then return "💢¦ للمطوين فقط 🎖" end
return [[
⚜️🔸 اوامر المطورين 🔹⚜️

✥-----------------⚜️✮⚜️-----------------✥
💢¦ تفعيل  : لتفعيل البوت 
💢¦ تعطيل : لتعطيل البوت 
💢¦ اذاعه : لنشر كلمه 
💢¦ فير غادر : لطرد البوت
💢¦ صنع مجموعه : لصنع مجموعه 
💢¦ سوبر : لجعل المجموعه خارقه
💢¦ مسح الادمنيه : لمسح الادمنيه 
💢¦ مسح الاداريين : لمسح الاداريين 
✥-----------------⚜️✮⚜️-----------------✥
💢¦ تحديث: لتحديث ملفات البوت

✥-----------------⚜️✮⚜️-----------------✥
راسلني للاستفسار 💡↭ @blcon
]]
end

if matches[1]== 'اوامر الرد' then
return [[
💬¦ جميع اوامر الردود 
✥-----------------⚜️✮⚜️-----------------✥

💢¦ الردود : لعرض الردود المثبته
💢¦ رد اضف  + الرد : لأضافت رد جديد
💢¦ رد مسح  + الرد المراد مسحه
💢¦ رد مسح الكل : لمسح الكل

✥-----------------⚜️✮⚜️-----------------✥
💢¦ راسلني للاستفسار 💡↭ @blcon

]]
end
if matches[1]=="=" then
--keyboard = {}
  local keyboard = {{"المطور 🍃💯"},{"عـﮩـموري ┇σмαя✿♬💗✨℡ ِ "},{"قناة مطــور البوت 💬"}}

  keyboard.inline_keyboard = {
{
{text= 'للمطورين (TG_NEW)💯 ♻️' ,url = 'https://t.me/joinchat/FQPEkkOWEwSY2fd-ybsvDg'}
}					
}
tkey = [[💢¦ مٌرَحُبّاً انَا بّوَتْ اسِمٌيَ ڤــيَــرَ 🎖
💢¦ اٌختْصّاصّيَ حُمٌايَةِ كِرَوَبّاتْ
💢¦¦مٌنَ الُسِبّامٌ وَالُوَسِائطِ وَالُتْكِرَارَ وَالٌُخ...
💢¦ مطور البوت : @blcon]]
send_key(msg.chat.id, tkey, keyboard, msg.message_id, "html")
end
    
    
    
end
end
return {
  patterns = {
    "^(م المطور)$", 
    "^(=)$", 
    "^(اوامر الرد)$", 
    "^(الاوامر)$", 
    "^(م1)$", 
    "^(م2)$", 
    "^(م3)$", 
    "^(م4)$", 
    "^(رسائلي)$",
    "^(رسايلي)$",
    "^(معلوماتي)$",
    "^(رفع مطور)$",
    "^(تنزيل مطور)$",
    "^(رفع مطور) (.*)$",
    "^(تنزيل مطور) (.*)$",
    "^(المطورين)$",
    "^(المجموعات)$",
    "^(الاشتراك)$",
    "^(الاشتراك) ([123])$",
    "^(شحن) (%d+)$",
    "^(بث) (-%d+) (.*)$",
    "^(اذاعه) (.*)$",
    "^(فير توكن غادر)$",
    "^(الخروج التلقائي)$",
    "^(تفعيل) (.*)$",
    "^(تعطيل) (.*)$",

    },
  run = run,
  pre_process = pre_process
}
