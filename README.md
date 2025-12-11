# Video-to-Plasma-SplashScreen
A solution that can **easily** convert your `.mp4` video to KDE Plasma Splash Screen！

轻松将你的 `.mp4` 视频转换成 KDE Plasma 的 Splash Screen！

---

## 1. Dependency
- Arch Linux

```bash
sudo pacman -S qt5-base qt5-declarative qt5-quickcontrols ffmpeg
```

---

## 2. User Guide

- Step1: clone this project to your device

```bash
git clone https://github.com/ziheng5/Video-to-Plasma-SplashScreen
```

- Step2: use the `create.sh`

```bash
cd Video-to-Plasma-SplashScreen
bash ./create.sh
```

- Step3: enter correct variables according to the tips on your shell
```bash
# Output belike:
Step[1/7]: Please enter your 'author_name': author1
Step[2/7]: Please enter your 'work_name': work1
Step[3/7]: Please enter your mp4 video path (enter 'exit' to exit): 
/home/lengyu/Videos/megma.mp4
>> 🐱 Nya~ Video founded!
Step[4/7]: Please enter the period of your video as the splash screen (Format: 'hh:mm:ss~hh:mm:ss', less than 5 seconds recommanded):
00:00:00~00:00:04
Step[5/7]: Please enter the FPS of your splash screen you want (Format: 'fps', 30~120 recommanded): 
60
Step[6/7]: Please enter the scale of your splash screen (Format: 'width_scale', 1920 recommanded):
1920
>> Creating the palette...
>> Creating the gif...(Just wait a moment, it depends on the period you entered in Step4)
Step[7/7]: Enter a png picture path as your work's previews image. (enter 'skip' to skip)
skip
>> 🐱 Nya~ Skip now. If you want to add a previews image to your work, put your picture under: ~/.local/share/plasma/look-and-feel/your_work/contents/previews/splash.png (Take care! The name of your previous image must be 'splash.png'!)
>> 🐱 Nya~ Your work has been created here: '/home/lengyu/.local/share/plasma/look-and-feel/author1.work1'
```

- Step4: now you can find the Splash Screen you created following `System Settings > Colors & Themes > Splash Screen > your_work_name`, and the path to your work is `~/.local/share/plasma/look-and-feel/your_work_name`
