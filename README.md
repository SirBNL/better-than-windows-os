# Better Than Windows OS — کیت ساخت ISO

یک توزیع زنده‌ی لینوکس (مبتنی بر **Debian Bookworm + XFCE**) با ظاهرِ کاملاً شبیه **ویندوز ۷**:
تسک‌بار پایین، منوی Start، تم و آیکونِ ویندوز ۷، صفحه‌ی ورود و بوت‌اسپلش و والپیپرِ برندشده با نام **«Better Than Windows OS»**.

خروجی نهایی: یک فایل **`.iso` بوتیبل** (BIOS و UEFI).

---

## نیازمندی‌ها
- یک سیستم **Debian یا Ubuntu** (یا **WSL** با Debian/Ubuntu روی ویندوز)
- دسترسی root (sudo)
- ~۱۰ گیگابایت فضای آزاد و اتصال اینترنت (حدود ۱ تا ۲ گیگابایت دانلود)

## ساخت ISO (یک دستور)
```bash
# اگر فایل‌ها از ویندوز کپی شده‌اند، اول این یک خط را اجرا کنید (اصلاح line-ending):
sudo apt-get update && sudo apt-get install -y dos2unix && find . -type f -print0 | xargs -0 dos2unix -q

chmod +x build.sh
sudo ./build.sh
```
بعد از پایان (۲۰ تا ۶۰ دقیقه)، فایل ISO در همین پوشه ساخته می‌شود:
`live-image-amd64.hybrid.iso`

## تست سریع بدون نصب
```bash
qemu-system-x86_64 -m 2048 -cdrom live-image-amd64.hybrid.iso
```
یا ISO را با Rufus/balenaEtcher روی فلش بریزید و سیستم را از روی آن بوت کنید.

## نصب WSL روی ویندوز (در صورت نیاز)
```powershell
wsl --install -d Debian
```
سپس ویندوز را ری‌استارت کنید، WSL را باز کنید، این پوشه را داخل آن کپی کرده و `sudo ./build.sh` را اجرا کنید.

---

## ساختار پروژه
```
better-than-windows-os/
├── build.sh                         # سازنده‌ی تک‌دستوری
├── auto/config                      # پارامترهای live-build (نام ISO، برچسب، و...)
├── config/
│   ├── package-lists/
│   │   └── desktop.list.chroot      # بسته‌ها: XFCE, LightDM, Plymouth, مرورگر و ...
│   ├── hooks/normal/
│   │   └── 0100-branding.hook.chroot# برندینگ: os-release، تم ویندوز۷، آیکون، بوت‌اسپلش
│   └── includes.chroot/             # فایل‌هایی که داخل سیستم زنده قرار می‌گیرند
│       ├── etc/lightdm/...          # ظاهر صفحه‌ی ورود
│       ├── etc/skel/.config/xfce4/  # تسک‌بار + منوی استارت + تم + والپیپر
│       └── usr/share/backgrounds/   # والپیپر اختصاصی
│       └── usr/share/plymouth/...   # بوت‌اسپلش برندشده
└── README.md
```

## یادداشت‌ها
- تمِ گرافیکی ویندوز ۷ و آیکون‌ها هنگام ساخت از پروژه‌ی متن‌بازِ **B00merang** دریافت می‌شوند؛
  اگر دسترسی به آن نبود، به‌صورت خودکار به تم **Arc** و آیکون **Papirus** برمی‌گردد (سیستم همچنان سالم ساخته می‌شود).
- نام کاربری زنده: `user` (بدون رمز / sudo فعال). نام میزبان: `better-than-windows`.
- برای تغییر نسخه/معماری یا اضافه‌کردن بسته، فایل‌های `auto/config` و `config/package-lists/desktop.list.chroot` را ویرایش کنید.
